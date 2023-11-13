return {
    {
        "nvimdev/dashboard-nvim",
        opts = function(_, opts)
            opts.config.center = {
                { action = "Telescope oldfiles", desc = " Recent files", icon = " ", key = "r" },
                { action = "Telescope projects", desc = " Projects", icon = " ", key = "p", },
                { action = "qa", desc = " Quit", icon = " ", key = "q" },
            }
        end,
    }
}
