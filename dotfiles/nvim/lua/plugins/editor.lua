return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    cmd = "Telescope",
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        { "<Leader>p",  ":Telescope find_files<CR>", { desc = "find files" } },
        { "<Leader>P",  ":Telescope live_grep<CR>",  { desc = "grep file" } },
        { "<Leader>rs", ":Telescope resume<CR>",     { desc = "resume" } },
    }
}
