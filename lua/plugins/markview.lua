-- markview
-- https://github.com/OXY2DEV/markview.nvim

return {
  'OXY2DEV/markview.nvim',
  -- NOTE: nixCats: return true only if category is enabled, else false
  enabled = require('nixCatsUtils').enableForCategory("general"),
  ft = "markdown", -- Only load on markdown files
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    require("markview").setup({
      -- Highlight modes (normal, insert, hybrid)
      modes = { "n", "no", "c" }, -- Enable in normal, operator-pending, and command modes
      hybrid_modes = { "n" }, -- Modes where hybrid highlighting is used

      -- Headings configuration
      headings = {
        enable = true,
        shift_width = 0,
        heading_1 = {
          style = "label",
          icon = "󰉫 ",
          hl = "MarkviewHeading1"
        },
        heading_2 = {
          style = "label",
          icon = "󰉬 ",
          hl = "MarkviewHeading2"
        },
        heading_3 = {
          style = "label",
          icon = "󰉭 ",
          hl = "MarkviewHeading3"
        },
        heading_4 = {
          style = "label",
          icon = "󰉮 ",
          hl = "MarkviewHeading4"
        },
        heading_5 = {
          style = "label",
          icon = "󰉯 ",
          hl = "MarkviewHeading5"
        },
        heading_6 = {
          style = "label",
          icon = "󰉰 ",
          hl = "MarkviewHeading6"
        }
      },

      -- Code blocks
      code_blocks = {
        enable = true,
        style = "language",
        icons = "mini",
        hl = "MarkviewCode",
        info_hl = "MarkviewCodeInfo",
        min_width = 70,
        pad_amount = 2,
        pad_char = " ",
        language_direction = "left"
      },

      -- Inline code
      inline_codes = {
        enable = true,
        corner_left = " ",
        corner_right = " ",
        hl = "MarkviewInlineCode"
      },

      -- Block quotes
      block_quotes = {
        enable = true,
        default = {
          border_left = "▋",
          hl = "MarkviewBlockQuote"
        },
        callouts = {
          {
            match_string = "ABSTRACT",
            callout_preview = "󰨸 Abstract",
            callout_preview_hl = "MarkviewBlockQuoteNote",
            custom_title = true
          },
          {
            match_string = "INFO",
            callout_preview = "󰋽 Info",
            callout_preview_hl = "MarkviewBlockQuoteNote",
            custom_title = true
          },
          {
            match_string = "TIP",
            callout_preview = "󰌶 Tip",
            callout_preview_hl = "MarkviewBlockQuoteOk",
            custom_title = true
          },
          {
            match_string = "SUCCESS",
            callout_preview = "󰄬 Success",
            callout_preview_hl = "MarkviewBlockQuoteOk",
            custom_title = true
          },
          {
            match_string = "QUESTION",
            callout_preview = "󰘥 Question",
            callout_preview_hl = "MarkviewBlockQuoteNote",
            custom_title = true
          },
          {
            match_string = "WARNING",
            callout_preview = "󰀪 Warning",
            callout_preview_hl = "MarkviewBlockQuoteWarn",
            custom_title = true
          },
          {
            match_string = "FAILURE",
            callout_preview = "󰅖 Failure",
            callout_preview_hl = "MarkviewBlockQuoteError",
            custom_title = true
          },
          {
            match_string = "DANGER",
            callout_preview = "󱐌 Danger",
            callout_preview_hl = "MarkviewBlockQuoteError",
            custom_title = true
          },
          {
            match_string = "BUG",
            callout_preview = "󰨰 Bug",
            callout_preview_hl = "MarkviewBlockQuoteError",
            custom_title = true
          },
          {
            match_string = "EXAMPLE",
            callout_preview = "󰉹 Example",
            callout_preview_hl = "MarkviewBlockQuoteSpecial",
            custom_title = true
          },
          {
            match_string = "QUOTE",
            callout_preview = "󱆨 Quote",
            callout_preview_hl = "MarkviewBlockQuoteDefault",
            custom_title = true
          }
        }
      },

      -- Horizontal rules
      horizontal_rules = {
        enable = true,
        parts = {
          {
            type = "repeating",
            repeat_amount = function()
              local textwidth = vim.bo.textwidth
              if textwidth ~= 0 then
                return textwidth
              else
                return vim.api.nvim_win_get_width(0) - 5
              end
            end,
            text = "─",
            hl = "MarkviewGradient1"
          }
        }
      },

      -- Lists
      list_items = {
        enable = true,
        shift_width = 2,
        indent_size = 2,
        marker_minus = {
          add_padding = true,
          text = "•",
          hl = "MarkviewListItemMinus"
        },
        marker_plus = {
          add_padding = true,
          text = "•",
          hl = "MarkviewListItemPlus"
        },
        marker_star = {
          add_padding = true,
          text = "•",
          hl = "MarkviewListItemStar"
        },
        marker_dot = {
          add_padding = true,
          hl = "MarkviewListItemDot"
        },
        marker_parenthesis = {
          add_padding = true,
          hl = "MarkviewListItemParenthesis"
        }
      },

      -- Checkboxes
      checkboxes = {
        enable = true,
        checked = {
          text = "󰱒 ",
          hl = "MarkviewCheckboxChecked"
        },
        unchecked = {
          text = "󰄱 ",
          hl = "MarkviewCheckboxUnchecked"
        },
        pending = {
          text = "󰥔 ",
          hl = "MarkviewCheckboxPending"
        }
      },

      -- Tables
      tables = {
        enable = true,
        text = "─",
        hl = "MarkviewTableHeader",
        use_virt_lines = true
      },

      -- Links
      links = {
        enable = true,
        hyperlinks = {
          icon = "󰌷 ",
          hl = "MarkviewHyperlink"
        },
        images = {
          icon = "󰥶 ",
          hl = "MarkviewImageLink"
        },
        emails = {
          icon = "󰇮 ",
          hl = "MarkviewEmail"
        }
      }
    })
  end,
}