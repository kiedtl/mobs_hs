local has = mobs_hs.has
local settings = mobs_hs.settings

local nodes = {
	"default:stone_with_diamond",
	"default:stone_with_mese",
	"default:stone_with_gold",
	"default:stone_with_copper",
	"default:stone_with_iron",
	"default:mese",
}

if minetest.get_modpath("moreores") then
	nodes[#nodes + 1] = "moreores:stone_with_mithril"
	nodes[#nodes + 1] = "moreores:stone_with_silver"
end

if minetest.get_modpath("technic") then
	nodes[#nodes + 1] = "technic:mineral_sulfur" -- Brimstone!
	nodes[#nodes + 1] = "technic:mineral_lead"
end

mobs:spawn({
	name = "mobs_hs:hell_sentinel",
	nodes = nodes,
	max_light = settings.max_light,
	min_light = settings.min_light,
	interval = settings.spawn_interval,
	chance = settings.spawn_chance,
	active_object_count = settings.active_object_count,
	min_height = settings.min_height,
	max_height = settings.max_height,
})

mobs:spawn({
	name = "mobs_hs:hell_sentinel",
	nodes = nodes,
	max_light = settings.max_light,
	min_light = settings.min_light,
	interval = settings.spawn_interval,
	chance = settings.spawn_chance * 2,
	active_object_count = settings.active_object_count,
	min_height = settings.min_height,
	max_height = (3 * settings.min_height + settings.max_height) / 4,
})
