return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        require("bufferline").setup({
            options = {
                mode = "buffers", -- set to "tabs" to only show tabpages instead
                numbers = "none", -- "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string
                number_style = "superscript", -- "subscript" | "" | { "none", "subscript" }
                close_command = "bdelete! %d", -- can be a string | function
                right_mouse_command = "bdelete! %d", -- can be a string | function
                left_mouse_command = "buffer %d", -- can be a string | function
                middle_mouse_command = nil, -- can be a string | function
                indicator_icon = '▎',
                buffer_close_icon = 'X',
                modified_icon = '●',
                close_icon = 'X',
                left_trunc_marker = '',
                right_trunc_marker = '',
                name_formatter = function(buf)
                    if buf.name:match('%.md') then
                        return vim.fn.fnamemodify(buf.name, ':t:r')
                    end
                end,
                max_name_length = 18,
                max_prefix_length = 15,
                tab_size = 18,
                diagnostics = false, -- "nvim_lsp" | "coc"
                diagnostics_update_in_insert = false,
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    return "(" .. count .. ")"
                end,
                custom_filter = function(buf_number, buf_numbers)
                    return true
                end,
                offsets = {{
                    filetype = "NvimTree",
                    text = "File Tree",
                    text_align = "left"
                }},
                color_icons = true,
                show_buffer_icons = true,
                show_buffer_close_icons = true,
                show_close_icon = true,
                show_tab_indicators = true,
                persist_buffer_sort = true,
                separator_style = "slant", -- "thick" | "thin" | { 'any', 'any' }
                enforce_regular_tabs = false,
                always_show_bufferline = true,
                sort_by = 'insert_after_current', -- 'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs'
                get_element_icon = function(buf)
                    return require('nvim-web-devicons').get_icon(buf.name, buf.extension, {
                        default = false
                    })
                end
            }
        })
    end
}
