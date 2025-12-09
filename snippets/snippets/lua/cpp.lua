local ls = require("luasnip")
local rep = require("luasnip.extras").rep


local get_visual = function(args, parent)
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else  -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end


local process_doxygen_params = function(params_string, parent)
  local new_nodes = {}

  local input = params_string or ""

  -- Split the input string by commas.
  local params = {}
  for param in vim.gsplit(input, ",") do
    table.insert(params, param)
  end

  -- Process each parameter that was found.
  for idx, param in ipairs(params) do
    param = vim.trim(param)
    if param ~= "" then
      -- Extract the last word, which is the variable name.
      -- This handles "int count", "const char* name", etc.
      local name = param:match("([%w_]+)$") or ""

      -- Create the nodes for the Doxygen line.
      table.insert(new_nodes, t({"", " * \\param " .. name .. " "}))
      table.insert(new_nodes, i(idx))
      table.insert(new_nodes, t(""))
    end
  end

  -- Return a new, anonymous snippet containing our generated nodes.
  return ls.snippet(parent, new_nodes)
end

local process_doxygen_returns = function(params_string, parent)
  local input = params_string or ""
  local new_nodes = {}
  if input ~= "void" then
    table.insert(new_nodes, t({"", " * \\return "}))
    table.insert(new_nodes, i(1))
    table.insert(new_nodes, t(""))
  end
  return ls.snippet(parent, new_nodes)
end

local function get_next_th_number(default_val)
  local row = vim.api.nvim_win_get_cursor(0)[1]

  -- NOTE! Remember to increment the row-offsets if you change the snippet using this function.
  local lines = vim.api.nvim_buf_get_lines(0, row + 3, row + 4, false)
  
  if lines and lines[1] then
    local id_str = string.match(lines[1], "|%s*(%d+)")
    
    if id_str then
      local width = math.max(#id_str, 2)
      local num = tonumber(id_str)
      local next_num = num + 1
      local fmt = "%0" .. width .. "d"
      
      default_val = string.format(fmt, next_num)
    end
  end

  return sn(nil, {
      i(1, default_val)
  })
end

local function get_english_date(args)
  local months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" }
  local day = os.date("%d")
  local month = months[tonumber(os.date("%m"))]
  local year = os.date("%Y")

  return day .. "-" .. month .. "-" .. year
end

local function get_padding(args)
    -- args[1] is the text from the watched node.
    -- args[1][1] is the first line of that text.
    local id_text = args[1][1]
    
    return string.rep(" ", #id_text)
end

return {
  s("class",
    fmta(
      [[
      class <> {
      public:
        <>(<>);
        virtual ~<>();
        <>
      private:
      };
      ]],
      {
        i(1, string.upper(vim.fn.expand("%:t:r"):sub(1, 1)) .. vim.fn.expand("%:t:r"):sub(2)),
        rep(1),
        i(2),
        rep(1),
        i(0),
      }
    )
  ),
  --------------------------------------
  s("taskheaderlineisds",
    fmta(
      [[
      | <>    <>  Tern Systems/Johann Fridriksson
      | <>    Task: <>
      | <>    <>
      |
      ]],
      {
        d(1, function() return get_next_th_number("001") end),
        f(function() return os.date("%Y-%m-%d") end),
        f(get_padding, {1}),
        i(2, "TaskNumber"),
        f(get_padding, {1}),
        i(3, "Description"),
      }
    )
  ),
  --------------------------------------
  s("taskheaderlineice",
    fmta(
      [[
      | <>  <> Tern Systems/Johann Fridriksson
      | <>    Task: <>
      | <>    <>
      |
      ]],
      {
        d(1, function() return get_next_th_number("01") end),
        f(get_english_date, {}),
        f(get_padding, {1}),
        i(2, "TaskNumber"),
        f(get_padding, {1}),
        i(3, "Description"),
      }
    )
  ),
  --------------------------------------
  s("cout",
    fmta("std::cout <<<< \"<>: \" <<<< <> <<<< '\\n'; // FIXME remove\n",
      {
        rep(1),
        i(1, "Variable")
      }
    )
  ),
 --------------------------------------
  s("info",
    fmta("TraceInfo(\"<>\"); // FIXME remove<>\n",
      {
        i(1, "Message"),
        i(0)
      }
    )
  ),
 --------------------------------------
  s("infovar",
    fmta("TraceInfo(\"<>: \" <<<< <>); // FIXME remove\n",
      {
        rep(1),
        i(1, "Variable")
      }
    )
  ),
  --------------------------------------
  s({trig = "fn", desc = "Function with a Doxygen header"},
    fmta(
    [[
    /*!
     * \brief <><><>
     */
     <> <>(<>) {
      <>
     }
    ]], {
      i(4, "Brief description"),
      d(5, function(args, parent)
        local params_string = args[1] and args[1][1]
        return process_doxygen_params(params_string, parent)
      end, { 3 }),
      d(6, function(args, parent)
        local params_string = args[1] and args[1][1]
        return process_doxygen_returns(params_string, parent)
      end, { 1 }),
      i(1, "TypeName"),
      i(2, "FunctionName"),
      i(3, "Arguments"),
      i(0),
    }
    )
  ),
  --------------------------------------
  s("includeguard",
  fmta(
    [[
    #ifndef _<>_H
    #define _<>_H
    <><>
    #endif // _<>_H
    ]],
    {
    f(function() return vim.fn.expand("%:t:r"):upper() end),
    f(function() return vim.fn.expand("%:t:r"):upper() end),
    f(function(_, snip)
     return snip.env.TM_SELECTED_TEXT or {}
    end),
    i(0),
    f(function() return vim.fn.expand("%:t:r"):upper() end),
    }
  )
    ),
}

