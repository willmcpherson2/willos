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
vim.o.number = true
vim.o.relativenumber = true

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

Map("n", "<bs>", "<c-^>")
Map("n", "Q", "<nop>")

Map("n", "<leader>w", vim.cmd.wa)
Map("n", "<leader>q", vim.cmd.qa)

Map("n", "<leader>c", vim.cmd.bd)
Map("n", "<s-h>", vim.cmd.bp)
Map("n", "<s-l>", vim.cmd.bn)

Map("n", "<c-h>", "<c-w>h")
Map("n", "<c-j>", "<c-w>j")
Map("n", "<c-k>", "<c-w>k")
Map("n", "<c-l>", "<c-w>l")

Map("n", "<leader>n", vim.cmd.noh)
Map("n", "<leader>R", ":%s/\\<<c-r><c-w>\\>/<c-r><c-w>/g<c-f>$F/i")
Map("n", "<leader>-", "80a-<esc>0")

-- plugins

require("packer").startup(function(use)
  use "wbthomason/packer.nvim"

  use {
    "olimorris/onedarkpro.nvim",
    config = function()
      vim.cmd.colorscheme("onedarkpro")
    end
  }

  use {
    "f-person/auto-dark-mode.nvim",
    config = function()
      local auto_dark_mode = require("auto-dark-mode")
      auto_dark_mode.setup {}
      auto_dark_mode.init()
    end
  }

  use {
    "noib3/nvim-cokeline",
    config = function()
      require("cokeline").setup {
        show_if_buffers_are_at_least = 2
      }
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
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-buffer"
  use {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      cmp.setup {
        sources = {
          { name = "nvim_lsp" },
          { name = "treesitter" },
          { name = "path" },
          { name = "buffer" },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<c-space>"] = cmp.mapping.complete(),
          ["<cr>"] = cmp.mapping.confirm({ select = true }),
          ["<c-e>"] = cmp.mapping.abort(),
          ["<c-u>"] = cmp.mapping.scroll_docs(-4),
          ["<c-d>"] = cmp.mapping.scroll_docs(4),
        }),
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
      Map("n", "<leader>gi", function() gs.blame_line { full = true } end)
      Map("n", "<leader>gn", gs.next_hunk)
      Map("n", "<leader>gp", gs.prev_hunk)
    end
  }

  use {
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/plenary.nvim" } },
    config = function()
      local builtin = require("telescope.builtin")

      Map("n", "<leader>ff", builtin.find_files)
      Map("n", "<leader>b", builtin.buffers)
      Map("n", "<leader>f/", builtin.live_grep)
      Map("n", "<leader>f*", builtin.grep_string)
      Map("n", "<leader>fh", builtin.help_tags)

      Map("n", "<leader>gg", builtin.git_status)
      Map("n", "<leader>gb", builtin.git_branches)
      Map("n", "<leader>gc", builtin.git_commits)

      Map("n", "<leader>fs", builtin.lsp_dynamic_workspace_symbols)
      Map("n", "<leader>fd", builtin.diagnostics)
    end
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup {
        highlight = { enable = true },
        context_commentstring = { enable = true },
        ensure_installed = {
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
        },
      }
    end
  }

  use {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      Map("n", "<leader>i", vim.lsp.buf.hover)
      Map("n", "<leader>d", vim.lsp.buf.definition)
      Map("n", "<leader>a", vim.lsp.buf.code_action)
      Map("n", "<leader>f", function() vim.lsp.buf.format { async = true } end)
      Map("n", "<leader>r", vim.lsp.buf.rename)
      Map("n", "<leader>ei", vim.diagnostic.open_float)
      Map("n", "<leader>en", vim.diagnostic.goto_next)
      Map("n", "<leader>ep", vim.diagnostic.goto_prev)

      vim.diagnostic.config {
        signs = false,
        update_in_insert = true,
        severity_sort = true,
      }

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

      lspconfig.hls.setup {}

      lspconfig.rnix.setup {}

      lspconfig.rust_analyzer.setup {
        settings = {
          ["rust-analyzer"] = {
            rustfmt = {
              extraArgs = { "+stable", },
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

      lspconfig.pylsp.setup {}

      lspconfig.clojure_lsp.setup {}

      lspconfig.tsserver.setup {}

      lspconfig.html.setup {}

      lspconfig.cssls.setup {}
    end
  }
end)
