---[[---------------------------------------]]---
--      init.lua - Init file of Doom Nvim      --
--             Author: NTBBloodbath            --
--             License: GPLv2                  --
---[[---------------------------------------]]---

---- Doom Utilities -----------------------------
-------------------------------------------------
-- Store startup time in seconds
vim.g.start_time = vim.fn.reltime()
-- Lua modules loader, when loading our modules with this
-- we avoid breaking all the configuration if something fails
local load_modules = require("doom.utils.modules").load_modules

-- Disable some unused built-in Neovim plugins
vim.g.loaded_gzip = false
vim.g.loaded_tarPlugin = false
vim.g.loaded_zipPlugin = false
vim.g.loaded_2html_plugin = false
vim.g.neovide_cursor_vfx_mode = "pixiedust"
vim.g.neovide_cursor_vfx_particle_lifetime = 5
vim.g.neovide_cursor_vfx_particle_density = 10.0

---- Catppuccin ----
vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha

require("catppuccin").setup()

vim.cmd [[colorscheme catppuccin]]
--------------------

---- Persence ----
require("presence"):setup({
  -- General options
  auto_update         = true,                       -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
  neovim_image_text   = "The One True Chad Text Editor", -- Text displayed when hovered over the Neovim image
  main_image          = "file",                   -- Main image display (either "neovim" or "file")
  client_id           = "793271441293967371",       -- Use your own Discord application client id (not recommended)
  log_level           = nil,                        -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
  debounce_timeout    = 10,                         -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
  enable_line_number  = false,                      -- Displays the current line number instead of the current project
  blacklist           = {},                         -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
  buttons             = true,                       -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
  file_assets         = {},                         -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)

    -- Rich Presence text options
  editing_text        = "Editing %s",               -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
  file_explorer_text  = "Browsing %s",              -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
  git_commit_text     = "Committing changes",       -- Format string rendered when committing changes in git (either string or function(filename: string): string)
  plugin_manager_text = "Managing plugins",         -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
  reading_text        = "Reading %s",               -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
  workspace_text      = "Working on %s",            -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
  line_number_text    = "Line %s out of %s",        -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
})
------------------

---- Doom Configurations ------------------------
-------------------------------------------------
-- Load Doom core and UI related stuff (colorscheme, background)
load_modules("doom", { "core" })

-- Defer and schedule loading of plugins and extra functionalities until the
-- Neovim API functions are safe to call to avoid weird errors with plugins stuff
vim.defer_fn(function()
  -- Load Doom extra stuff and plugins (modules, extras)
  load_modules("doom", { "modules", "extras" })

  -- This loads certain plugins related to UI
  vim.cmd("doautocmd ColorScheme")

  -- If the current buffer name is empty then trigger Dashboard.
  -- NOTE: this is done to avoid some weird issues with Dashboard and
  --       number / signcolumn when Dashboard gets triggered automatically
  if
    (packer_plugins and packer_plugins["dashboard-nvim"])
    and (vim.api.nvim_buf_get_number(0) > 1 or vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]:len() == 0)
    and vim.api.nvim_buf_get_name(0):len() == 0 -- Empty buffer name
  then
    vim.cmd("Dashboard")
  end

  vim.cmd([[
    PackerLoad nvim-treesitter
    " This BufEnter call should fix some issues with concealing in neorg
    doautocmd BufEnter
  ]])

  if not require("doom.utils").is_plugin_disabled("which-key") then
    vim.cmd([[
      PackerLoad which-key.nvim
    ]])
  end
end, 0)

vim.cmd [[setglobal guifont=Fira\ Code:h13]]
