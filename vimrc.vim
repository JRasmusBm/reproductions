if has('vim_starting')
  set encoding=utf-8
endif
scriptencoding utf-8

if &compatible
  set nocompatible
endif

let s:plug_dir = expand('/tmp/plugged/vim-plug')
if !filereadable(s:plug_dir .. '/plug.vim')
  execute printf('!curl -fLo %s/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim', s:plug_dir)
end

execute 'set runtimepath+=' . s:plug_dir
call plug#begin(s:plug_dir)
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/vim-vsnip'
Plug 'neovim/nvim-lspconfig'
call plug#end()
PlugInstall | quit

" Setup global configuration. More on configuration below.
lua << EOF
local cmp = require "cmp"
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },

  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), {"i", "c"}),
  },

  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
  },
}
EOF

lua << EOF
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lua_language_server = vim.fn.stdpath("cache") .. "/../lua-language-server"

local function get_lua_runtime()
  local result = {};
  for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
    local lua_path = path .. "/lua/";
    if vim.fn.isdirectory(lua_path) then result[lua_path] = true end
  end

  result[vim.fn.expand("$VIMRUNTIME/lua")] = true

  return result;
end

require("lspconfig").sumneko_lua.setup {
  capabilities = capabilities,
  cmd = {
    lua_language_server .. "/bin/Linux/lua-language-server",
    "-E",
    lua_language_server .. "/main.lua",
  },
  settings = {
    Lua = {
      runtime = {version = "LuaJIT", path = runtime_path},
      diagnostics = {globals = {"vim"}},
      workspace = {
        library = get_lua_runtime(),
        maxPreload = 10000,
        preloadFileSize = 10000,
      },
      telemetry = {enable = false},
    },
  },
}
EOF
