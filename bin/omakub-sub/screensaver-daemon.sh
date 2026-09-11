#!/bin/bash

CONFIG_DIR="$HOME/.config/omakub/screensaver"
mkdir -p "$CONFIG_DIR"
OMAKUB_DIR="${OMAKUB_PATH:-$HOME/.local/share/omakub}"

RUNNER="$OMAKUB_DIR/bin/omakub-sub/screensaver-run.sh"
[ ! -f "$RUNNER" ] && RUNNER="$(dirname "$0")/screensaver-run.sh"

ALACRITTY_CONF="$HOME/.config/alacritty/screensaver.toml"
[ ! -f "$ALACRITTY_CONF" ] && ALACRITTY_CONF="$OMAKUB_DIR/configs/alacritty/screensaver.toml"

get_idle_ms() {
  local idle_out
  idle_out=$(gdbus call --session \
    --dest org.gnome.Mutter.IdleMonitor \
    --object-path /org/gnome/Mutter/IdleMonitor/Core \
    --method org.gnome.Mutter.IdleMonitor.GetIdletime 2>/dev/null)
  
  if [[ "$idle_out" =~ uint64[[:space:]]+([0-9]+) ]]; then
    echo "${BASH_REMATCH[1]}"
  else
    echo "0"
  fi
}

cleanup_daemon() {
  pkill -f "OmakubScreensaver" 2>/dev/null || true
  pkill -f "omakub-screensaver-blackout" 2>/dev/null || true
  exit 0
}
trap cleanup_daemon INT TERM EXIT

echo "Omakub screensaver daemon started."

while true; do
  # Read configured idle timeout in seconds (default: 300s = 5 minutes; 0 = disabled)
  TIMEOUT_SEC=300
  if [ -f "$CONFIG_DIR/idle_timeout" ]; then
    SAVED_SEC=$(cat "$CONFIG_DIR/idle_timeout" 2>/dev/null)
    [[ "$SAVED_SEC" =~ ^[0-9]+$ ]] && TIMEOUT_SEC="$SAVED_SEC"
  fi

  # If disabled (0), sleep and check later
  if [ "$TIMEOUT_SEC" -le 0 ]; then
    sleep 15
    continue
  fi

  IDLE_MS=$(get_idle_ms)
  THRESHOLD_MS=$((TIMEOUT_SEC * 1000))

  if [ "$IDLE_MS" -ge "$THRESHOLD_MS" ]; then
    # Only launch if not already running
    if ! pgrep -f "OmakubScreensaver" &>/dev/null; then
      echo "Idle threshold reached: ${IDLE_MS}ms >= ${THRESHOLD_MS}ms. Starting screensaver..."
      pkill -f "omakub-screensaver-blackout" 2>/dev/null || true
      
      alacritty \
        --config-file "$ALACRITTY_CONF" \
        --class OmakubScreensaver,OmakubScreensaver \
        --title "Omakub Screensaver" \
        -e bash -c "source '$RUNNER'" &
      
      SAVER_PID=$!
      
      # Grace period so the initial window creation doesn't register as user wake-up
      sleep 3

      # Monitor for mouse movement, keyboard activity, or extended idle timeout
      while kill -0 $SAVER_PID 2>/dev/null; do
        CURRENT_IDLE=$(get_idle_ms)
        
        # If user moved mouse or pressed a key (idle time dropped below 2 seconds)
        if [ "$CURRENT_IDLE" -lt 2000 ]; then
          echo "User wake-up detected (${CURRENT_IDLE}ms). Terminating screensaver..."
          kill -TERM $SAVER_PID 2>/dev/null || true
          pkill -f "OmakubScreensaver" 2>/dev/null || true
          pkill -f "omakub-screensaver-blackout" 2>/dev/null || true
          break
        fi

        # Auto-lock if left idle for an additional 5 minutes (300 seconds)
        LOCK_THRESHOLD_MS=$((THRESHOLD_MS + 300000))
        if [ "$CURRENT_IDLE" -ge "$LOCK_THRESHOLD_MS" ]; then
          echo "Extended idle reached (${CURRENT_IDLE}ms). Auto-locking session..."
          kill -TERM $SAVER_PID 2>/dev/null || true
          pkill -f "OmakubScreensaver" 2>/dev/null || true
          pkill -f "omakub-screensaver-blackout" 2>/dev/null || true
          loginctl lock-session 2>/dev/null || true
          break
        fi

        sleep 0.5
      done

      wait $SAVER_PID 2>/dev/null || true
      pkill -f "omakub-screensaver-blackout" 2>/dev/null || true
      echo "Screensaver window closed."

      # Check if lock on wake is enabled
      LOCK_ON_WAKE="false"
      if [ -f "$CONFIG_DIR/lock_on_wake" ]; then
        LOCK_ON_WAKE=$(cat "$CONFIG_DIR/lock_on_wake" 2>/dev/null)
      fi

      if [ "$LOCK_ON_WAKE" = "true" ]; then
        echo "Locking session on wake..."
        loginctl lock-session 2>/dev/null || true
      fi

      # Cooldown after waking up before monitoring again
      sleep 5
    fi
  fi

  sleep 3
done
