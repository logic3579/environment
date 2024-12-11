return {
    {
        "mfussenegger/nvim-dap",
        --keys = {
        --    { "<Leader>de", ":lua require'dap'.toggle_breakpoint()<CR>" },
        --}
        config = function()
            require("config/mydapconfig")
            -- require("nvim-dap-virtual-text").setup(){
            --     commented = true,
            -- }
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        }
    },
    --{
    --    "theHamsta/nvim-dap-virtual-text",
    --},
}
