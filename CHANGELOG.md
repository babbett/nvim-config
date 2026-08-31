# Changelog

## 2026-07-12

### Cleanup
- Deleted 362 files from `lsp/` that were byte-identical copies of configs already shipped by `nvim-lspconfig` (which is on the runtimepath via `pack.add`, so they were dead weight). Kept only `lua_ls.lua` and `pylsp.lua`, the two with actual customizations.
- Removed a duplicated Love2D setup block in `init.lua` — `love2d.config.setup()` and the `<leader>vv`/`<leader>vs` keymaps were defined both inline and in `lua/plugins/love.lua`, running setup twice.
- Removed `<leader>v` (`oil.toggle_hidden`), which was a plain duplicate of `<leader>eh`. It also shared a prefix with `<leader>vv`/`<leader>vs`, causing an input-lag gotcha where Neovim would pause waiting to see if `v` was about to become `vv`.
- Wired up `opts.foldexpr = "v:lua.vim.treesitter.foldexpr()"`, which was commented out — `foldmethod = "expr"` was a no-op without it.

### Completion
- Replaced the native `vim.lsp.completion` autocmd with a real `nvim-cmp` setup (`nvim_lsp`, `nvim_lsp_signature_help`, `path`, `buffer` sources; native `vim.snippet` for expansion). The cmp plugins were already in `pack.add` but never configured.
- Added `vim.lsp.config('*', { capabilities = require("cmp_nvim_lsp").default_capabilities() })` so LSP servers advertise cmp-compatible completion capabilities.

### Language support
Added Treesitter parsers and LSP servers for C#, JS/TS, HTML, CSS, and GDScript:
- `vim.lsp.enable({ "lua_ls", "pylsp", "ts_ls", "html", "cssls", "omnisharp", "gdscript" })`
- Treesitter `ensure_installed` now also includes `c_sharp` and `gdscript`.
- GDScript connects over TCP to a running Godot editor (port 6005) — only works while Godot has the project open; that's expected, not a bug.

### Bug fix: OmniSharp never actually worked
OmniSharp determines its project root from its own process's cwd (it takes no root-path argument). Neovim does **not** set the LSP process's cwd to the resolved `root_dir` by default — it inherits whatever directory nvim itself was launched from. So OmniSharp was silently scanning the wrong directory, finding no project, and `hover`/`definition`/etc. would never register — `:LspInfo` would show it "attached" while doing nothing useful.

Fixed via an explicit `vim.lsp.config('omnisharp', { cmd = function(dispatchers, config) ... end })` in `init.lua` that spawns the process with `cwd = config.root_dir`.

Note: this couldn't be done as a `lsp/omnisharp.lua` file (the pattern used for `lua_ls`/`pylsp`) — `pack.add`-loaded plugins land *after* the user's own config in `runtimepath`, so `nvim-lspconfig`'s bundled `omnisharp.lua` would silently win the merge for the conflicting `cmd` key. Explicit `vim.lsp.config()` calls always take precedence over `lsp/*.lua` files regardless of runtimepath order, so that's the reliable override point.

Verified end-to-end against a throwaway `.csproj`/`Program.cs`: OmniSharp attached, loaded the actual project (`"Successfully loaded project file 'Test.csproj'"`), and returned accurate semantic hover info (type inference, nullable-flow analysis).

### Known follow-ups (not yet done)
- `lsp/pylsp.lua` nests custom settings under `Python = {...}`, but `pylsp` reads settings under `pylsp = {...}` — the workspace-library setting is currently silently ignored.
- C# is on OmniSharp for now; there's a `TODO` in `init.lua` about migrating to `roslyn_ls` once it's worth the extra Mason setup.
