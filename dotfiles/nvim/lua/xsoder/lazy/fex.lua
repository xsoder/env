return {
    '2hdddg/fex.nvim',
    lazy = false, -- set to true if you want it to load on a specific event
    config = function()
        require("fex").setup({ ls = "-al" })
    end
}
