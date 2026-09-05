local mp = require("mp")

local function search_anidb()
  local handle = io.popen("ani-mpv")
  if not handle then
    return
  end
  local out_tbl = {}
  for line in handle:lines() do
    table.insert(out_tbl, line)
  end
  local passed, _, _ = handle:close()
  if not passed then
    mp.osd_message(tostring(out_tbl[1]), 3)
    return
  end
  local title = table.remove(out_tbl, 1)
  for _, url in ipairs(out_tbl) do
    mp.command_native({
      name = "loadfile",
      url = url,
      flags = "append-play",
      options = {
        ["force-media-title"] = title,
      },
    })
  end
end

mp.add_key_binding("Ctrl+a", "search-anidb", search_anidb)
