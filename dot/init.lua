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
vim.o.spelllang = "en_au,en_gb"

-- mappings

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

Map("n", "<leader>w", ":wa<cr>")
Map("n", "<leader>q", ":qa<cr>")
Map("n", "<leader>Q", ":qa!<cr>")

Map("n", "<bs>", "<c-^>")
Map("n", "<leader>c", ":bd<cr>")
Map("n", "<leader>C", ":bd!<cr>")

Map("t", "<c-n>", "<c-\\><c-n>")
Map("n", "<c-t>", ":term<cr>")
Map("t", "<c-t>", "<c-\\><c-o>:term<cr>")

Map("n", "<leader>r", ":%s///g<c-f>")
Map("v", "<leader>r", ":s///g<c-f>")
Map("n", "<leader>R", ":%s/\\<<c-r><c-w>\\>/<c-r><c-w>/g<c-f><left>")
Map("v", "<leader>R", ":s/\\<<c-r><c-w>\\>/<c-r><c-w>/g<c-f><left>")

Map("v", "Q", ":'<,'>norm! @q<cr>")

Map("n", "<leader>n", ":noh<cr><c-l>")
Map("n", "<leader>-", "80a-<esc>0")

-- plugins

require("packer").startup(function(use)
  use "wbthomason/packer.nvim"

  use {
    "catppuccin/nvim",
    as = "catppuccin",
    config = function()
      require("catppuccin").setup {
        background = {
          light = "latte",
          dark = "frappe",
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          telescope = true,
          treesitter = true,
          native_lsp = {
            enabled = true,
          },
        },
      }
      vim.cmd.colorscheme("catppuccin")
    end
  }

  use {
    "willmcpherson2/gnome.nvim",
    config = function()
      require("gnome").setup {}
    end
  }

  use "kyazdani42/nvim-web-devicons"

  use {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup {
        options = {
          theme = "catppuccin"
        },
        sections = {
          lualine_c = {
            {
              "filename",
              path = 1,
            }
          }
        }
      }
    end
  }

  use {
    "akinsho/bufferline.nvim",
    after = "catppuccin",
    config = function()
      require("bufferline").setup {
        highlights = require("catppuccin.groups.integrations.bufferline").get()
      }

      Map("n", "<c-left>", ":BufferLineCyclePrev<cr>")
      Map("n", "<c-right>", ":BufferLineCycleNext<cr>")
      Map("n", "<c-down>", ":BufferLineMovePrev<cr>")
      Map("n", "<c-up>", ":BufferLineMoveNext<cr>")

      Map("t", "<s-left>", "<c-\\><c-o>:BufferLineCyclePrev<cr>")
      Map("t", "<s-right>", "<c-\\><c-o>:BufferLineCycleNext<cr>")
      Map("t", "<s-down>", "<c-\\><c-o>:BufferLineMovePrev<cr>")
      Map("t", "<s-up>", "<c-\\><c-o>:BufferLineMoveNext<cr>")
    end
  }

  use {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end
  }

  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "ray-x/cmp-treesitter",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "f3fora/cmp-spell",
      "hrsh7th/cmp-emoji",
      "dmitmel/cmp-digraphs",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup {
        sources = {
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "treesitter" },
          { name = "path" },
          { name = "buffer" },
          { name = "spell" },
          { name = "emoji", insert = true },
          { name = "digraphs" },
        },
        mapping = {
          ["<c-e>"] = cmp.mapping.abort(),
          ["<up>"] = cmp.mapping.select_prev_item(),
          ["<down>"] = cmp.mapping.select_next_item(),
          ["<c-u>"] = cmp.mapping.scroll_docs(-4),
          ["<c-d>"] = cmp.mapping.scroll_docs(4),
          ["<cr>"] = cmp.mapping.confirm(),
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
    requires = { "nvim-lua/plenary.nvim" },
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
    requires = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = "all",
        highlight = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "n",
            node_decremental = "p",
          },
        },
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = { ["<leader>a"] = "@parameter.inner" },
            swap_previous = { ["<leader>A"] = "@parameter.inner" },
          },
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

      lspconfig.jsonls.setup {}

      lspconfig.yamlls.setup {}

      lspconfig.pylsp.setup {}

      lspconfig.hls.setup {}

      lspconfig.rust_analyzer.setup {}
    end
  }
end)
