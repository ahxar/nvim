return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
               highlight = {
                    enable = true,
                },
                indent = { enable = true },
                autotag = { enable = true },
                ensure_installed = {
                    "json",
                    "javascript",
                    "query",
                    "typescript",
                    "tsx",
                    "php",
                    "yaml",
                    "html",
                    "css",
                    "markdown",
                    "markdown_inline",
                    "bash",
                    "lua",
                    "vim",
                    "vimdoc",
                    "c",
                    "dockerfile",
                    "gitignore",
                    "astro",
          "go"
                },
                -- auto install above language parsers
                auto_install = false,
            })
        end
    }
}
