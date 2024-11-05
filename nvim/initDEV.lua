-- Set autoindentation
vim.opt.autoindent = true

-- Set backspace behavior
vim.opt.backspace = "indent,eol,start"

-- Use system clipboard
vim.opt.clipboard = "unnamedplus"

-- Disable plugins when using Vim in Vi compatibility mode
vim.g.vimrc = vim.fn.has('v') == 1 and "noloadplugins" or ""

-- Set encoding to UTF-8
vim.opt.encoding = "utf-8"

-- Set fold method to marker
vim.opt.foldmethod = "marker"

-- Prevent modeline vulnerabilities
vim.opt.modeline = false

-- Hide the mode line
vim.opt.showmode = false

-- Disable octal numbers
vim.opt.nrformats = "alpha,octal"

-- Show the command line
vim.opt.showcmd = true

-- Set timeout and timeoutlen
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0

-- Set update count
vim.opt.updatecount = 10

-- Set undo levels
vim.opt.undolevels = 5000

-- Enable persistent undo
vim.opt.undofile = true

-- Enable wildmenu
vim.opt.wildmenu = true

-- Enable filetype plugin and indent
vim.opt.filetypeplugin = "on"
vim.opt.filetypeindent = "on"

-- Enable syntax highlighting
vim.opt.syntax = "enable"

-- Set leader key to `
vim.g.mapleader = "`"

-- Go to last location in non-empty files
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd("normal! g\"")
    end
  end
})

-- Improve searching
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Highlight search results
vim.api.nvim_set_hlsearch()
vim.api.nvim_set_hl(0, "Search", { fg = "#FFFFFF", bg = "#000000", style = "bold" })
vim.api.nvim_set_hl(0, "IncSearch", { fg = "#FFFFFF", bg = "#FF0000", style = "bold" })

-- Map n and N to search in the opposite direction
vim.api.nvim_set_keymap("n", "<silent>", function()
  local searchforward = vim.v.searchforward
  return "Nn"[searchforward] .. ":call HLNext()<CR>"
end, { noremap = true, expr = true })
vim.api.nvim_set_keymap("n", "<silent>", function()
  local searchforward = not vim.v.searchforward
  return "nN"[searchforward] .. ":call HLNext()<CR>"
end, { noremap = true, expr = true })

-- Delete to switch off highlighting and clear messages
vim.api.nvim_set_keymap("n", "<silent>", function()
  vim.cmd("call HLNextOff()")
  vim.cmd("nohlsearch")
  vim.cmd("call VG_Show_CursorColumn('off')")
  vim.cmd("HierClear")
end, { noremap = true })

-- Double-delete to remove trailing whitespace
vim.api.nvim_set_keymap("n", "<silent>", function()
  vim.cmd("mz")
  vim.cmd("call TrimTrailingWS()")
  vim.cmd("`z")
end, { noremap = true })

-- Function to remove trailing whitespace
local function TrimTrailingWS()
  local count = vim.fn.search("\\s\\+$", "cnw")
  if count > 0 then
    vim.cmd("%s/\\s\\+$//g")
  end
end

-- Set encoding defaults
vim.opt.termencoding = "utf-8"
vim.opt.fileencoding = ""
vim.opt.encoding = "utf-8"
vim.opt.scriptencoding = "utf-8"

-- Set encoding for new files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*",
  callback = function()
    vim.opt.encoding = "utf-8"
  end
})
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*",
  callback = function()
    vim.opt.encoding = "utf-8"
  end
})

-- Clean $HOME
vim.opt.viminfo = ""

-- Note: The commented out lines are likely intended to be used with a specific environment variable ($XDG_CONFIG_HOME) and are not directly translatable to Lua.
-- If you need to use these, you can uncomment and adjust them as needed.
-- vim.opt.viminfo = vim.opt.viminfo + "n" .. vim.env.XDG_CONFIG_HOME .. "/nvim/viminfo"
-- vim.opt.runtimepath = vim.opt.runtimepath + vim.env.XDG_CONFIG_HOME .. "/nvim," .. vim.env.XDG_CONFIG_HOME .. "/nvim/after"

-- Tab settings
vim.opt.tabstop = 8
vim.opt.expandtab = false
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true

