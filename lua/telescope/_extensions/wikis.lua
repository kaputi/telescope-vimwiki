-- local scandir = require('plenary.scandir')
local telescope = require('telescope')
-- local actions = require('telescope.actions')
-- local state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local themes = require('telescope.themes')
-- local utils = require('session_manager.utils')
-- local config = require('session_manager.config')
local Path = require('plenary.path')

-- vim.cmd([[ command! WikiShow lua require('wiki-telescope').get_wikis()]])

-- local M = {}
-- function M.get_wikis()
-- local function get_wikis()
--   local wikis = {}

--   for _, wiki_options in ipairs(vim.g.vimwiki_list) do
--     local wiki_filename = wiki_options.path .. '/index' --TODO: add extension if avaiable else default
--     -- local wiki_name = wiki_options.path
--     table.insert(wikis, {
--       timestamp = vim.fn.getftime(wiki_filename),
--       -- filename = wiki_filename .. '/index.',
--       -- wikiName = wiki_filename, -- TODO: remove path
--       -- dir = dir,
--     })
--   end
-- end

local function get_wikis()
  -- function M.get_wikis()
  local wikis = {}

  -- print(vim.inspect(vim.g.vimwiki_list))
  for _, wiki_options in ipairs(vim.g.vimwiki_list) do
    local wiki_index = wiki_options.path .. '/index.wiki' --TODO: add extension if avaiable else default
    local exists = Path:new(wiki_index):exists()

    if exists then
      table.insert(wikis, {
        -- timestamp = vim.fn.getftime(wiki_index),
        index = wiki_index,
        name = wiki_options.name, -- TODO: get directory name
        dir = wiki_options.path,
      })
    end
  end
  -- table.sort(wikis, function(a, b)
  --   return a.timestamp > b.timestamp
  -- end)

  -- print(vim.inspect(wikis))
  return wikis
end

--       {
--         timestamp = vim.fn.getftime(session_filename),
--         filename = session_filename,
--         dir = dir,
--       }

local function select_wiki(opts)
  -- Use dropdown theme by default
  opts = themes.get_dropdown(opts)

  pickers.new(opts, {
    prompt_title = '-- Vimwiki --',
    initial_mode = 'normal',
    finder = finders.new_table({
      results = get_wikis(),
      entry_maker = function(entry)
        return {
          value = entry.index,
          display = entry.name,
          ordinal = entry.name,
        }
      end,
    }),
    sorter = sorters.get_fzy_sorter(),
  }):find()
end

return telescope.register_extension({
  exports = {
    wikis = select_wiki,
  },
})
