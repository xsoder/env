local palette = {
    base = "#191724",     -- base--menu "hello"
    surface = "#1f1d2e",  -- surface
    overlay = "#26233a",  -- overlay
    muted = "#6e6a86",    -- muted
    subtle = "#908caa",   -- subtle
    text = "#e0def4",     -- text
    love = "#eb6f92",     -- love
    gold = "#f6c177",     -- gold
    rose = "#ebbcba",     -- rose
    pine = "#31748f",     -- pine
    foam = "#9ccfd8",     -- foam
    iris = "#c4a7e7",     -- iris
    highlight_low = "#21202e",
    highlight_med = "#403d52",
    highlight_high = "#524f67",
}

local function apply_rosepine_scheme()
    vim.opt.termguicolors = true
    vim.cmd("colorscheme rose-pine")
    vim.g.rose_pine_disable_italics = true

    -- Base UI
    vim.api.nvim_set_hl(0, "Normal", { bg = palette.base, fg = palette.text })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = palette.base, fg = palette.text })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = palette.surface, fg = palette.text })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = palette.muted, bg = palette.surface })
    vim.api.nvim_set_hl(0, "VertSplit", { fg = palette.highlight_med, bg = palette.base })
    vim.api.nvim_set_hl(0, "StatusLine", { fg = palette.subtle, bg = palette.surface })
    vim.api.nvim_set_hl(0, "StatusLineNC", { fg = palette.muted, bg = palette.base })
    vim.api.nvim_set_hl(0, "TabLine", { fg = palette.subtle, bg = palette.surface })
    vim.api.nvim_set_hl(0, "TabLineFill", { bg = palette.surface })
    vim.api.nvim_set_hl(0, "TabLineSel", { fg = palette.text, bg = palette.overlay })

    -- Syntax
    vim.api.nvim_set_hl(0, "Comment", { fg = palette.muted })
    vim.api.nvim_set_hl(0, "Constant", { fg = palette.gold })
    vim.api.nvim_set_hl(0, "String", { fg = palette.gold })
    vim.api.nvim_set_hl(0, "Character", { fg = palette.gold })
    vim.api.nvim_set_hl(0, "Number", { fg = palette.gold })
    vim.api.nvim_set_hl(0, "Boolean", { fg = palette.rose })
    vim.api.nvim_set_hl(0, "Float", { fg = palette.gold })
    vim.api.nvim_set_hl(0, "Identifier", { fg = palette.rose })
    vim.api.nvim_set_hl(0, "Function", { fg = palette.rose })
    vim.api.nvim_set_hl(0, "Statement", { fg = palette.pine })
    vim.api.nvim_set_hl(0, "Conditional", { fg = palette.pine })
    vim.api.nvim_set_hl(0, "Repeat", { fg = palette.pine })
    vim.api.nvim_set_hl(0, "Label", { fg = palette.foam })
    vim.api.nvim_set_hl(0, "Operator", { fg = palette.subtle })
    vim.api.nvim_set_hl(0, "Keyword", { fg = palette.pine })
    vim.api.nvim_set_hl(0, "Exception", { fg = palette.pine })
    vim.api.nvim_set_hl(0, "PreProc", { fg = palette.iris })
    vim.api.nvim_set_hl(0, "Include", { fg = palette.iris })
    vim.api.nvim_set_hl(0, "Define", { fg = palette.iris })
    vim.api.nvim_set_hl(0, "Macro", { fg = palette.iris })
    vim.api.nvim_set_hl(0, "PreCondit", { fg = palette.iris })
    vim.api.nvim_set_hl(0, "Type", { fg = palette.foam })
    vim.api.nvim_set_hl(0, "StorageClass", { fg = palette.foam })
    vim.api.nvim_set_hl(0, "Structure", { fg = palette.foam })
    vim.api.nvim_set_hl(0, "Typedef", { fg = palette.foam })
    vim.api.nvim_set_hl(0, "Special", { fg = palette.rose })
    vim.api.nvim_set_hl(0, "SpecialChar", { fg = palette.rose })
    vim.api.nvim_set_hl(0, "Tag", { fg = palette.rose })
    vim.api.nvim_set_hl(0, "Delimiter", { fg = palette.subtle })
    vim.api.nvim_set_hl(0, "SpecialComment", { fg = palette.iris })
    vim.api.nvim_set_hl(0, "Debug", { fg = palette.rose })
    vim.api.nvim_set_hl(0, "Underlined", { underline = true })
    vim.api.nvim_set_hl(0, "Error", { fg = palette.love })
    vim.api.nvim_set_hl(0, "Todo", { fg = palette.iris })

    -- UI Elements
    vim.api.nvim_set_hl(0, "CursorLine", { bg = palette.highlight_low })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = palette.text })
    vim.api.nvim_set_hl(0, "LineNr", { fg = palette.muted })
    vim.api.nvim_set_hl(0, "ColorColumn", { bg = palette.overlay })
    vim.api.nvim_set_hl(0, "CursorColumn", { bg = palette.highlight_low })
    vim.api.nvim_set_hl(0, "Folded", { fg = palette.text, bg = palette.surface })
    vim.api.nvim_set_hl(0, "FoldColumn", { fg = palette.muted })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = palette.base })
    vim.api.nvim_set_hl(0, "MatchParen", { fg = palette.text, bg = palette.highlight_med })
    vim.api.nvim_set_hl(0, "Visual", { bg = palette.highlight_med })
    vim.api.nvim_set_hl(0, "NonText", { fg = palette.muted })
    vim.api.nvim_set_hl(0, "SpecialKey", { fg = palette.foam })
    vim.api.nvim_set_hl(0, "Title", { fg = palette.text })
    vim.api.nvim_set_hl(0, "Conceal", {})
    vim.api.nvim_set_hl(0, "Directory", { fg = palette.foam })

    -- Pmenu
    vim.api.nvim_set_hl(0, "Pmenu", { fg = palette.subtle, bg = palette.surface })
    vim.api.nvim_set_hl(0, "PmenuSel", { fg = palette.text, bg = palette.overlay })
    vim.api.nvim_set_hl(0, "PmenuSbar", { bg = palette.highlight_low })
    vim.api.nvim_set_hl(0, "PmenuThumb", { bg = palette.highlight_med })

    -- Diffs
    vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#333c48" })
    vim.api.nvim_set_hl(0, "DiffChange", { bg = palette.overlay })
    vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#43293a" })
    vim.api.nvim_set_hl(0, "DiffText", { bg = "#433842" })

    -- Search
    vim.api.nvim_set_hl(0, "Search", { bg = palette.highlight_med })
    vim.api.nvim_set_hl(0, "IncSearch", { fg = palette.base, bg = palette.rose })

    -- Messages
    vim.api.nvim_set_hl(0, "ErrorMsg", { fg = palette.love, bold = true })
    vim.api.nvim_set_hl(0, "WarningMsg", { fg = palette.gold })
    vim.api.nvim_set_hl(0, "ModeMsg", { fg = palette.subtle })
    vim.api.nvim_set_hl(0, "MoreMsg", { fg = palette.iris })
    vim.api.nvim_set_hl(0, "Question", { fg = palette.gold })

    local transparent_groups = {
        "Normal", "NormalNC", "NormalFloat",  "VertSplit",
        "SignColumn", "EndOfBuffer", "MsgArea", "Pmenu", "TelescopeNormal",
        "WinSeparator"
    }

    for _, group in ipairs(transparent_groups) do
        vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
    end
end

apply_rosepine_scheme()
