-- adopted from https://github.com/AdamWhittingham/vim-config/blob/nvim/lua/config/startup_screen.lua
local utils = require("utils.functions")
local conf = vim.g.config.plugins.alpha
local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  return
end

local path_ok, path = pcall(require, "plenary.path")
if not path_ok then
  return
end

-- when there is no buffer left show Alpha dashboard
-- requires "famiu/bufdelete.nvim" for the pattern
vim.api.nvim_create_augroup("alpha_on_empty", { clear = true })
vim.api.nvim_create_autocmd("User", {
  pattern = "BDeletePre *",
  group = "alpha_on_empty",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local name = vim.api.nvim_buf_get_name(bufnr)

    if name == "" then
      vim.cmd([[:Alpha | bd#]])
    end
  end,
})

local dashboard = require("alpha.themes.dashboard")
local nvim_web_devicons = require("nvim-web-devicons")
local cdir = vim.fn.getcwd()

local function get_extension(fn)
  local match = fn:match("^.+(%..+)$")
  local ext = ""
  if match ~= nil then
    ext = match:sub(2)
  end
  return ext
end

local function icon(fn)
  local nwd = require("nvim-web-devicons")
  local ext = get_extension(fn)
  return nwd.get_icon(fn, ext, { default = true })
end

local function file_button(fn, sc, short_fn)
  short_fn = short_fn or fn
  local ico_txt
  local fb_hl = {}

  local ico, hl = icon(fn)
  local hl_option_type = type(nvim_web_devicons.highlight)
  if hl_option_type == "boolean" then
    if hl and nvim_web_devicons.highlight then
      table.insert(fb_hl, { hl, 0, 1 })
    end
  end
  if hl_option_type == "string" then
    table.insert(fb_hl, { nvim_web_devicons.highlight, 0, 1 })
  end
  ico_txt = ico .. "  "

  local file_button_el = dashboard.button(sc, ico_txt .. short_fn, "<cmd>e " .. fn .. " <CR>")
  local fn_start = short_fn:match(".*/")
  if fn_start ~= nil then
    table.insert(fb_hl, { "Comment", #ico_txt - 2, #fn_start + #ico_txt - 2 })
  end
  file_button_el.opts.hl = fb_hl
  return file_button_el
end

--- @param start number
--- @param cwd string optional
--- @param items_number number optional number of items to generate, default = 10
local function get_recent_files(start, cwd, items_number)
  items_number = items_number or 9

  local recent_files = {}
  local ok, _ = pcall(require, "mini.visits")

  if not ok then
    for _, v in pairs(vim.v.oldfiles) do
      if #recent_files == items_number then
        break
      end
      local cwd_cond
      if not cwd then
        cwd_cond = true
      else
        cwd_cond = vim.startswith(v, cwd)
      end
      if (vim.fn.filereadable(v) == 1) and cwd_cond then
        recent_files[#recent_files + 1] = v
      end
    end
  else
    -- TODO better approach via config table?
    local exclude = function(path_data)
      return vim.fn.matchstr(path_data.path, "local/share/nvim") == ""
        and vim.fn.matchstr(path_data.path, "cache/nvim") == ""
        and vim.fn.matchstr(path_data.path, "COMMIT_EDITMSG") == ""
    end
    local sort_recent = require("mini.visits").gen_sort.default({ recency_weight = 1 })
    recent_files = require("mini.visits").list_paths(nil, { filter = exclude, sort = sort_recent })
  end

  local special_shortcuts = { "a", "s", "d" }
  local target_width = 35

  local tbl = {}
  for i, fn in ipairs(recent_files) do
    if i == items_number then
      break
    end
    local short_fn
    if cwd then
      short_fn = vim.fn.fnamemodify(fn, ":.")
    else
      short_fn = vim.fn.fnamemodify(fn, ":~")
    end

    if #short_fn > target_width then
      short_fn = path.new(short_fn):shorten(1, { -2, -1 })
      if #short_fn > target_width then
        short_fn = path.new(short_fn):shorten(1, { -1 })
      end
    end

    local shortcut = ""
    if i <= #special_shortcuts then
      shortcut = special_shortcuts[i]
    else
      shortcut = tostring(i + start - 1 - #special_shortcuts)
    end

    local file_button_el = file_button(fn, " " .. shortcut, short_fn)
    tbl[i] = file_button_el
  end
  return {
    type = "group",
    val = tbl,
    opts = {},
  }
end

local section_mru = {
  type = "group",
  val = {
    {
      type = "text",
      val = "Recent files",
      opts = {
        hl = "SpecialComment",
        shrink_margin = false,
        position = "center",
      },
    },
    { type = "padding", val = 1 },
    {
      type = "group",
      val = function()
        return { get_recent_files(1, cdir, conf.dashboard_recent_files) }
      end,
      opts = { shrink_margin = false },
    },
  },
}

local buttons = {
  type = "group",
  val = {
    { type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
    dashboard.button("e", "  New File", "<cmd>ene <BAR> startinsert<cr>"),
    dashboard.button("f", "  Find File", ":" .. require("utils.functions").project_files() .. "<cr>"),
    dashboard.button("b", "  File Browser", require("utils.functions").file_browser()),
    dashboard.button("s", "  Search String", "<cmd>Telescope live_grep<cr>"),
    dashboard.button("r", "  Recent Files", "<cmd>Telescope oldfiles<cr>"),
    dashboard.button("g", "  NeoGit", "<cmd>Neogit<cr>"),
    dashboard.button("l", "  Lazy", "<cmd>Lazy check<cr>"),
    dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
  },
  position = "center",
}

---set a specific or a random header
local function get_header()
  if utils.safe_nested_config(conf, "header") then
    local headers = require("core.plugins.alpha.headers")
    if utils.get_nested_value(headers, conf.header) then
      return utils.get_nested_value(headers, conf.header)
    end
  end
  -- From https://gist.github.com/sRavioli/d6fb0a813b6affc171976b7dd09764d3
  return require("core.plugins.alpha.headers")["random"]
end

local header = {
  type = "text",
  val = get_header(),
  opts = {
    position = "center",
    hl = "AlphaHeader",
  },
}

local layout = {}
layout[0] = header
layout[1] = { type = "padding", val = 2 }
layout[2] = section_mru
layout[3] = { type = "padding", val = 2 }
layout[4] = buttons

if conf.dashboard_recent_files == 0 then
  layout[1] = nil
  layout[2] = nil
end

if conf.disable_dashboard_header == true then
  layout[0] = nil
end

if conf.disable_dashboard_quick_links == true then
  layout[3] = nil
  layout[4] = nil
end

local opts = {
  layout = layout,
  opts = {
    margin = 5,
  },
}

alpha.setup(opts)
