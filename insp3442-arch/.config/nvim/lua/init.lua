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

vim.g.nvim_tree_width = 25
require("nvim-tree").setup()

require('lualine').setup{
    extensions = {'nvim-tree','toggleterm'},
}
