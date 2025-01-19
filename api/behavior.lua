local api = mobs_hs.api
local settings = mobs_hs.settings
local inspect = mobs_hs.inspect

local explodes_on_death = settings.explodes_on_death
local explode_radius = settings.explode_radius
local explode_damage_radius = settings.explode_damage_radius

function api.custom_on_attacked(self, hitter, time_from_last_punch, tool_cap, direction)
	local my_armor = self.object:get_armor_groups()
	local enemy_armor = hitter:get_armor_groups().fleshy or 100
	local damage_fac = enemy_armor / 1.3 -- Portion of damage to reflect.

	-- Messy and inaccurate, but I don't know of a better way
	local damage_done = 0
	for group, base_amount in pairs(tool_cap.damage_groups) do
		local amount = base_amount
			* math.min(1.0, time_from_last_punch / tool_cap.full_punch_interval)
			* ((my_armor[group] or 100) / 100)
		damage_done = damage_done + amount
	end
	damage_done = math.floor(damage_done)

	hitter:punch(self.object, 1.0, {
		full_punch_interval = 1.0,
		max_drop_level = 1,
		damage_groups = {fleshy = damage_done * damage_fac, fire = 1},
	})

	return true
end

function api.on_die(self, pos)
	self.object:remove()

	minetest.add_particlespawner({
		amount = 128,
		time = 0.1,
		minpos = vector.subtract(pos, 10 / 2),
		maxpos = vector.add(pos, 10 / 2),
		minvel = { x = -3, y = 0, z = -3 },
		maxvel = { x = 3, y = 5, z = 3 },
		minacc = { x = 0, y = -10, z = 0 },
		maxacc = { x = 0, y = -10, z = 0 },
		minexptime = 1.8,
		maxexptime = 4.0,
		minsize = 10 * 0.66,
		maxsize = 10 * 2,
		texture = "mobs_hs_flame.png",
		collisiondetection = true,
	})
end

local heal_rate = 5
function api.heal(self, dtime)
	-- https://codeberg.org/tenplus1/mobs_redo/commit/812f18430c343c9ac70b83276faa3aabf5a25116
	local hp_max = self.hp_max

	if not hp_max then
		if self.object and self.object.get_properties then
			local props = self.object:get_properties()
			if props then
				hp_max = props.hp_max
			end
		end
	end

	if not hp_max then
		hp_max = settings.hp_max
	end

	if self.state == "attack" or self.health == hp_max then
		self.time_since_heal = 0
	else
		self.time_since_heal = (self.time_since_heal or 0) + dtime
		if self.time_since_heal > heal_rate then
			self.health = math.min(hp_max, self.health + math.round(self.time_since_heal / heal_rate))
			self.time_since_heal = 0
		end
	end
end

api.on_do_custom = {}
function api.register_on_do_custom(callback)
	api.on_do_custom[#api.on_do_custom + 1] = callback
end

function api.do_custom(self, dtime)
	for _, callback in ipairs(api.on_do_custom) do
		callback(self, dtime)
	end

	api.heal(self, dtime)
	return true
end

function api.on_blast(self, damage)
	return false, false, {}
end
