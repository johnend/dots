local wezterm = require "wezterm"

local fe_repo = "/Users/john.enderby/Developer/fdweb/contentx-marketing-frontend/"
local be_repo = "/Users/john.enderby/Developer/fdweb/contentx-sanity-studio-marketing/"
local gql_repo = "/Users/john.enderby/Developer/fdweb/contentx-gql-marketing/"

local function setup_layout()
  local mux = wezterm.mux

  print "Setting up custom layout"

  print("Frontend repo: " .. fe_repo)
  print("Sanity repo: " .. be_repo)
  print("Gql repo: " .. gql_repo)

  -- Tab 1 (Front End)
  local tab1, pane1, window1 = mux.spawn_window { cwd = fe_repo }
  local pane2 = pane1:split { direction = "Bottom", size = 0.15 }
  local pane3 = pane2:split { direction = "Right" }
  pane1:send_text "nvim\n"
  tab1:set_title "Frontend"

  -- Tab 2 (Sanity)
  local tab2, pane4, window2 = window1:spawn_tab { cwd = be_repo }
  local pane5 = pane4:split { direction = "Bottom", size = 0.15 }
  local pane6 = pane5:split { direction = "Right" }
  pane4:send_text "nvim\n"
  tab2:set_title "Sanity"

  -- Tab 3 (Gql)
  local tab3, pane7, window3 = window1:spawn_tab { cwd = gql_repo }
  local pane8 = pane7:split { direction = "Right" }
  pane7:send_text ""
  tab3:set_title "Gql"
end

return {
  setup_layout = setup_layout,
}
