return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.5",
  dependencies = {
    "nvim-lua/plenary.nvim"
    -- ❌ No devicons included
  },
  config = function()
    local has_telescope, telescope = pcall(require, "telescope")
    if not has_telescope then return end

    local actions = require("telescope.actions")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local entry_display = require("telescope.pickers.entry_display")

    telescope.setup({
      defaults = {
        color_devicons = false,
        file_ignore_patterns = {},
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",
        -- Override file display to fully remove icons
        path_display = function(_, path)
          return path
        end,
      },
      pickers = {
        find_files = {
          -- Removes icons from `find_files` specifically
          attach_mappings = function(_, map)
            return true
          end,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry,
              ordinal = entry,
              path = entry,
            }
          end,
        }
      }
    })

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
    vim.keymap.set('n', '<C-p>', builtin.git_files, {})
    vim.keymap.set('n', '<leader>pws', function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string({ search = word })
    end)
    vim.keymap.set('n', '<leader>pWs', function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word })
    end)
    vim.keymap.set('n', '<leader>ps', function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end)
    vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
  end
}

