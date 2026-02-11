-- config/codecompanion/slash_commands.lua
-- Slash command definitions for CodeCompanion chat

local hooks = require "config.codecompanion.hooks"

return {
  -- Built-in commands
  ["buffer"] = {
    callback = "strategies.chat.slash_commands.buffer",
    description = "Insert open buffers",
    opts = {
      contains_code = true,
      provider = "telescope",
    },
  },

  ["file"] = {
    callback = "strategies.chat.slash_commands.file",
    description = "Insert a file",
    opts = {
      contains_code = true,
      max_lines = 1000,
      provider = "telescope",
    },
  },

  ["symbols"] = {
    callback = "strategies.chat.slash_commands.symbols",
    description = "Insert symbols from active buffer",
    opts = {
      contains_code = true,
    },
  },

  -- Custom: GloomStalker context loading
  ["gloom"] = {
    callback = function(context)
      local task = context.args or vim.fn.input "Task description: "
      if task == "" then
        return "Cancelled: No task provided"
      end
      return hooks.run_gloomstalker(task)
    end,
    description = "Load GloomStalker context for task",
    opts = {
      contains_code = false,
    },
  },

  -- Custom: Chronicle (document to Obsidian)
  ["chronicle"] = {
    callback = function(context)
      local topic = context.args or vim.fn.input "What to document: "
      if topic == "" then
        return "Cancelled: No topic provided"
      end
      local cwd = vim.fn.getcwd()
      return hooks.run_chronicle(topic, cwd)
    end,
    description = "Document to Obsidian vault",
    opts = {
      contains_code = false,
    },
  },

  -- Custom: Git status check
  ["gitstatus"] = {
    callback = function()
      return hooks.run_git_status_checker()
    end,
    description = "Show enhanced git status with context",
    opts = {
      contains_code = false,
    },
  },

  -- Custom: Risk assessment
  ["risk"] = {
    callback = function(context)
      local operation = context.args or vim.fn.input "Operation to assess: "
      if operation == "" then
        return "Cancelled: No operation provided"
      end
      return hooks.run_risk_assessor(operation)
    end,
    description = "Assess risk level of operation",
    opts = {
      contains_code = false,
    },
  },

  -- Custom: Todo enforcement check
  ["todo"] = {
    callback = function(context)
      local task = context.args or vim.fn.input "Task description: "
      if task == "" then
        return "Cancelled: No task provided"
      end
      return hooks.run_todo_enforcer(task)
    end,
    description = "Check if task needs todos (multi-step detection)",
    opts = {
      contains_code = false,
    },
  },

  -- Custom: Reference another chat's context
  ["reference"] = {
    callback = function(context)
      -- Find all CodeCompanion buffers
      local codecompanion_bufs = {}
      local current_buf = vim.api.nvim_get_current_buf()
      
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and buf ~= current_buf then
          local buftype = vim.bo[buf].filetype
          local bufname = vim.api.nvim_buf_get_name(buf)
          
          -- Check if it's a CodeCompanion buffer
          if buftype == "codecompanion" or bufname:match("codecompanion") then
            local lines = vim.api.nvim_buf_get_lines(buf, 0, 5, false)
            local preview = #lines > 0 and lines[1]:sub(1, 60) or "Empty chat"
            
            table.insert(codecompanion_bufs, {
              buf = buf,
              name = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "Chat " .. buf,
              preview = preview,
            })
          end
        end
      end

      if #codecompanion_bufs == 0 then
        return "No other CodeCompanion chats found"
      end

      -- Use telescope to pick chat
      local telescope_ok, telescope_builtin = pcall(require, "telescope.builtin")
      if telescope_ok then
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local conf = require("telescope.config").values

        pickers.new({}, {
          prompt_title = "Reference Chat",
          finder = finders.new_table {
            results = codecompanion_bufs,
            entry_maker = function(entry)
              return {
                value = entry,
                display = entry.name .. " - " .. entry.preview,
                ordinal = entry.name,
              }
            end,
          },
          sorter = conf.generic_sorter({}),
          attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)

              -- Ask for scope
              vim.schedule(function()
                local scope = vim.fn.input("Scope (s=Summary, 5=Last 5, 10=Last 10, f=Full): ")
                
                local selected_buf = selection.value.buf
                local all_lines = vim.api.nvim_buf_get_lines(selected_buf, 0, -1, false)
                local content_lines = {}

                if scope == "s" or scope == "summary" or scope == "" then
                  -- Summary: First 20 lines
                  content_lines = vim.list_slice(all_lines, 1, math.min(20, #all_lines))
                elseif scope == "5" then
                  -- Last 5 messages (approx 50 lines)
                  local start_line = math.max(1, #all_lines - 50)
                  content_lines = vim.list_slice(all_lines, start_line, #all_lines)
                elseif scope == "10" then
                  -- Last 10 messages (approx 100 lines)
                  local start_line = math.max(1, #all_lines - 100)
                  content_lines = vim.list_slice(all_lines, start_line, #all_lines)
                else -- "f" or anything else = full
                  content_lines = all_lines
                end

                -- Format output
                local result = "## Referenced from: " .. selection.value.name .. "\n\n"
                result = result .. "```\n" .. table.concat(content_lines, "\n") .. "\n```\n"

                -- Insert at cursor in current buffer
                local cursor = vim.api.nvim_win_get_cursor(0)
                local line = cursor[1]
                vim.api.nvim_buf_set_lines(current_buf, line, line, false, vim.split(result, "\n"))
              end)
            end)
            return true
          end,
        }):find()
        
        return "" -- Picker handles insertion async
      else
        -- Fallback: Simple selection if telescope not available
        local choices = {}
        for i, chat in ipairs(codecompanion_bufs) do
          table.insert(choices, i .. ". " .. chat.name)
        end
        
        local choice_str = table.concat(choices, "\n")
        local idx = tonumber(vim.fn.input("Select chat:\n" .. choice_str .. "\nChoice: "))
        
        if idx and codecompanion_bufs[idx] then
          local selected = codecompanion_bufs[idx]
          local all_lines = vim.api.nvim_buf_get_lines(selected.buf, 0, -1, false)
          local summary_lines = vim.list_slice(all_lines, 1, math.min(20, #all_lines))
          
          return "## Referenced from: " .. selected.name .. "\n\n```\n" .. table.concat(summary_lines, "\n") .. "\n```"
        else
          return "Cancelled"
        end
      end
    end,
    description = "Pull context from another chat (with telescope picker)",
    opts = {
      contains_code = true,
      provider = "telescope",
    },
  },
}
