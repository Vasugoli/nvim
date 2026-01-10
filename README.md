# Neovim Configuration

## Installation Steps

1. **Backup existing configuration** (if any):
    ```bash
    mv ~/.config/nvim ~/.config/nvim.backup
    mv ~/.local/share/nvim ~/.local/share/nvim.backup
    ```

2. **Clone this repository**:
    ```bash
    git clone https://github.com/Vasugoli/nvim.git ~/.config/nvim
    ```

3. **Install Neovim** (version 0.9+ recommended):
    - Windows: `winget install Neovim.Neovim`
    - Linux: `sudo apt install neovim` or download from [neovim.io](https://neovim.io)
    - macOS: `brew install neovim`

4. **Launch Neovim**:
    ```bash
    nvim
    ```
    Plugins will auto-install on first launch.

## Configuration Structure

```
nvim/
├── init.lua                 # Main entry point
├── lua/
│   ├── config/
│   │   ├── options.lua      # Vim options
│   │   ├── keymaps.lua      # Keybindings
│   │   └── autocmds.lua     # Auto commands
│   └── plugins/
│       ├── init.lua         # Plugin manager setup
│       ├── lsp_config/      # LSP configuration
│       ├── ui/              # Syntax highlighting
│       └── ...              # Individual plugin configs
└── README.md
```

## Plugins & Features

### Core Plugins

**Plugin Manager**
- **lazy.nvim** - Fast plugin manager
  - Auto-install on first launch
  - Lazy loading for performance

**File Navigation**
- **nvim-tree** - File explorer
  - `<leader>e` - Toggle file tree
  - `a` - Create file, `d` - Delete, `r` - Rename

- **telescope.nvim** - Fuzzy finder
  - `<leader>ff` - Find files
  - `<leader>fg` - Live grep
  - `<leader>fb` - Buffers
  - `<leader>fh` - Help tags

**LSP & Completion**
- **nvim-lspconfig** - LSP support
- **mason.nvim** - LSP installer
- **nvim-cmp** - Auto-completion
  - `<C-Space>` - Trigger completion
  - `<CR>` - Confirm
  - `<Tab>` - Next item

**Syntax & Highlighting**
- **nvim-treesitter** - Advanced syntax highlighting
  - Auto-install parsers
  - Code folding support

**Git Integration**
- **gitsigns.nvim** - Git decorations
  - `]c` / `[c` - Next/prev hunk
  - `<leader>hs` - Stage hunk
  - `<leader>hu` - Undo stage

**UI Enhancements**
- **lualine.nvim** - Statusline
- **bufferline.nvim** - Buffer tabs
- **which-key.nvim** - Keybinding hints

## Key Mappings

### General
- `<leader>` = `<Space>`
- `<leader>w` - Save file
- `<leader>q` - Quit
- `jk` - Exit insert mode

### Navigation
- `<C-h/j/k/l>` - Window navigation
- `<Tab>` / `<S-Tab>` - Next/previous buffer
- `<leader>bd` - Close buffer

### Editing
- `<leader>/` - Toggle comment
- `<leader>f` - Format document
- `>` / `<` - Indent/unindent (visual mode)

### Search
- `<leader>nh` - Clear search highlights
- `<leader>s` - Search and replace

## Customization

Edit files in `lua/config/` to customize:
- **options.lua** - Vim settings (line numbers, tabs, etc.)
- **keymaps.lua** - Add your own keybindings
- **plugins/** - Add or configure plugins

## Requirements

- Neovim >= 0.9.0
- Git
- Node.js (for some LSP servers)
- Ripgrep (for telescope grep)
- A Nerd Font (for icons)

## Troubleshooting

- **Plugins not loading**: Run `:Lazy sync`
- **LSP not working**: Run `:Mason` and install language servers
- **Icons broken**: Install a Nerd Font and set it in your terminal
