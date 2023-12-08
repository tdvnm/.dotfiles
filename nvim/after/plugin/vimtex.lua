-- Enable filetype plugin and indent
vim.cmd('filetype plugin indent on')

-- Enable syntax highlighting
vim.cmd('syntax enable')


-- Set the compiler method for VimTeX
vim.g.vimtex_compiler_method = 'latexmk'

vim.g.tex_flavor = "latexmk"
vim.g.tex_latexmk = {
    build_dir = ".",
    options = {
        "-pdf",
        "-interaction=nonstopmode",
        "-f",
    },
}

vim.g.vimtex_compiler_latexmk_engines = {
    _ = "-lualatex",
}

-- Set the viewer options for VimTeX
vim.g.vimtex_view_method = 'zathura'        -- Built-in viewer method
vim.g.vimtex_view_general_viewer = 'okular' -- Generic interface viewer
vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'


-- Set the local leader mapping for VimTeX
vim.g.maplocalleader = ","