-- Plugin manager
local plug = require("plug")

plug.begin("$XDG_CONFIG_HOME/nvim/plugins")

-- List of plugins
plug Plug "chriskempson/base16-vim"
plug Plug "machakann/vim-sandwich"
plug Plug "tpope/vim-fugitive"
plug Plug "gcmt/taboo.vim"
plug Plug "junegunn/fzf.vim"
plug Plug "junegunn/goyo.vim"
plug Plug "raimondi/delimitmate"
plug Plug "dhruvasagar/vim-dotoo"
plug Plug "gioele/vim-autoswap"

-- Load plugins
plug.end()

-- Non-active plugins (commented out in the original configuration)
-- plug Plug "christoomey/vim-tmux-navigator"
-- plug Plug "vimwiki/vimwiki"
-- plug Plug "ron89/thesaurus_query.vim"
-- plug Plug "terryma/vim-multiple-cursors"
-- plug Plug "jceb/vim-orgmode"
-- plug Plug "vim-airline/vim-airline"
-- plug Plug "vim-airline/vim-airline-themes"

-- Load custom plugins
require("hlnext").setup()
require("visualsmartia").setup()

-- File search settings
vim.opt.path += "**"

-- Swap file settings
vim.opt.directory = "$XDG_DATA_HOME/nvim/swap//"

