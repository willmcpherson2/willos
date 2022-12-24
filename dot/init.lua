-- options

vim.o.clipboard = "unnamedplus"
vim.o.mouse = "a"
vim.o.hidden = true
vim.o.wildmode = "longest:list:full"
vim.o.inccommand = "nosplit"
vim.o.wrap = false
vim.o.linebreak = true
vim.o.autoindent = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.cmdheight = 0

-- maps

function Map(mode, key, cmd)
  vim.keymap.set(mode, key, cmd, {
    noremap = true,
    silent = true,
  })
end

Map("", "<space>", "<nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

Map("n", "Q", "<nop>")

Map("n", "<leader>w", "<cmd>wa<cr>")
Map("n", "<leader>q", "<cmd>qa<cr>")
Map("n", "<leader>Q", "<cmd>qa!<cr>")

Map("n", "<bs>", "<c-^>")
Map("n", "<leader>c", "<cmd>bd<cr>")
Map("n", "<leader>C", "<cmd>bd!<cr>")

Map("n", "<leader>n", "<cmd>noh<cr><c-l>")
Map("n", "<leader>r", ":%s/\\<<c-r><c-w>\\>/<c-r><c-w>/g<c-f>$F/i")
Map("n", "<leader>-", "80a-<esc>0")

Map("t", "<c-a>", "<c-\\><c-n>")
Map("n", "<c-t>", "<cmd>term<cr>")
Map("t", "<c-t>", "<c-\\><c-o><cmd>term<cr>")

-- plugins

require("packer").startup(function(use)
  use "wbthomason/packer.nvim"

  use "catppuccin/nvim"

  use {
    "willmcpherson2/gnome.nvim",
    config = function()
      require("gnome").setup {
        on_light = function()
          vim.cmd.colorscheme("catppuccin-latte")
        end,
        on_dark = function()
          vim.cmd.colorscheme("catppuccin-frappe")
        end,
      }
    end
  }

  use {
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      require("lualine").setup {
        sections = {
          lualine_b = {
            {
              "macro-recording", fmt = function()
                local recording_register = vim.fn.reg_recording()
                if recording_register == "" then
                  return ""
                else
                  return "recording @" .. recording_register
                end
              end
            },
          },
        }
      }
    end
  }

  use {
    "noib3/nvim-cokeline",
    config = function()
      local get_hex = require("cokeline.utils").get_hex
      require("cokeline").setup {
        show_if_buffers_are_at_least = 2,
        rendering = {
          max_buffer_width = 30,
        },
        components = {
          {
            text = " ",
            bg = get_hex("Normal", "bg"),
          },
          { text = " ", },
          {
            text = "",
            delete_buffer_on_left_click = true,
          },
          { text = " ", },
          {
            text = function(buffer)
              return buffer.filename
            end,
          },
          { text = " ", },
        },
      }

      Map("n", "<c-left>", "<Plug>(cokeline-focus-prev)")
      Map("n", "<c-right>", "<Plug>(cokeline-focus-next)")
      Map("n", "<c-down>", "<Plug>(cokeline-switch-prev)")
      Map("n", "<c-up>", "<Plug>(cokeline-switch-next)")

      Map("t", "<s-left>", "<c-\\><c-o><Plug>(cokeline-focus-prev)")
      Map("t", "<s-right>", "<c-\\><c-o><Plug>(cokeline-focus-next)")
      Map("t", "<s-down>", "<c-\\><c-o><Plug>(cokeline-switch-prev)")
      Map("t", "<s-up>", "<c-\\><c-o><Plug>(cokeline-switch-next)")
    end
  }

  use {
    "Darazaki/indent-o-matic",
    config = function()
      require("indent-o-matic").setup {}
    end
  }

  use {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end
  }

  use "hrsh7th/cmp-nvim-lsp"
  use "ray-x/cmp-treesitter"
  use "hrsh7th/cmp-buffer"
  use {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      cmp.setup {
        completion = {
          autocomplete = false,
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "treesitter" },
          { name = "buffer" },
        },
        mapping = {
          ["<c-n>"] = cmp.mapping.complete(),
          ["<c-e>"] = cmp.mapping.abort(),
          ["<up>"] = cmp.mapping.select_prev_item(),
          ["<down>"] = cmp.mapping.select_next_item(),
          ["<c-u>"] = cmp.mapping.scroll_docs(-4),
          ["<c-d>"] = cmp.mapping.scroll_docs(4),
          ["<cr>"] = cmp.mapping.confirm({ select = true }),
        },
      }
    end
  }

  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      local gs = require("gitsigns")
      gs.setup {}
      Map("n", "<leader>gs", gs.show)
      Map("n", "<leader>gd", gs.diffthis)
      Map("n", "<leader>gn", gs.next_hunk)
      Map("n", "<leader>gp", gs.prev_hunk)
      Map("n", "<leader>gh", function() gs.setqflist("all") end)
    end
  }

  use {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup {
        sources = {
          null_ls.builtins.code_actions.gitsigns,
        },
      }
    end
  }

  use {
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/plenary.nvim" } },
    config = function()
      local builtin = require("telescope.builtin")

      Map("n", "<leader>ff", builtin.find_files)
      Map("n", "<leader>fb", builtin.buffers)
      Map("n", "<leader>f/", builtin.live_grep)
      Map("n", "<leader>f*", builtin.grep_string)
      Map("n", "<leader>fh", builtin.help_tags)

      Map("n", "<leader>gg", builtin.git_status)
      Map("n", "<leader>gb", builtin.git_branches)
      Map("n", "<leader>gc", builtin.git_commits)

      Map("n", "<leader>ls", builtin.lsp_dynamic_workspace_symbols)
      Map("n", "<leader>le", builtin.diagnostics)
    end
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup {
        highlight = { enable = true },
        context_commentstring = { enable = true },
        ensure_installed = {
          "vim",
          "lua",
          "help",
          "diff",
          "markdown",
          "javascript",
          "typescript",
          "tsx",
          "html",
          "css",
          "haskell",
          "nix",
          "llvm",
          "rust",
          "toml",
          "yaml",
          "c",
          "cpp",
          "make",
          "python",
          "java",
          "kotlin",
        },
      }
    end
  }

  use {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      Map("n", "<leader>li", vim.lsp.buf.hover)
      Map("n", "<leader>ld", vim.lsp.buf.definition)
      Map("n", "<leader>la", vim.lsp.buf.code_action)
      Map("n", "<leader>lf", function() vim.lsp.buf.format { async = true } end)
      Map("n", "<leader>lr", vim.lsp.buf.rename)
      Map("n", "<leader>lo", vim.diagnostic.open_float)
      Map("n", "<leader>ln", vim.diagnostic.goto_next)
      Map("n", "<leader>lp", vim.diagnostic.goto_prev)

      vim.diagnostic.config {
        signs = false,
        update_in_insert = true,
        severity_sort = true,
      }

      lspconfig.rnix.setup {}

      lspconfig.bashls.setup {}

      lspconfig.sumneko_lua.setup {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" }
            },
            telemetry = {
              enable = false,
            },
          }
        }
      }

      lspconfig.clangd.setup {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--cross-file-rename",
          "--header-insertion=iwyu",
          "--suggest-missing-includes",
        },
      }

      lspconfig.html.setup {}

      lspconfig.cssls.setup {}

      lspconfig.tsserver.setup {}

      lspconfig.pylsp.setup {}

      lspconfig.hls.setup {
        haskell = {
          formattingProvider = "fourmolu"
        }
      }

      lspconfig.rust_analyzer.setup {}
    end
  }
end)
