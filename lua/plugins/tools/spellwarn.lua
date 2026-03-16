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
      },
      ft_default = "iter",
      max_file_size = 4000,
      severity = {
        spellbad = "HINT",
        spellcap = "HINT",
        spelllocal = "HINT",
        spellrare = "HINT",
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
