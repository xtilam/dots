return {
  "windwp/nvim-ts-autotag",
  ft = { "javascriptreact", "typescriptreact", "html", "xml" },
  config = function()
    require("nvim-ts-autotag").setup()
  end,
}