-- DiffOrig command
vim.api.nvim_create_user_command("DiffOrig", function()
  vim.api.nvim_create_buf(0, {
    bufnr = 0,
    bufload = false,
    buflisted = false,
    bufhidden = "wipe",
    bufoptions = "nolist",
  })

-- Tag jumping
vim.api.nvim_create_user_command("MakeTags", "ctags -R .")

-- Statusline settings
vim.opt.laststatus = 2

-- Statusline colors
vim.api.nvim_set_hl(0, "sl_01", { bg = "#000000" })
vim.api.nvim_set_hl(0, "sl_file", { bg = "#000000", fg = "#00FF00" })
vim.api.nvim_set_hl(0, "sl_af", { bg = "#000000", fg = "#FFFF00" })

-- Clear statusline
vim.opt.statusline = ""

-- Statusline settings
vim.opt.statusline = "%#sl_01# " .. " " .. " " .. "%*" .. "%#sl_file# " .. " " .. "%.60F" .. " " .. "%r" .. " " .. "%m" .. " " .. "%*" .. "%#sl_af# " .. "%=" .. " " .. "(%v\-%l)" .. "." .. "%2p" .. " " .. "%#sl_01# " .. " "

-- Line number configuration
vim.api.nvim_create_user_command("NumberToggle", function()
  vim.opt.number = not vim.opt.number:get()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { nargs = 0 })

-- Default line number settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.api.nvim_set_hl(0, "LineNr", { fg = "#666666", bg = "#FFFFFF" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FFFF00", bg = "#FFFFFF" })

-- Number toggle command and settings
vim.api.nvim_create_augroup("numbertoggle", { clear = true })
vim.api.nvim_create_augroup("numbertoggle", {
  { "InsertEnter", function()
    vim.opt.norelativenumber = true
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#00FF00", bg = "#FFFFFF" })
  end },
  { "InsertLeave", function()
    vim.opt.relativenumber = true
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FFFF00", bg = "#FFFFFF" })
  end }
})

-- 80 character column and >120 greyed out area
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#E5E5E5" })
vim.opt.colorcolumn = "80," .. table.concat(vim.fn.range(120, 999), ",")

-- Highlight column 81
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#666666", fg = "#FFFFFF" })
vim.api.nvim_create_augroup("highlight_color_column", {
  { "BufEnter", function()
    vim.fn.matchadd("ColorColumn", "\\%81v.")
  end }
})

-- Cursor definition
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver20,r-cr-o:hor20,a:blinkwait1000-blinkon800-blinkoff200"

-- Create pane
vim.api.nvim_set_keymap("n", "<A-->", "<cmd>split<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-\\>", "<cmd>vsplit<CR>", { noremap = true, silent = true })

-- Delete pane
vim.api.nvim_set_keymap("n", "<A-d>", "<cmd>q<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-Del>", "<cmd>only<CR>", { noremap = true, silent = true })

-- Move pane focus
vim.api.nvim_set_keymap("n", "<A-h>", "<C-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-j>", "<C-w>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-k>", "<C-w>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-l>", "<C-w>l", { noremap = true, silent = true })

-- Move pane
vim.api.nvim_set_keymap("n", "<A-S-h>", "<C-w>H", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-S-j>", "<C-w>J", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-S-k>", "<C-w>K", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-S-l>", "<C-w>L", { noremap = true, silent = true })

-- Close pane
vim.api.nvim_buf_delete(0, true)

-- Resize mappings
vim.api.nvim_set_keymap('n', '<A-c-n>', '<C-w><', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-c-m>', '<C-w>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-c-,>', '<C-w>-', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-c-.>', '<C-w>>', { noremap = true, silent = true })

-- Normal mode mappings
vim.api.nvim_set_keymap('n', '<A-c-h>', '5<C-w><', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-c-j>', '5<C-w>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-c-k>', '5<C-w>-', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-c-l>', '5<C-w>>', { noremap = true, silent = true })

-- Large adjustments
vim.api.nvim_set_keymap('n', '<A-c-y>', '10<C-w><', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-c-u>', '10<C-w>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-c-i>', '10<C-w>-', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-c-o>', '10<C-w>>', { noremap = true, silent = true })

-- Maximize current pane into new tab
vim.api.nvim_set_keymap('n', '<A-f>', ':tab sbp<CR>', { noremap = true, silent = true })

-- Reset all pane sizes
vim.api.nvim_set_keymap('n', '<A-0>', '<c-w>=', { noremap = true, silent = true })

-- Mouse drag resizes
vim.opt.mouse = 'a'

-- Tab line settings
vim.api.nvim_set_hlsearch()
vim.api.nvim_set_option('tabline', '%N ')
vim.api.nvim_set_hlgroup('TabLineFill', { fg = '#232', bg = '#232' })
vim.api.nvim_set_hlgroup('TabLineSel', { fg = '#FFFFFF', bg = '#24' })
vim.api.nvim_set_hlgroup('TabLine', { fg = '#Grey', bg = '#236' })

-- Create tab
vim.api.nvim_command(':tabedit')

-- Close tab
vim.api.nvim_command(':q')

-- Goto tab
vim.api.nvim_set_keymap('n', '<A-]>', ':tabn<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-[>', ':tabp<CR>', { noremap = true, silent = true })

-- Tab position
vim.api.nvim_set_keymap('n', '<A-S-[>', ':tabm -i<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-S-]>', ':tabm +i<CR>', { noremap = true, silent = true })

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = '%s/\s\+$//e'
})

-- Removing empty newlines at EOF if more than one
-- [TODO] implement this in Lua

-- Look and feel
vim.api.nvim_set_hlgroup('Normal', { bg = 'NONE' })

-- Distraction free writing
vim.api.nvim_set_keymap('n', '<Leader><Tab>', ':Goyo<CR>', { noremap = true })
vim.api.nvim_create_autocmd('User', {
  event = 'GoyoLeave',
  command = 'source ' .. vim.fn.expand('$MYVIMRC')
})

-- Vimdiff
if vim.opt.diff:get() == 1 then
  vim.api.nvim_set_hlgroup('DiffAdd', { bg = '24' })
  vim.api.nvim_set_hlgroup('DiffChange', { fg = '181', bg = '239' })
  vim.api.nvim_set_hlgroup('DiffDelete', { fg = '162', bg = '53' })
  vim.api.nvim_set_hlgroup('DiffText', { bg = '102' })
  -- vim.api.nvim_set_hlgroup('DiffText', { bg = '102', bold = true })
end

vim.api.nvim_set_hlgroup('MatchParen', { fg = 'green', bg = 'none', bold = false })

-- Keybindings
vim.api.nvim_set_keymap('n', ';', ':', { noremap = true })
vim.api.nvim_set_keymap('n', '<BS>', 'X', { noremap = true })

-- Spell check
-- Custom dictionary
vim.api.nvim_command(':mkspell ~/.config/vim/spell/custom_dict custom_dict.txt')
