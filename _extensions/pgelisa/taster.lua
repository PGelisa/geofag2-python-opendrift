-- Snarveier for taster og tekst som er ulik på Mac og Windows.
--
--   {{< taster Ctrl C >}}                     Ctrl + C på alle maskiner
--   {{< taster Ctrl C mac="control C" >}}     Ctrl + C på Windows, control + C på Mac
--   {{< os win="«Miniforge Prompt»" mac="«Terminal»" >}}
--
-- På nettsider følger teksten valget i fanene med group="os" (se pgelisa-os.html).
-- I PDF skrives begge variantene.

local function keys_from(args)
  local keys = {}
  for _, a in ipairs(args) do
    local s = pandoc.utils.stringify(a)
    if s ~= "" then table.insert(keys, s) end
  end
  return keys
end

local function split(s)
  local keys = {}
  for k in string.gmatch(s, "%S+") do table.insert(keys, k) end
  return keys
end

local function html_escape(s)
  return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"))
end

local function latex_escape(s)
  return (s:gsub("\\", "\\textbackslash{}"):gsub("([#$%%&_{}])", "\\%1"):gsub("~", "\\textasciitilde{}"):gsub("%^", "\\textasciicircum{}"))
end

local function html_keys(keys)
  local parts = {}
  for _, k in ipairs(keys) do
    table.insert(parts, '<kbd class="pg-tast">' .. html_escape(k) .. '</kbd>')
  end
  return '<span class="pg-taster">' .. table.concat(parts, '<span class="pg-pluss"> + </span>') .. '</span>'
end

local function latex_keys(keys)
  local parts = {}
  for _, k in ipairs(keys) do
    table.insert(parts, '\\pgkbd{\\small ' .. latex_escape(k) .. '}')
  end
  return table.concat(parts, ' + ')
end

local function plain_keys(keys)
  return table.concat(keys, " + ")
end

local function is_html()
  return quarto.doc.is_format("html")
end

local function is_latex()
  return quarto.doc.is_format("latex") or quarto.doc.is_format("pdf")
end

local function kw(kwargs, name)
  local v = kwargs[name]
  if v == nil then return nil end
  v = pandoc.utils.stringify(v)
  if v == "" then return nil end
  return v
end

return {
  ["taster"] = function(args, kwargs)
    local keys = keys_from(args)
    local mac = kw(kwargs, "mac")
    local win = kw(kwargs, "win")
    local mac_keys = mac and split(mac) or nil
    local win_keys = win and split(win) or keys
    if #keys == 0 then keys = win_keys or mac_keys or {} end
    if #keys == 0 then return pandoc.Null() end

    if is_html() then
      if mac_keys then
        return pandoc.RawInline("html",
          '<span class="pg-os pg-os-win">' .. html_keys(win_keys) .. '</span>' ..
          '<span class="pg-os pg-os-mac">' .. html_keys(mac_keys) .. '</span>')
      end
      return pandoc.RawInline("html", html_keys(keys))
    elseif is_latex() then
      local s = latex_keys(win_keys)
      if mac_keys then s = s .. " (Mac: " .. latex_keys(mac_keys) .. ")" end
      return pandoc.RawInline("latex", s)
    else
      local s = plain_keys(win_keys)
      if mac_keys then s = s .. " (Mac: " .. plain_keys(mac_keys) .. ")" end
      return pandoc.Str(s)
    end
  end,

  ["os"] = function(args, kwargs)
    local mac = kw(kwargs, "mac") or ""
    local win = kw(kwargs, "win") or ""
    if is_html() then
      return pandoc.RawInline("html",
        '<span class="pg-os pg-os-win">' .. html_escape(win) .. '</span>' ..
        '<span class="pg-os pg-os-mac">' .. html_escape(mac) .. '</span>')
    else
      return pandoc.Str(win .. " (Windows) / " .. mac .. " (Mac)")
    end
  end,
}
