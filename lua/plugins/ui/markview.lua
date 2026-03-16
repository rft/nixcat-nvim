-- markview
-- https://github.com/OXY2DEV/markview.nvim

return {
  'OXY2DEV/markview.nvim',
  -- NOTE: nixCats: return true only if category is enabled, else false
  enabled = require('nixCatsUtils').enableForCategory 'general',
  ft = 'markdown', -- Only load on markdown files
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('markview').setup {
      preview = {
        modes = { 'n', 'no', 'c' },
        hybrid_modes = { 'n' },
        icon_provider = 'mini',
      },

      markdown = {
        headings = {
          enable = true,
          shift_width = 0,
          heading_1 = { style = 'label', icon = '󰉫 ', hl = 'MarkviewHeading1' },
          heading_2 = { style = 'label', icon = '󰉬 ', hl = 'MarkviewHeading2' },
          heading_3 = { style = 'label', icon = '󰉭 ', hl = 'MarkviewHeading3' },
          heading_4 = { style = 'label', icon = '󰉮 ', hl = 'MarkviewHeading4' },
          heading_5 = { style = 'label', icon = '󰉯 ', hl = 'MarkviewHeading5' },
          heading_6 = { style = 'label', icon = '󰉰 ', hl = 'MarkviewHeading6' },
        },

        code_blocks = {
          enable = true,
          border_hl = 'MarkviewCode',
          info_hl = 'MarkviewCodeInfo',
          label_direction = 'left',
          min_width = 70,
          pad_amount = 2,
          pad_char = ' ',
          style = 'block',
        },

        block_quotes = {
          enable = true,
          wrap = true,
          default = {
            border = '▋',
            hl = 'MarkviewBlockQuote',
          },
          ABSTRACT = {
            preview = '󰨸 Abstract',
            preview_hl = 'MarkviewBlockQuoteNote',
            hl = 'MarkviewBlockQuoteNote',
            custom_title = true,
          },
          INFO = {
            preview = '󰋽 Info',
            preview_hl = 'MarkviewBlockQuoteNote',
            hl = 'MarkviewBlockQuoteNote',
            custom_title = true,
          },
          TIP = {
            preview = '󰌶 Tip',
            preview_hl = 'MarkviewBlockQuoteOk',
            hl = 'MarkviewBlockQuoteOk',
            custom_title = true,
          },
          SUCCESS = {
            preview = '󰄬 Success',
            preview_hl = 'MarkviewBlockQuoteOk',
            hl = 'MarkviewBlockQuoteOk',
            custom_title = true,
          },
          QUESTION = {
            preview = '󰘥 Question',
            preview_hl = 'MarkviewBlockQuoteNote',
            hl = 'MarkviewBlockQuoteNote',
            custom_title = true,
          },
          WARNING = {
            preview = '󰀪 Warning',
            preview_hl = 'MarkviewBlockQuoteWarn',
            hl = 'MarkviewBlockQuoteWarn',
            custom_title = true,
          },
          FAILURE = {
            preview = '󰅖 Failure',
            preview_hl = 'MarkviewBlockQuoteError',
            hl = 'MarkviewBlockQuoteError',
            custom_title = true,
          },
          DANGER = {
            preview = '󱐌 Danger',
            preview_hl = 'MarkviewBlockQuoteError',
            hl = 'MarkviewBlockQuoteError',
            custom_title = true,
          },
          BUG = {
            preview = '󰨰 Bug',
            preview_hl = 'MarkviewBlockQuoteError',
            hl = 'MarkviewBlockQuoteError',
            custom_title = true,
          },
          EXAMPLE = {
            preview = '󰉹 Example',
            preview_hl = 'MarkviewBlockQuoteSpecial',
            hl = 'MarkviewBlockQuoteSpecial',
            custom_title = true,
          },
          QUOTE = {
            preview = '󱆨 Quote',
            preview_hl = 'MarkviewBlockQuoteDefault',
            hl = 'MarkviewBlockQuoteDefault',
            custom_title = true,
          },
        },

        horizontal_rules = {
          enable = true,
          parts = {
            {
              type = 'repeating',
              repeat_amount = function()
                local textwidth = vim.bo.textwidth
                if textwidth ~= 0 then
                  return textwidth
                else
                  return vim.api.nvim_win_get_width(0) - 5
                end
              end,
              text = '─',
              hl = 'MarkviewGradient1',
            },
          },
        },

        list_items = {
          enable = true,
          shift_width = 2,
          indent_size = 2,
          marker_minus = {
            add_padding = true,
            text = '•',
            hl = 'MarkviewListItemMinus',
          },
          marker_plus = {
            add_padding = true,
            text = '•',
            hl = 'MarkviewListItemPlus',
          },
          marker_star = {
            add_padding = true,
            text = '•',
            hl = 'MarkviewListItemStar',
          },
          marker_dot = {
            add_padding = true,
            hl = 'MarkviewListItemDot',
          },
          marker_parenthesis = {
            add_padding = true,
            hl = 'MarkviewListItemParenthesis',
          },
        },

        tables = {
          enable = true,
          use_virt_lines = true,
        },
      },

      markdown_inline = {
        inline_codes = {
          enable = true,
          corner_left = ' ',
          corner_right = ' ',
          hl = 'MarkviewInlineCode',
        },

        checkboxes = {
          enable = true,
          checked = { text = '󰱒 ', hl = 'MarkviewCheckboxChecked' },
          unchecked = { text = '󰄱 ', hl = 'MarkviewCheckboxUnchecked' },
          pending = { text = '󰥔 ', hl = 'MarkviewCheckboxPending' },
        },

        hyperlinks = {
          enable = true,
          default = { icon = '󰌷 ', hl = 'MarkviewHyperlink' },
        },

        images = {
          enable = true,
          default = { icon = '󰥶 ', hl = 'MarkviewImageLink' },
        },

        emails = {
          enable = true,
          default = { icon = '󰇮 ', hl = 'MarkviewEmail' },
        },
      },
    }
  end,
}
