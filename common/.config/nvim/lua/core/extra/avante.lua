return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  build = "make",

  dependencies = {
    "stevearc/dressing.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = { insert_mode = true },
        },
      },
    },
  },

  config = function()
    local status_ok, avante = pcall(require, "avante")
    if not status_ok then
      return
    end

    avante.setup {
      -- General settings
      suggestion = {
        debounce = 2000, -- wait 1 s after you stop typing
        throttle = 1500, -- no more than ~40 calls per minute
      },
      sidebar = {
        show_input_hint = false,
      },
      log_level = "info", -- "debug", "info", "warn", "error"

      -- Customize your model settings
      models = {

        -- Anthropic Claude settings
        ["anthropic/claude-3-opus-20240229"] = {
          workshop_id = "opus_avante", -- your saved prompt
          temperature = 0.3,
          max_tokens = 4000,
          top_p = 0.95,
          top_k = 50,
          context_window = 8000,
          trim_strategy = "token_count",
          trim_token_limit = 6000,
        },

        -- You can add configurations for other models here
        ["anthropic/claude-3-7-sonnet-20250219"] = {
          workshop_id = "sonnet_avante",
          temperature = 0.5,
          max_tokens = 3000,
          top_p = 0.95,
          top_k = 50,
          context_window = 6000,
          trim_strategy = "token_count",
          trim_token_limit = 4000,
        },

        -- Use GPT-4
        ["openai/gpt-4"] = {
          temperature = 0.3,
          max_tokens = 1000,
          top_p = 0.9,
          top_k = 40,
          context_window = 8000,
          trim_strategy = "token_count",
          trim_token_limit = 6000,
        },

        -- Fallback to GPT-3.5-turbo if you hit GPT-4 rate limits
        ["openai/gpt-3.5-turbo"] = {
          temperature = 0.3,
          max_tokens = 800,
          top_p = 0.9,
          trim_strategy = "token_count",
          trim_token_limit = 4000,
        },
      },

      -- UI customization for better experience
      ui = {
        popup = {
          border = "rounded",
          width = 80,
          height = 20,
          highlight = "Normal",
        },
        input = {
          border = "rounded",
          width = 60,
          height = 10,
          prompt = "💬 ",
        },
        code_action = {
          border = "rounded",
        },
      },

      -- Optimize keymaps for efficient workflow
      keymaps = {
        toggle = "<leader>ai", -- Toggle the chat interface
        submit = "<C-s>", -- Submit the prompt
        close = "q", -- Close the chat interface
        new_chat = "<C-n>", -- Start a new chat
        context = {
          add = "<leader>ac", -- Add context
          clear = "<leader>ax", -- Clear context
        },
      },

      -- Customize behavior for token efficiency
      behavior = {
        -- Save chat history to reduce token usage for repeated questions
        save_chat_history = true,
        chat_history_path = vim.fn.stdpath "data" .. "/avante/chat_history",

        -- Enable streaming to see responses as they come
        streaming = true,

        -- Context management to optimize token usage
        auto_context = {
          enabled = true,
          max_files = 2, -- Reduced from 3 to save tokens
          max_lines = 60, -- Reduced from 100 to save tokens
          include_buffers = false, -- Enable to get more relevant context
          include_cursor_position = false, -- Enable to focus responses on current code
        },

        -- Optimize code actions for efficiency
        code_actions = {
          auto_preview = true,
          preview_timeout_ms = 1000,
        },
      },

      -- Telemetry settings
      telemetry = {
        enabled = false, -- Disable telemetry to save tokens
      },
    }

    -- Create custom commands for common coding tasks to save tokens with visual mode support
    vim.api.nvim_create_user_command("AvanteExplain", function(opts)
      local prompt = "Explain this code concisely:"

      -- Handle range selection for visual mode
      if opts.range > 0 then
        require("avante.api").ask {
          prompt = prompt,
          range = { opts.line1, opts.line2 },
        }
      else
        require("avante.api").ask {
          prompt = prompt,
          include_selection = true,
        }
      end
    end, { desc = "Explain selected code concisely", range = true })

    vim.api.nvim_create_user_command("AvanteRefactor", function(opts)
      local prompt = "Refactor this code to improve it (be concise, focus on changes):"

      -- Handle range selection for visual mode
      if opts.range > 0 then
        require("avante.api").ask {
          prompt = prompt,
          range = { opts.line1, opts.line2 },
        }
      else
        require("avante.api").ask {
          prompt = prompt,
          include_selection = true,
        }
      end
    end, { desc = "Refactor selected code efficiently", range = true })

    vim.api.nvim_create_user_command("AvanteDebug", function(opts)
      local prompt = "Debug this code and suggest fixes (be concise):"

      -- Handle range selection for visual mode
      if opts.range > 0 then
        require("avante.api").ask {
          prompt = prompt,
          range = { opts.line1, opts.line2 },
        }
      else
        require("avante.api").ask {
          prompt = prompt,
          include_selection = true,
        }
      end
    end, { desc = "Debug selected code efficiently", range = true })

    -- Add keymaps for easier access to custom commands
    vim.keymap.set("n", "<leader>ae", ":AvanteExplain<CR>", { desc = "Explain code with Avante" })
    vim.keymap.set("v", "<leader>ae", ":AvanteExplain<CR>", { desc = "Explain selected code with Avante" })
    vim.keymap.set("n", "<leader>ar", ":AvanteRefactor<CR>", { desc = "Refactor code with Avante" })
    vim.keymap.set("v", "<leader>ar", ":AvanteRefactor<CR>", { desc = "Refactor selected code with Avante" })
    vim.keymap.set("n", "<leader>ad", ":AvanteDebug<CR>", { desc = "Debug code with Avante" })
    vim.keymap.set("v", "<leader>ad", ":AvanteDebug<CR>", { desc = "Debug selected code with Avante" })
  end,
}
