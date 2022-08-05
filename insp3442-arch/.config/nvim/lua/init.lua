require('bufferline').setup {
    options = {
        numbers = "ordinal",
        offsets = {{filetype = "NvimTree", text = "NvimTree" , text_align = "left" }},
  }
}

require("toggleterm").setup({
    open_mapping = [[<c-o>]],
    direction = 'float',
    shell = "zsh",
})

require('lualine').setup{
    extensions = {'nvim-tree','toggleterm'},
    options = {theme = 'nord'}
}
