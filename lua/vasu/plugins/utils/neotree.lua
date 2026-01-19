return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  -- cmd = "Neotree",
  event = "VimEnter",
  keys = {
    { "<Leader>e", "<Cmd>Neotree toggle<CR>", desc = "Toggle Explorer" },
    { "<Leader>ef", "<Cmd>Neotree focus filesystem<CR>", desc = "Focus Files" },
    { "<Leader>eb", "<Cmd>Neotree focus buffers<CR>", desc = "Focus Buffers" },
    { "<Leader>eg", "<Cmd>Neotree focus git_status<CR>", desc = "Focus Git" },
  },
  opts = function()
    local git_available = vim.fn.executable "git" == 1

    -- Enhanced icon definitions
    local icons = {
      FoldClosed = "󰅂",
      FoldOpened = "󰅀",
      FolderClosed = "󰉋",
      FolderOpen = "󰝰",
      FolderEmpty = "󰉖",
      DefaultFile = "󰈙",
      FileModified = "●",
      GitAdd = "󰐕",
      GitDelete = "󰍵",
      GitChange = "󰏫",
      GitRenamed = "󰁕",
      GitUntracked = "󰎔",
      GitIgnored = "󰿠",
      GitUnstaged = "󰄱",
      GitStaged = "󰱒",
      GitConflict = "󰅖",
      Git = "󰊢",
      Diagnostic = "󰒡",
      Buffer = "󰈔",
    }

    local sources = {
      { source = "filesystem", display_name = "󰉋 Files" },
      { source = "buffers", display_name = "󰈔 Buffers" },
    }
    if git_available then
      table.insert(sources, { source = "git_status", display_name = "󰊢 Git" })
    end

    return {
      enable_git_status = git_available,
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      sources = { "filesystem", "buffers", git_available and "git_status" or nil },
      source_selector = {
        winbar = true,
        content_layout = "center",
        show_separator_on_edge = false,
        sources = sources,
        separator = { left = "▏", right = "▕" },
        separator_active = { left = "▏", right = "▕" },
        tabs_layout = "equal",
        style = {
          border = "rounded",
          separator = "│",
        },
      },
      default_component_configs = {
        container = {
          enable_character_fade = true,
        },
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
          with_expanders = nil,
          expander_collapsed = icons.FoldClosed,
          expander_expanded = icons.FoldOpened,
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = icons.FolderClosed,
          folder_open = icons.FolderOpen,
          folder_empty = icons.FolderEmpty,
          folder_empty_open = icons.FolderEmpty,
          default = icons.DefaultFile,
          highlight = "NeoTreeFileIcon"
        },
        modified = {
          symbol = icons.FileModified,
          highlight = "NeoTreeModified",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = "NeoTreeFileName",
        },
        git_status = {
          symbols = {
            added = icons.GitAdd,
            deleted = icons.GitDelete,
            modified = icons.GitChange,
            renamed = icons.GitRenamed,
            untracked = icons.GitUntracked,
            ignored = icons.GitIgnored,
            unstaged = icons.GitUnstaged,
            staged = icons.GitStaged,
            conflict = icons.GitConflict,
          },
        },
      },
      commands = {
        system_open = function(state)
          vim.ui.open(state.tree:get_node():get_id())
        end,
        parent_or_close = function(state)
          local node = state.tree:get_node()
          if node:has_children() and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        child_or_open = function(state)
          local node = state.tree:get_node()
          if node:has_children() then
            if not node:is_expanded() then
              state.commands.toggle_node(state)
            else
              if node.type == "file" then
                state.commands.open(state)
              else
                require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
              end
            end
          else
            state.commands.open(state)
          end
        end,
        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local vals = {
            ["BASENAME"] = modify(filename, ":r"),
            ["EXTENSION"] = modify(filename, ":e"),
            ["FILENAME"] = filename,
            ["PATH (CWD)"] = modify(filepath, ":."),
            ["PATH (HOME)"] = modify(filepath, ":~"),
            ["PATH"] = filepath,
            ["URI"] = vim.uri_from_fname(filepath),
          }

          local options = vim.tbl_filter(function(val) return vals[val] ~= "" end, vim.tbl_keys(vals))
          if vim.tbl_isempty(options) then
            vim.notify("No values to copy", vim.log.levels.WARN)
            return
          end
          table.sort(options)
          vim.ui.select(options, {
            prompt = "Choose to copy to clipboard:",
            format_item = function(item) return ("%s: %s"):format(item, vals[item]) end,
          }, function(choice)
            local result = vals[choice]
            if result then
              vim.notify(("Copied: `%s`"):format(result))
              vim.fn.setreg("+", result)
            end
          end)
        end,
      },
      window = {
        position = "left",
        width = 35,
        auto_expand_width = false,
        popup = {
          size = {
            height = "80%",
            width = "50%",
          },
          position = "50%",
        },
        mappings = {
          -- Navigation
          ["<CR>"] = "open",
          ["l"] = "child_or_open",  -- Open file/folder or navigate into folder
          ["h"] = "parent_or_close", -- Close folder or go to parent
          ["<2-LeftMouse>"] = "open",
          ["<S-CR>"] = "system_open",

          -- File operations
          ["a"] = { "add", config = { show_path = "relative" }},
          ["A"] = "add_directory",
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = "copy",
          ["m"] = "move",
          ["Y"] = "copy_selector",

          -- Tree operations
          ["R"] = "refresh",
          ["<C-r>"] = "refresh",
          ["."] = "set_root",
          ["<BS>"] = "navigate_up",
          ["z"] = "close_all_nodes",
          ["Z"] = "expand_all_nodes",

          -- Source switching (enhanced keymaps)
          ["<Tab>"] = "next_source",
          ["<S-Tab>"] = "prev_source",
          ["1"] = function() vim.cmd("Neotree focus filesystem") end,
          ["2"] = function() vim.cmd("Neotree focus buffers") end,
          ["3"] = function() vim.cmd("Neotree focus git_status") end,
          ["f"] = function() vim.cmd("Neotree focus filesystem") end,
          ["b"] = function() vim.cmd("Neotree focus buffers") end,
          ["g"] = function() vim.cmd("Neotree focus git_status") end,

          -- Window operations
          ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true }},
          ["s"] = "open_split",
          ["S"] = "open_vsplit",
          ["t"] = "open_tabnew",
          ["w"] = "open_with_window_picker",

          -- Other
          ["q"] = "close_window",
          ["?"] = "show_help",
          ["<Space>"] = false, -- disable space
          ["[b"] = "prev_source",
          ["]b"] = "next_source",
        },
        fuzzy_finder_mappings = {
          ["<C-j>"] = "move_cursor_down",
          ["<C-k>"] = "move_cursor_up",
        },
      },
      open_file = {
        quit_on_open = true, 
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        group_empty_dirs = false,
        hijack_netrw_behavior = "disabled",
        use_libuv_file_watcher = vim.fn.has "win32" ~= 1,
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = git_available,
          hide_hidden = true,
          hide_by_name = {
            "node_modules",
            ".git",
            ".DS_Store",
            "thumbs.db",
          },
          never_show = {
            ".git",
            ".DS_Store",
            "thumbs.db",
          },
        },
        commands = {
          -- Custom command to toggle hidden files
          toggle_hidden = function(state)
            state.filtered_items.visible = not state.filtered_items.visible
            require("neo-tree.sources.manager").refresh("filesystem")
          end,
        },
        window = {
          mappings = {
            ["H"] = "toggle_hidden",
          },
        },
      },
      buffers = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        group_empty_dirs = true,
        show_unloaded = true,
        window = {
          mappings = {
            ["bd"] = "buffer_delete",
            ["<BS>"] = "navigate_up",
            ["."] = "set_root",
            ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
            ["oc"] = { "order_by_created", nowait = false },
            ["od"] = { "order_by_diagnostics", nowait = false },
            ["om"] = { "order_by_modified", nowait = false },
            ["on"] = { "order_by_name", nowait = false },
            ["os"] = { "order_by_size", nowait = false },
            ["ot"] = { "order_by_type", nowait = false },
          }
        },
      },
      git_status = {
        window = {
          position = "float",
          mappings = {
            ["A"]  = "git_add_all",
            ["gu"] = "git_unstage_file",
            ["ga"] = "git_add_file",
            ["gr"] = "git_revert_file",
            ["gc"] = "git_commit",
            ["gp"] = "git_push",
            ["gg"] = "git_commit_and_push",
            ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
            ["oc"] = { "order_by_created", nowait = false },
            ["od"] = { "order_by_diagnostics", nowait = false },
            ["om"] = { "order_by_modified", nowait = false },
            ["on"] = { "order_by_name", nowait = false },
            ["os"] = { "order_by_size", nowait = false },
            ["ot"] = { "order_by_type", nowait = false },
          }
        }
      },
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function(_)
            vim.opt_local.signcolumn = "auto"
            vim.opt_local.foldcolumn = "0"
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
          end,
        },
        {
          event = "file_open_requested",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end
        },
      },
    }
  end,
  config = function(_, opts)
    require("neo-tree").setup(opts)

    -- Enhanced highlight groups for better appearance
    vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "#1e1e2e", fg = "#cdd6f4" })
    vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "#1e1e2e", fg = "#cdd6f4" })
    vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { bg = "#1e1e2e", fg = "#313244" })
    vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "#1e1e2e", fg = "#1e1e2e" })
    vim.api.nvim_set_hl(0, "NeoTreeRootName", { fg = "#89b4fa", bold = true })
    vim.api.nvim_set_hl(0, "NeoTreeGitAdded", { fg = "#a6e3a1" })
    vim.api.nvim_set_hl(0, "NeoTreeGitDeleted", { fg = "#f38ba8" })
    vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = "#fab387" })
    vim.api.nvim_set_hl(0, "NeoTreeGitConflict", { fg = "#eba0ac" })
    vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", { fg = "#cba6f7" })
    vim.api.nvim_set_hl(0, "NeoTreeIndentMarker", { fg = "#45475a" })
    vim.api.nvim_set_hl(0, "NeoTreeExpander", { fg = "#89b4fa" })

    -- Auto-open neotree when opening a directory
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function(args)
        if package.loaded["neo-tree"] then
          return
        end
        local stats = vim.uv.fs_stat(vim.api.nvim_buf_get_name(args.buf))
        if stats and stats.type == "directory" then
          require("lazy").load { plugins = { "neo-tree.nvim" } }
        end
      end,
    })

    -- Refresh neotree when closing lazygit
    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*lazygit*",
      callback = function()
        local manager_avail, manager = pcall(require, "neo-tree.sources.manager")
        if manager_avail then
          for _, source in ipairs { "filesystem", "git_status", "buffers" } do
            local module = "neo-tree.sources." .. source
            if package.loaded[module] then
              manager.refresh(require(module).name)
            end
          end
        end
      end,
    })
  end,
}