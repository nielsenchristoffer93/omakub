#!/usr/bin/env python3
import sys
import os
import signal
import subprocess

import warnings
warnings.filterwarnings("ignore")

# Ensure system python libraries (gi) can be found even if run inside a custom venv/mise python
if "/usr/lib/python3/dist-packages" not in sys.path:
    sys.path.append("/usr/lib/python3/dist-packages")

try:
    import gi
    gi.require_version("Gtk", "3.0")
    gi.require_version("Gdk", "3.0")
    gi.require_version("Gio", "2.0")
    from gi.repository import Gtk, Gdk, Gio, GLib
    try:
        from gi.repository import GLibUnix
    except Exception:
        GLibUnix = None
except Exception:
    # If GTK or Gdk bindings cannot be loaded, silently exit so screensaver can still run
    sys.exit(0)


def get_primary_geometry_from_mutter():
    """Query Mutter DisplayConfig over DBus to find the primary monitor's (x, y) coordinates."""
    try:
        bus = Gio.bus_get_sync(Gio.BusType.SESSION, None)
        proxy = Gio.DBusProxy.new_sync(
            bus,
            Gio.DBusProxyFlags.NONE,
            None,
            "org.gnome.Mutter.DisplayConfig",
            "/org/gnome/Mutter/DisplayConfig",
            "org.gnome.Mutter.DisplayConfig",
            None,
        )
        res = proxy.call_sync("GetCurrentState", None, Gio.DBusCallFlags.NONE, 2000, None)
        serial, monitors, logical_monitors, props = res.unpack()
        for lm in logical_monitors:
            x, y, scale, transform, is_primary, connectors, extra = lm
            if is_primary:
                return (x, y)
    except Exception:
        pass
    return None


def get_theme_background():
    """Read background color from screensaver.toml or theme.toml, fallback to #000000."""
    candidates = [
        os.path.expanduser("~/.config/alacritty/screensaver.toml"),
        os.path.expanduser("~/.config/alacritty/theme.toml"),
    ]
    for path in candidates:
        if os.path.isfile(path):
            try:
                with open(path, "r", encoding="utf-8") as f:
                    in_primary = False
                    for line in f:
                        s = line.strip()
                        if s.startswith("["):
                            in_primary = (s == "[colors.primary]")
                        elif in_primary and s.startswith("background"):
                            parts = s.split("=", 1)
                            if len(parts) == 2:
                                val = parts[1].strip().strip("\"'")
                                if val.lower().startswith("0x"):
                                    val = "#" + val[2:]
                                elif not val.startswith("#"):
                                    val = "#" + val
                                if len(val) in (4, 7, 9):
                                    return val
            except Exception:
                pass
    return "#000000"


def on_user_activity(widget, event):
    """Wake up session on key press or mouse click on secondary monitors."""
    try:
        subprocess.run(["pkill", "-TERM", "-f", "OmakubScreensaver"], check=False)
    except Exception:
        pass
    Gtk.main_quit()


def main():
    display = Gdk.Display.get_default()
    if not display:
        sys.exit(0)

    n_monitors = display.get_n_monitors()
    if n_monitors <= 1:
        # Single monitor connected, no secondary displays to black out
        sys.exit(0)

    screen = display.get_default_screen()

    # Determine primary monitor coordinates
    primary_xy = get_primary_geometry_from_mutter()

    # If Mutter DBus didn't report primary, fallback to Gdk's primary monitor
    if primary_xy is None:
        try:
            prim_mon = display.get_primary_monitor()
            if prim_mon:
                geom = prim_mon.get_geometry()
                primary_xy = (geom.x, geom.y)
        except Exception:
            pass

    # Find secondary monitors
    secondary_indices = []
    for i in range(n_monitors):
        mon = display.get_monitor(i)
        geom = mon.get_geometry()
        if primary_xy is not None:
            if (geom.x, geom.y) != primary_xy:
                secondary_indices.append(i)
        else:
            # Fallback: assume monitor 0 is primary, all others are secondary
            if i > 0:
                secondary_indices.append(i)

    if not secondary_indices:
        sys.exit(0)

    # Resolve theme background color to match screensaver terminal background perfectly
    bg_color = get_theme_background()

    # Configure CSS for solid background matching active theme
    css_provider = Gtk.CssProvider()
    css_data = f"""
    window.screensaver-blackout {{
        background-color: {bg_color};
    }}
    """.encode("utf-8")
    css_provider.load_from_data(css_data)
    Gtk.StyleContext.add_provider_for_screen(
        screen,
        css_provider,
        Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION,
    )

    windows = []
    for idx in secondary_indices:
        win = Gtk.Window(type=Gtk.WindowType.TOPLEVEL)
        win.set_title("omakub-screensaver-blackout")
        win.set_role("screensaver-blackout")
        win.get_style_context().add_class("screensaver-blackout")
        win.set_decorated(False)
        win.set_skip_taskbar_hint(True)
        win.set_skip_pager_hint(True)
        win.set_keep_above(True)

        # Place fullscreen on the target secondary monitor
        win.fullscreen_on_monitor(screen, idx)

        # Wake up screensaver on any keyboard or mouse button event
        win.add_events(Gdk.EventMask.KEY_PRESS_MASK | Gdk.EventMask.BUTTON_PRESS_MASK)
        win.connect("key-press-event", on_user_activity)
        win.connect("button-press-event", on_user_activity)

        win.realize()
        try:
            blank_cursor = Gdk.Cursor.new_for_display(display, Gdk.CursorType.BLANK_CURSOR)
            win.get_window().set_cursor(blank_cursor)
        except Exception:
            pass

        win.show_all()
        windows.append(win)

    # Listen for termination signals to close smoothly
    if GLibUnix is not None:
        GLibUnix.signal_add(GLib.PRIORITY_DEFAULT, signal.SIGTERM, Gtk.main_quit)
        GLibUnix.signal_add(GLib.PRIORITY_DEFAULT, signal.SIGINT, Gtk.main_quit)
    else:
        GLib.unix_signal_add(GLib.PRIORITY_DEFAULT, signal.SIGTERM, Gtk.main_quit)
        GLib.unix_signal_add(GLib.PRIORITY_DEFAULT, signal.SIGINT, Gtk.main_quit)

    Gtk.main()


if __name__ == "__main__":
    main()
