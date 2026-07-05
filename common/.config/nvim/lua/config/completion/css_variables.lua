local M = {}

M.filetypes = {
  "css",
  "scss",
  "sass",
  "less",
  "javascriptreact",
  "typescriptreact",
}

M.lookup_files = {
  "src/**/*.css",
  "src/**/*.scss",
  "src/**/*.sass",
  "app/**/*.css",
  "app/**/*.scss",
  "app/**/*.sass",
  "styles/**/*.css",
  "styles/**/*.scss",
  "styles/**/*.sass",
  "components/**/*.css",
  "components/**/*.scss",
  "components/**/*.sass",
  "src/**/*.module.css",
  "src/**/*.module.scss",
  "src/**/*.module.sass",
  "app/**/*.module.css",
  "app/**/*.module.scss",
  "app/**/*.module.sass",
  "components/**/*.module.css",
  "components/**/*.module.scss",
  "components/**/*.module.sass",
}

M.blacklist_folders = {
  "**/.cache",
  "**/.DS_Store",
  "**/.git",
  "**/.hg",
  "**/.next",
  "**/.nuxt",
  "**/.output",
  "**/.svn",
  "**/bower_components",
  "**/build",
  "**/coverage",
  "**/CVS",
  "**/dist",
  "**/node_modules",
  "**/out",
  "**/tmp",
}

local blacklist_names = {
  [".cache"] = true,
  [".git"] = true,
  [".hg"] = true,
  [".next"] = true,
  [".nuxt"] = true,
  [".output"] = true,
  [".svn"] = true,
  bower_components = true,
  build = true,
  coverage = true,
  CVS = true,
  dist = true,
  node_modules = true,
  out = true,
  tmp = true,
}

local function get_root()
  local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock", ".git" }
  return vim.fs.root(0, root_markers) or vim.fn.getcwd()
end

local function is_blacklisted(path)
  for part in path:gmatch "[^/]+" do
    if blacklist_names[part] then
      return true
    end
  end
  return false
end

local function find_files(root)
  local seen = {}
  local files = {}

  for _, pattern in ipairs(M.lookup_files) do
    for _, path in ipairs(vim.fn.globpath(root, pattern, false, true)) do
      if not seen[path] and not is_blacklisted(path) and vim.fn.getfsize(path) < 512 * 1024 then
        seen[path] = true
        table.insert(files, path)
      end
    end
  end

  return files
end

local cache = {}

local function trim(value)
  return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function compact(value)
  return trim(value):gsub("%s+", " ")
end

local function read_declarations(path)
  local content = table.concat(vim.fn.readfile(path), "\n")
  local declarations = {}

  for name, value in content:gmatch("(%-%-[%w_-]+)%s*:%s*(.-);") do
    table.insert(declarations, {
      name = name,
      value = trim(value),
    })
  end

  return declarations
end

local function read_variables(root)
  if cache[root] then
    return cache[root]
  end

  local seen = {}
  local variables = {}
  local values_by_name = {}

  for _, path in ipairs(find_files(root)) do
    for _, declaration in ipairs(read_declarations(path)) do
      if not seen[declaration.name] then
        seen[declaration.name] = true
        values_by_name[declaration.name] = declaration.value
        table.insert(variables, {
          label = declaration.name,
          detail = declaration.value,
          documentation = path:gsub("^" .. vim.pesc(root .. "/"), ""),
        })
      end
    end
  end

  local function resolve_value(value, resolving)
    resolving = resolving or {}

    return (value:gsub("var%((%-%-[%w_-]+)%)", function(name)
      if resolving[name] or not values_by_name[name] then
        return "var(" .. name .. ")"
      end

      resolving[name] = true
      local resolved = resolve_value(values_by_name[name], resolving)
      resolving[name] = nil
      return resolved
    end))
  end

  local function find_primitive_alias(name)
    local resolving = {}
    local current_name = name
    local primitive_name

    while current_name and values_by_name[current_name] and not resolving[current_name] do
      resolving[current_name] = true
      local next_name = values_by_name[current_name]:match "^%s*var%((%-%-[%w_-]+)%)%s*$"
      if not next_name then
        break
      end

      primitive_name = next_name
      current_name = next_name
    end

    if primitive_name and values_by_name[primitive_name] then
      return primitive_name .. " = " .. compact(resolve_value(values_by_name[primitive_name]))
    end
  end

  for _, variable in ipairs(variables) do
    variable.resolved_value = trim(resolve_value(variable.detail))
    variable.detail = compact(variable.resolved_value)
    variable.alias_detail = find_primitive_alias(variable.label)
  end

  cache[root] = variables
  return variables
end

local function current_word_range(line, col)
  local start_col = col
  while start_col > 0 and line:sub(start_col, start_col):match "[%w_-]" do
    start_col = start_col - 1
  end

  local end_col = col + 1
  while end_col <= #line and line:sub(end_col, end_col):match "[%w_-]" do
    end_col = end_col + 1
  end

  return start_col, end_col - 1
end

local function last_position(text, char)
  local position = 0
  local index = text:find(char, 1, true)

  while index do
    position = index
    index = text:find(char, index + 1, true)
  end

  return position
end

local function is_declaration_value_context(row, col)
  local lines = vim.api.nvim_buf_get_lines(0, 0, row, false)
  if #lines == 0 then
    return false
  end

  lines[#lines] = lines[#lines]:sub(1, col)
  local text = table.concat(lines, "\n")
  local last_open_block = last_position(text, "{")
  local last_close_block = last_position(text, "}")
  local last_colon = last_position(text, ":")
  local last_semicolon = last_position(text, ";")
  local last_separator = last_semicolon

  if vim.tbl_contains({ "javascriptreact", "typescriptreact" }, vim.bo.filetype) then
    last_separator = math.max(last_separator, last_position(text, ","))
  end

  return last_open_block > last_close_block and last_colon > last_open_block and last_colon > last_separator
end

function M.new()
  return setmetatable({}, { __index = M })
end

function M:enabled()
  return vim.tbl_contains(M.filetypes, vim.bo.filetype)
end

function M:get_trigger_characters()
  return { "-", "(" }
end

function M:get_completions(_, callback)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if not is_declaration_value_context(row, col) then
    callback {
      is_incomplete_forward = false,
      is_incomplete_backward = false,
      items = {},
    }
    return
  end

  local root = get_root()
  local line = vim.api.nvim_get_current_line()
  local start_col, end_col = current_word_range(line, col)
  local in_var_function = line:sub(1, start_col):match "var%([^)]*$" ~= nil
  local kind = vim.lsp.protocol.CompletionItemKind.Variable
  local plain_text = vim.lsp.protocol.InsertTextFormat.PlainText

  local items = vim.tbl_map(function(variable)
    local new_text = in_var_function and variable.label or ("var(" .. variable.label .. ")")
    return {
      label = variable.label,
      detail = variable.documentation,
      labelDetails = variable.alias_detail and { description = variable.alias_detail } or nil,
      documentation = {
        kind = "markdown",
        value = table.concat({
          "```css",
          variable.label .. ": " .. variable.resolved_value .. ";",
          "```",
          "",
          variable.documentation,
        }, "\n"),
      },
      kind = kind,
      insertTextFormat = plain_text,
      textEdit = {
        newText = new_text,
        range = {
          start = { line = row - 1, character = start_col },
          ["end"] = { line = row - 1, character = end_col },
        },
      },
    }
  end, read_variables(root))

  callback {
    is_incomplete_forward = false,
    is_incomplete_backward = false,
    items = items,
  }
end

function M.reload()
  cache = {}
end

return M
