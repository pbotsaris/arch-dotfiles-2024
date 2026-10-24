local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
   return
end

local helpers = require("null-ls.helpers")

-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md#formatting
local formatting = null_ls.builtins.formatting

-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md#diagnostics
local diagnostics = null_ls.builtins.diagnostics

-- current not using completion but this is basically snippets
-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md#completion
-- local completion = null_ls.builtins.completion

-- credo only runs in projects that depend on it, otherwise mix errors with `task "credo" could not be found`
local has_credo = function(params)
   local lock = vim.fs.find("mix.lock", { path = vim.fs.dirname(params.bufname), upward = true })[1]
   if not lock then
      return false
   end

   return vim.iter(vim.fn.readfile(lock)):any(function(line)
      return line:find('"credo"', 1, true) ~= nil
   end)
end

-- elixir formatting comes from the active elixir lsp (expert/dexter), ruby from the rubocop lsp
local sources = {
   -- formating
   formatting.prettier.with({
      extra_args = {
         "--no-semi",
         "--single-quote",
         "--jsx-single-quote",
         "--print-width",
         "120",
      },
   }),
   formatting.black.with({ extra_args = { "--fast" } }),
   -- formatting.isort,
   formatting.clang_format,
   formatting.stylua,
   formatting.erb_format,
   --require("none-ls.diagnostics.eslint"), -- this requires none-ls-extras to be installed

   -- diagnostics

--   diagnostics.pylint.with({
--      diagnostics_postprocess = function(diagnostic)
--         diagnostic.code = diagnostic.message_id
--      end,
--   }),

   diagnostics.yamllint,
   diagnostics.erb_lint,
   diagnostics.dotenv_linter,
   -- elixir
   diagnostics.credo.with({
      method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
      runtime_condition = helpers.cache.by_bufnr(has_credo),
   }),
}

null_ls.setup({
   debug = false,
   sources = sources,
})
