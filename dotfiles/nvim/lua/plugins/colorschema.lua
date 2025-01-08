return {
    -- {
    --     "svrana/neosolarized.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         require("neosolarized").setup({
    --             comment_italics = true,
    --             background_set = false,
    --         })
    --         vim.cmd.colorscheme("neosolarized")
    --     end,
    --     dependencies = {
    --         "tjdevries/colorbuddy.nvim",
    --     },
    -- },
    {
        "maxmx03/solarized.nvim",
        lazy = false,
        priority = 1000,
        ---@type solarized.config
        opts = {
            transparent = {
                enabled = true,
                pmenu = true,
                normal = true,
                normalfloat = true,
                neotree = true,
                nvimtree = true,
                whichkey = true,
                telescope = true,
                lazy = true,
            },
            variant = "autumn",
            styles = {
                comments = { italic = true, bold = false },
                -- functions = { italic = true },
                -- variables = { italic = false },
            },
        },
        config = function(_, opts)
            -- vim.o.termguicolors = true
            -- vim.o.background = "light"
            require("solarized").setup(opts)
            vim.cmd.colorscheme "solarized"
        end,
    },
}
