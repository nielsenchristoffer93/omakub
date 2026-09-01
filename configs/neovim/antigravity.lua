return {
  {
    "folke/snacks.nvim",
    opts = {
      terminal = {
        win = { style = "terminal" },
      },
    },
    keys = {
      {
        "<leader>aa",
        function()
          local cmd = (vim.fn.executable("agy") == 1 and "agy")
            or (vim.fn.executable(vim.fn.expand("~/.local/bin/agy")) == 1 and vim.fn.expand("~/.local/bin/agy"))
            or nil
          if cmd then
            Snacks.terminal.open(cmd, {
              win = {
                position = "float",
                width = 0.88,
                height = 0.85,
                border = "rounded",
                title = " Antigravity AI Agent (agy) ",
                title_pos = "center",
              },
            })
          else
            vim.notify("Antigravity CLI ('agy') ej installerat. Kör 'omakub' -> Install -> Antigravity", vim.log.levels.WARN)
          end
        end,
        desc = "Toggle Antigravity AI Agent (Float)",
      },
      {
        "<leader>ag",
        function()
          local cmd = (vim.fn.executable("agy") == 1 and "agy")
            or (vim.fn.executable(vim.fn.expand("~/.local/bin/agy")) == 1 and vim.fn.expand("~/.local/bin/agy"))
            or nil
          if cmd then
            Snacks.terminal.open(cmd, {
              win = {
                position = "float",
                width = 0.88,
                height = 0.85,
                border = "rounded",
                title = " Antigravity AI Agent (agy) ",
                title_pos = "center",
              },
            })
          else
            vim.notify("Antigravity CLI ('agy') ej installerat. Kör 'omakub' -> Install -> Antigravity", vim.log.levels.WARN)
          end
        end,
        desc = "Toggle Antigravity AI Agent (Float)",
      },
      {
        "<leader>aA",
        function()
          local cmd = (vim.fn.executable("agy") == 1 and "agy")
            or (vim.fn.executable(vim.fn.expand("~/.local/bin/agy")) == 1 and vim.fn.expand("~/.local/bin/agy"))
            or nil
          if cmd then
            Snacks.terminal.open(cmd, {
              win = {
                position = "right",
                width = 0.45,
                border = "left",
                title = " Antigravity Sidebar (agy) ",
                title_pos = "center",
              },
            })
          else
            vim.notify("Antigravity CLI ('agy') ej installerat. Kör 'omakub' -> Install -> Antigravity", vim.log.levels.WARN)
          end
        end,
        desc = "Toggle Antigravity Sidebar",
      },
    },
  },
  -- Automatically reload buffers when files are modified by Antigravity or external tools
  {
    "LazyVim/LazyVim",
    opts = function()
      vim.opt.autoread = true
      vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
        pattern = "*",
        callback = function()
          if vim.fn.getcmdwintype() == "" then
            vim.cmd("checktime")
          end
        end,
      })
    end,
  },
}
