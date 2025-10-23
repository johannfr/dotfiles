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
    fmta("TraceInfo(\"<>: \", <>); // FIXME remove\n",
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
}

