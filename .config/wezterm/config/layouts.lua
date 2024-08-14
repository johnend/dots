local wezterm = require "wezterm"

-- Mac repos (work)
local fe_repo = "/Users/john.enderby/Developer/fdweb/contentx-marketing-frontend/"
local be_repo = "/Users/john.enderby/Developer/fdweb/contentx-sanity-studio-marketing/"
local gql_repo = "/Users/john.enderby/Developer/fdweb/contentx-gql-marketing/"
local nvim_dir = "/Users/john.enderby/Developer/personal/dots/.config/nvim/"
local notes_dir = "/Users/john.enderby/Developer/personal/notes/"

-- Linux repos (personal)
local dotfiles = "/home/johne/.dotfiles/"
local projects = "/home/johne/Developer/"
local lnvim = "/home/johne/.dotfiles/.config/nvim/"
local lwezterm = "/home/johne/.dotfiles/.config/wezterm/"
local lnotes = "/home/johne/Documents/notes/"

local function work_layout()
  local mux = wezterm.mux

  -- Tab 1 (Front End)
  local tab1, pane1, window1 = mux.spawn_window { cwd = fe_repo }
  local pane2 = pane1:split { direction = "Bottom", size = 0.1 }
  local pane3 = pane2:split { direction = "Right" }
  pane1:send_text "nvim\n"
  tab1:set_title "Frontend"

  -- Tab 2 (Sanity)
  local tab2, pane4, window2 = window1:spawn_tab { cwd = be_repo }
  local pane5 = pane4:split { direction = "Bottom", size = 0.1 }
  local pane6 = pane5:split { direction = "Right" }
  pane4:send_text "nvim\n"
  tab2:set_title "Sanity"

  -- Tab 3 (Gql)
  local tab3, pane7, window3 = window1:spawn_tab { cwd = gql_repo }
  local pane8 = pane7:split { direction = "Right" }
  pane7:send_text ""
  tab3:set_title "Gql"

  -- Tab 4 (NeoVim)
  local tab4, pane8, window4 = window1:spawn_tab { cwd = nvim_dir }
  tab4:set_title "NeoVim"

  -- Tab 5 (Notes)
  local tab5, pane9, window5 = window1:spawn_tab { cwd = notes_dir }
  tab5:set_title "Notes"
end

local function personal_layout()
  local mux = wezterm.mux

  -- Tab 1 (Projects)
  local tab1, pane1, window1 = mux.spawn_window { cwd = projects }
  local pane2 = pane1:split { direction = "Bottom", size = 0.1 }
  local pane3 = pane2:split { direction = "Right" }
  pane1:send_text "nvim\n"
  tab1:set_title "Projects"

  -- Tab 2 (Dotfiles)
  local tab2, pane4, window2 = window1:spawn_tab { cwd = dotfiles }
  local pane5 = pane4:split { direction = "Bottom", size = 0.1 }
  local pane6 = pane5:split { direction = "Right" }
  pane4:send_text "nvim\n"
  tab2:set_title "Dotfiles"

  -- Tab 3 (Neovim)
  local tab3, pane7, window3 = window1:spawn_tab { cwd = lnvim }
  local pane8 = pane7:split { direction = "Right" }
  pane7:send_text ""
  tab3:set_title "NeoVim"

  -- Tab 4 (Wezterm)
  local tab4, pane8, window4 = window1:spawn_tab { cwd = lwezterm }
  tab4:set_title "Wezterm"

  -- Tab 5 (Notes)
  local tab5, pane9, window5 = window1:spawn_tab { cwd = lnotes }
  tab5:set_title "Notes"
end

return {
  work_layout = work_layout,
  personal_layout = personal_layout,
}
