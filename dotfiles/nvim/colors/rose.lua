local palette = {
    base = "#191724",     -- Darkest base
    surface = "#1f1d2e",  -- Lighter background
    overlay = "#26233a",  -- Background overlay
    muted = "#6e6a86",    -- Muted color tones
    subtle = "#908caa",   -- Subtle tones for secondary UI
    text = "#e0def4",     -- Main text color
    white = "#ffffff",     -- Main text color
    love = "#eb6f92",     -- Accent: love
    gold = "#f6c177",     -- Accent: gold
    rose = "#ebbcba",     -- Accent: rose
    pine = "#31748f",     -- Accent: pine
    foam = "#9ccfd8",     -- Accent: foam
    iris = "#c4a7e7",     -- Accent: iris
    highlight_low = "#21202e",
    highlight_med = "#403d52",
    highlight_high = "#524f67",
}

local function apply_my_rosepine()
    vim.opt.termguicolors = true

    require("rose-pine").setup({
        disable_background = true,
        disable_float_background = true,
        disable_italics = true,
        styles = {
            bold = true,
            italic = true,
            transparency = true,
        },
    })

    vim.cmd("colorscheme rose-pine")

    -- Force transparency for specific UI elements while preserving text colors
    local transparent_groups = {
        "Normal", "NormalNC", "NormalFloat", "FloatBorder", "VertSplit",
        "SignColumn", "EndOfBuffer", "MsgArea", "Pmenu",
        "TelescopeNormal",
        "WinSeparator"
    }

    -- Apply transparency for backgrounds
    for _, group in ipairs(transparent_groups) do
        vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
    end

    -- Set other highlights with Rose Pine colors and contrast
    vim.api.nvim_set_hl(0, "Comment", { fg = palette.muted, italic = true })
    vim.api.nvim_set_hl(0, "Constant", { fg = palette.gold })
    vim.api.nvim_set_hl(0, "String", { fg = palette.foam })
    vim.api.nvim_set_hl(0, "Function", { fg = palette.rose, bold=true})
    vim.api.nvim_set_hl(0, "Keyword", { fg = palette.iris, bold=true})
    vim.api.nvim_set_hl(0, "Identifier", { fg = palette.rose })
    vim.api.nvim_set_hl(0, "Statement", { fg = palette.pine })
    vim.api.nvim_set_hl(0, "Type", { fg = palette.iris })
    vim.api.nvim_set_hl(0, "Operator", { fg = palette.iris })

    -- Add some subtle highlights for UI elements (e.g., cursorline)
    vim.api.nvim_set_hl(0, "CursorLine", { bg = palette.highlight_low })
    vim.api.nvim_set_hl(0, "StatusLine", { fg = palette.white,bg=palette.base })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = palette.iris, bold = true })
    vim.api.nvim_set_hl(0, "LineNr", { fg = palette.highlight_med })
end

-- Call function to apply the custom theme
apply_my_rosepine()


