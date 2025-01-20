mobs_hs = { api = {}, settings = {}, entity = {}, spawn = {} }
mobs_hs.modpath = minetest.get_modpath("mobs_hs") .. "/"

local get_settings = dofile(mobs_hs.modpath .. "third_party/get_settings.lua")
mobs_hs.settings = get_settings("mobs_hs")

dofile(mobs_hs.modpath .. "api/init.lua")
dofile(mobs_hs.modpath .. "entity.lua")
dofile(mobs_hs.modpath .. "spawn.lua")

mobs:alias_mob("mobs:hell_sentinel", "mobs_hs:hell_sentinel")
