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
  for _, line in ipairs(out_tbl) do
    local title, url, chap_file, opts = line:match("^(.-)\t(.*)\t(.*)\t(.*)$")
    mp.osd_message(chap_file .. " " .. opts, 3)
    mp.command_native({
      name = "loadfile",
      url = url,
      flags = "append-play",
      options = {
        ["force-media-title"] = title,
        ["chapters-file"] = chap_file,
        ["script-opts"] = opts,
      },
    })
  end
end

mp.register_script_message("search-anidb", search_anidb)
