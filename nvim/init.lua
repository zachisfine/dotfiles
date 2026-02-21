-- ~/.config/nvim/init.lua — Neovim config (Lua, plugin-rich)
-- Part of ~/dotfiles — managed via install.sh

-- ══════════════════════════════════════════
-- Leader key (must be set before plugins)
-- ══════════════════════════════════════════
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ══════════════════════════════════════════
-- General
-- ══════════════════════════════════════════
vim.opt.hidden = true                       -- allow switching buffers without saving
vim.opt.autoread = true                     -- reload files changed outside nvim
vim.opt.mouse = "a"                         -- enable mouse support
vim.opt.clipboard = "unnamedplus"           -- use system clipboard
vim.opt.updatetime = 250                    -- faster CursorHold events
vim.opt.timeoutlen = 500                    -- mapping timeout
vim.opt.termguicolors = true                -- 24-bit color
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }

-- ══════════════════════════════════════════
-- Display
-- ══════════════════════════════════════════
vim.opt.number = true                       -- line numbers
vim.opt.relativenumber = true               -- relative line numbers
vim.opt.cursorline = true                   -- highlight current line
vim.opt.signcolumn = "auto"                 -- sign column when needed
vim.opt.scrolloff = 8                       -- lines above/below cursor
vim.opt.sidescrolloff = 8                   -- columns left/right of cursor
vim.opt.wrap = true                         -- wrap lines
vim.opt.linebreak = true                    -- wrap at word boundaries
vim.opt.showmode = false                    -- lualine shows mode instead

-- ══════════════════════════════════════════
-- Search
-- ══════════════════════════════════════════
vim.opt.ignorecase = true                   -- case-insensitive search
vim.opt.smartcase = true                    -- ...unless uppercase is used
vim.opt.hlsearch = true                     -- highlight matches
vim.opt.incsearch = true                    -- incremental search

-- Clear search highlight with Esc
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- ══════════════════════════════════════════
-- Indentation
-- ══════════════════════════════════════════
vim.opt.expandtab = true                    -- spaces instead of tabs
vim.opt.shiftwidth = 4                      -- indent width
vim.opt.tabstop = 4                         -- tab display width
vim.opt.softtabstop = 4                     -- tab key width
vim.opt.smartindent = true                  -- auto-indent new lines
vim.opt.shiftround = true                   -- round indent to shiftwidth

-- Filetype-specific indentation
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "html", "css", "javascript", "typescript", "json", "yaml", "vue", "svelte" },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "make" },
    callback = function() vim.opt_local.expandtab = false end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "go" },
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
    end,
})

-- ══════════════════════════════════════════
-- Persistent undo
-- ══════════════════════════════════════════
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(vim.o.undodir) == 0 then
    vim.fn.mkdir(vim.o.undodir, "p")
end

-- ══════════════════════════════════════════
-- Swap & Backup
-- ══════════════════════════════════════════
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = true
vim.opt.directory = vim.fn.stdpath("data") .. "/swap//"
if vim.fn.isdirectory(vim.o.directory) == 0 then
    vim.fn.mkdir(vim.o.directory, "p")
end

-- ══════════════════════════════════════════
-- Key mappings
-- ══════════════════════════════════════════
-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>")
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>")
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>")
vim.keymap.set("n", "<leader>bl", "<cmd>ls<CR>")

-- Quick save and quit
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>")

-- Move lines up/down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centered when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Quick split
vim.keymap.set("n", "<leader>sh", "<cmd>split<CR>")
vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<CR>")

-- ══════════════════════════════════════════
-- Trim trailing whitespace on save
-- ══════════════════════════════════════════
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        local pos = vim.api.nvim_win_get_cursor(0)
        vim.cmd([[silent! %s/\s\+$//e]])
        vim.api.nvim_win_set_cursor(0, pos)
    end,
})

-- ══════════════════════════════════════════
-- Return to last edit position
-- ══════════════════════════════════════════
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lines = vim.api.nvim_buf_line_count(0)
        if mark[1] > 1 and mark[1] <= lines then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

-- ══════════════════════════════════════════
-- Highlight yanked text
-- ══════════════════════════════════════════
vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

-- ══════════════════════════════════════════
-- Plugins (lazy.nvim — auto-bootstrapped)
-- ══════════════════════════════════════════
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- ── Colorscheme ──
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            flavour = "mocha",
            integrations = {
                treesitter = true,
                telescope = { enabled = true },
            },
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    -- ── Treesitter ──
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        main = "nvim-treesitter.configs",
        opts = {
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        },
    },

    -- ── Statusline ──
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "catppuccin",
                component_separators = "|",
                section_separators = "",
            },
        },
    },

    -- ── Fuzzy finder ──
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function() return vim.fn.executable("make") == 1 end,
            },
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({})
            pcall(telescope.load_extension, "fzf")

            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep,  { desc = "Live grep" })
            vim.keymap.set("n", "<leader>fb", builtin.buffers,    { desc = "Buffers" })
            vim.keymap.set("n", "<leader>fh", builtin.help_tags,  { desc = "Help tags" })
        end,
    },
})

-- ══════════════════════════════════════════
-- Local overrides
-- ══════════════════════════════════════════
local local_config = vim.fn.stdpath("config") .. "/local.lua"
if vim.fn.filereadable(local_config) == 1 then
    dofile(local_config)
end
