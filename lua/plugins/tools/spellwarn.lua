return {
  {
    "ravibrock/spellwarn.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      require("spellwarn").setup(opts)
    end,
    opts = {
      event = {
        "CursorHold",
        "InsertLeave",
      },
      enable = true,
      ft_config = {
        alpha = false,
        help = false,
        lazy = false,
        lspinfo = false,
        mason = false,
        gitcommit = "iter",
        markdown = "iter",
        text = "iter",
      },
      ft_default = true,
      max_file_size = 4000,
      severity = {
        spellbad = "WARN",
        spellcap = "HINT",
        spelllocal = "HINT",
        spellrare = "INFO",
      },
      suggest = false,
      num_suggest = 0,
      prefix = "Possible misspelling(s): ",
      diagnostic_opts = {
        severity_sort = true,
      },
    },
  },
}
