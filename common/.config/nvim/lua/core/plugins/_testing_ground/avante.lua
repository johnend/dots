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
        debounce = 1000, -- wait 1 s after you stop typing
        throttle = 1500, -- no more than ~40 calls per minute
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
          max_files = 3, -- Limit number of files in context
          max_lines = 100, -- Limit lines per file in context
          include_buffers = false,
          include_cursor_position = false,
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

    -- Create custom commands for common coding tasks to save tokens
    vim.api.nvim_create_user_command("AvanteExplain", function()
      -- Create a predefined prompt for code explanation
      require("avante.api").ask("Explain this code concisely:", {
        include_selection = true,
      })
    end, { desc = "Explain selected code concisely" })

    vim.api.nvim_create_user_command("AvanteRefactor", function()
      -- Create a predefined prompt for code refactoring
      require("avante.api").ask("Refactor this code to improve it (be concise, focus on changes):", {
        include_selection = true,
      })
    end, { desc = "Refactor selected code efficiently" })

    vim.api.nvim_create_user_command("AvanteDebug", function()
      -- Create a predefined prompt for debugging
      require("avante.api").ask("Debug this code and suggest fixes (be concise):", {
        include_selection = true,
      })
    end, { desc = "Debug selected code efficiently" })
  end,
}
