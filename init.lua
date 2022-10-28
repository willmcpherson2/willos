-- options

vim.o.clipboard = "unnamed"
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

-- maps

local function map(mode, key, cmd)
  vim.api.nvim_set_keymap(mode, key, cmd, {
    noremap = true,
    silent = true,
  })
end

map("", "<space>", "<nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

map("n", "<bs>", "<c-^>")
map("n", "Q", "<nop>")

map("n", "<leader>w", "<cmd>wa<cr>")
map("n", "<leader>n", "<cmd>noh<cr><c-l>")
map("n", "<leader>R", ":%s/\\<<c-r><c-w>\\>/<c-r><c-w>/g<c-f>$F/i")
map("n", "<leader>-", "80a-<esc>0")

map("n", "<leader>l", "<cmd>lua start_lsp()<cr>:e<cr>")
map("n", "<leader>i", "<cmd>lua vim.lsp.buf.hover()<cr>")
map("n", "<leader>d", "<cmd>lua vim.lsp.buf.definition()<cr>")
map("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<cr>")
map("n", "<leader>cr", "<cmd>lua vim.lsp.codelens.refresh()<cr>")
map("n", "<leader>cg", "<cmd>lua vim.lsp.codelens.run()<cr>")
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.format { async = true }<cr>")
map("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<cr>")
map("n", "<leader>ei", "<cmd>lua vim.diagnostic.open_float()<cr>")
map("n", "<leader>en", "<cmd>lua vim.diagnostic.goto_next()<cr>")
map("n", "<leader>ep", "<cmd>lua vim.diagnostic.goto_prev()<cr>")

map("n", "<leader>q", "<cmd>Fern . -drawer -reveal=% -width=30<cr>")

-- fern

function fern_init()
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<plug>(fern-my-open-expand-collapse)",
    "fern#smart#leaf('<plug>(fern-action-open)', '<plug>(fern-action-expand)', '<plug>(fern-action-collapse)')",
    { expr = true }
  )

  local function map(key, cmd)
    vim.api.nvim_buf_set_keymap(0, "n", key, cmd, {})
  end

  map("<cr>", "<plug>(fern-my-open-expand-collapse)")
  map("<2-leftmouse>", "<plug>(fern-my-open-expand-collapse)")
  map("n", "<plug>(fern-action-new-path)")
  map("d", "<plug>(fern-action-remove)")
  map("c", "<plug>(fern-action-copy)")
  map("m", "<plug>(fern-action-move)")
  map("r", "<plug>(fern-action-rename)")
  map("R", "<plug>(fern-action-reload)")
  map("M", "<plug>(fern-action-mark:toggle)")
  map("s", "<plug>(fern-action-open:split)")
  map("v", "<plug>(fern-action-open:vsplit)")
  map("h", "<plug>(fern-action-leave)")
  map("l", "<plug>(fern-action-enter)")
end

vim.api.nvim_set_var("fern#disable_default_mappings", 1)
vim.api.nvim_set_var("fern#default_hidden", 1)

vim.api.nvim_create_augroup("FernGroup", {})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "fern",
  group = "FernGroup",
  callback = fern_init
})

-- lsp

function start_lsp()
  local lspconfig = require("lspconfig")

  vim.diagnostic.config({
    signs = false,
    update_in_insert = true,
    severity_sort = true,
  })

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

  lspconfig.jdtls.setup {}

  lspconfig.clojure_lsp.setup {}

  lspconfig.tsserver.setup {}

  lspconfig.html.setup {}

  lspconfig.cssls.setup {}

  lspconfig.ansiblels.setup {
    filetypes = { "yaml" }
  }

  lspconfig.racket_langserver.setup {}

  lspconfig.rnix.setup {}
end
