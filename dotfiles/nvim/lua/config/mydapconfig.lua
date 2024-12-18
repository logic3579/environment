local dap, dapui = require("dap"), require("dapui")

-- -- dap python
-- dap.adapters.python = function(cb, config)
--     if config.request == "attach" then
--         ---@diagnostic disable-next-line: undefined-field
--         local port = (config.connect or config).port
--         ---@diagnostic disable-next-line: undefined-field
--         local host = (config.connect or config).host or "127.0.0.1"
--         cb({
--             type = "server",
--             port = assert(port, "`connect.port` is required for a python `attach` configuration"),
--             host = host,
--             options = {
--                 source_filetype = "python",
--             },
--         })
--     else
--         cb({
--             type = "executable",
--             -- command = "python3",
--             command = "./venv/bin/python",
--             command = os.getenv("VIRTUAL_ENV") .. "/bin/python"
--             args = { "-m", "debugpy.adapter" },
--             options = {
--                 source_filetype = "python",
--             },
--         })
--     end
-- end
-- dap.configurations.python = {
--     {
--         type = "python",
--         request = "launch",
--         name = "Launch file",
--         program = "${file}",
--         pythonPath = function()
--             local cwd = vim.fn.getcwd()
--             if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
--                 return cwd .. "/venv/bin/python"
--             elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
--                 return cwd .. "/.venv/bin/python"
--             else
--                 return "/usr/bin/python3"
--             end
--         end,
--     },
--     {
--         type = "python",
--         request = "attach",
--         name = "Attach remote",
--         connect = function()
--             local host = vim.fn.input("Host [127.0.0.1]: ")
--             host = host ~= "" and host or "127.0.0.1"
--             local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678
--             return { host = host, port = port }
--         end,
--     },
-- }

-- -- dap-go
-- -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#go-using-delve-directly

-- dap-ui
dapui.setup({
    expand_lines = true,
    icons = { expanded = "", collapsed = "", current_frame = "" },
    mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    layouts = {
        {
            elements = {
                { id = "scopes",      size = 0.33 },
                { id = "breakpoints", size = 0.17 },
                { id = "stacks",      size = 0.25 },
                { id = "watches",     size = 0.25 },
            },
            size = 0.33,
            position = "right",
        },
        {
            elements = {
                { id = "repl",    size = 0.45 },
                { id = "console", size = 0.55 },
            },
            size = 0.27,
            position = "bottom",
        },
    },
    controls = {
        enabled = true,
        element = "repl",
    },
    floating = {
        max_height = 0.9,
        max_width = 0.5,
        border = "single", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    render = {
        max_type_length = nil,
        max_value_lines = 100,
    },
})
dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close({})
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close({})
end
