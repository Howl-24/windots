return {
    -- change some telescope options and a keymap to browse plugin files
    {
        "nvim-telescope/telescope.nvim",
        keys = {
        -- add a keymap to browse plugin files
        -- stylua: ignore
        {
            "<leader>fp",
            function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
            desc = "Find Plugin File",
        },
        },
        -- change some options
        opts = {
        defaults = {
            layout_strategy = "horizontal",
            layout_config = { prompt_position = "top" },
            sorting_strategy = "ascending",
            winblend = 0,
        },
        },
    },
    {
        "williamboman/mason.nvim",
        config = true
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "docker_compose_language_service", -- ✅ 正确
                    "omnisharp", -- ✅ C# LSP 服务器
                    "lua_ls", -- ✅ Lua 语言服务器
                    "pyright", -- ✅ Python LSP（推荐用 Pyright）
                    "rust_analyzer" -- ✅ Rust 语言服务器
                }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("lspconfig").lua_ls.setup({})
        end
    }
    
}