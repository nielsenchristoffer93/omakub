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
        "<leader>ao",
        function()
          local cmd = vim.fn.executable("opencode") == 1 and "opencode" or nil
          if cmd then
            Snacks.terminal.open(cmd, {
              win = {
                position = "float",
                width = 0.88,
                height = 0.85,
                border = "rounded",
                title = " OpenCode AI Agent ",
                title_pos = "center",
              },
            })
          else
            vim.notify("OpenCode ('opencode') ej installerat. Kör 'omakub' -> Install -> OpenCode", vim.log.levels.WARN)
          end
        end,
        desc = "Toggle OpenCode AI Agent (Float)",
      },
      {
        "<leader>as",
        function()
          local cmd = vim.fn.executable("opencode") == 1 and "opencode" or nil
          if cmd then
            Snacks.terminal.open(cmd, {
              win = {
                position = "right",
                width = 0.45,
                border = "left",
                title = " OpenCode Sidebar ",
                title_pos = "center",
              },
            })
          else
            vim.notify("OpenCode ('opencode') ej installerat. Kör 'omakub' -> Install -> OpenCode", vim.log.levels.WARN)
          end
        end,
        desc = "Toggle OpenCode Sidebar",
      },
      {
        "<leader>aa",
        function()
          local cmd = vim.fn.executable("opencode") == 1 and "opencode" or nil
          if cmd then
            Snacks.terminal.open(cmd, {
              win = {
                position = "bottom",
                height = 0.40,
                border = "top",
                title = " OpenCode Terminal ",
                title_pos = "center",
              },
            })
          else
            vim.notify("OpenCode ('opencode') ej installerat. Kör 'omakub' -> Install -> OpenCode", vim.log.levels.WARN)
          end
        end,
        desc = "Toggle OpenCode Bottom Panel",
      },
    },
  },
  -- Automatically reload buffers when files are modified by OpenCode or external tools
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
