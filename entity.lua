local api = mobs_hs.api
local settings = mobs_hs.settings

mobs:register_mob("mobs_hs:hell_sentinel", {
	nametag = "",
	passive = false,
	type = "monster",
	hp_min = settings.hp_min,
	hp_max = settings.hp_max,
	armor = {
		fleshy = 60,
		burns = 40,
	},
	lifetimer = settings.lifetimer,

	walk_velocity = 2.0,
	-- He's a speedy boi
	-- Also, surprise player who was observing and thinks it's slow :P
	run_velocity = 12.0,

	-- Sentinel, so stands around for a while, and occasionally moves around.
	walk_chance = 10,
	stand_change = 50,

	-- Yes, it's a sentinel, but looks a bit goofy
	randomly_turn = false,

	stay_near = {
		nodes = { "default:lava_source", "default:obsidian", "default:steelblock" },
		chance = 33,
	},

	-- Agile and dangerous.
	jump = true,
	jump_height = 3,
	can_leap = true,
	stepheight = 2.0,
	view_range = settings.view_range,
	knock_back = true, -- A bit too strong otherwise?
	fear_height = 0,

	-- It's a monolith made of iron.
	fall_damage = 0,
	water_damage = 0,
	lava_damage = 0,
	fire_damage = 0,
	suffocation = 0,

	-- Only natural light will damage
	light_damage = 3,
	light_damage_min = 16,
	light_damage_max = 16,

	attack_type = "dogshoot",

	attack_chance = 0,
	attack_patience = 100,
	attack_animals = true,
	attack_monsters = true,
	attack_player = true,
	damage = settings.damage,
	reach = 2,

	arrow = "mobs_hs:hell_sentinel_arrow",
	dogshoot_switch = 1,
	dogshoot_count_max = 16,
	dogshoot_count2_max = 16,
	shoot_interval = 4,
	shoot_offset = 1,

	blood_amount = 18,
	blood_texture = "mobs_hs_flame.png",
	pathfinding = settings.pathfinding,
	makes_footstep_sound = true,
	sounds = {
		distance = settings.view_range * 2,
		random = "mobs_hs_random",
		war_cry = "mobs_hs_war_cry",
		death = "mobs_hs_death",
		attack = "mobs_hs_attack",
	},
	visual = "mesh",
	visual_size = { x = 2, y = 2 },
	collisionbox = { -0.8, -2.0, -0.8, 0.8, 2.5, 0.8 },
	textures = { "mobs_hs_hell_sentinel.png" },
	mesh = "mobs_hs_hell_sentinel.glb",
	rotate = 180,
	glow = 3,
	animation = {
		stand_start = 0,
		stand_end = 240,
		walk_start = 240,
		walk_end = 300,
		walk_speed = 30,
		run_speed = 45,
		punch_start = 300,
		punch_end = 380,
		punch_speed = 45,
	},
	do_punch = function(...)
		return api.custom_on_attacked(...)
	end,
	on_die = function(...)
		return api.on_die(...)
	end,
	do_custom = function(...)
		return api.do_custom(...)
	end,
	on_blast = function(...)
		return api.on_blast(...)
	end,
	after_activate = function(self, staticdata, def, dtime)
		api.heal(self, dtime)
	end,
})

mobs:register_arrow("mobs_hs:hell_sentinel_arrow", {
	visual = "mesh",
	visual_size = {x = 1.00, y = 1.00 },
	mesh = "mobs_hs_hell_sentinel_arrow.obj",
	textures = { "mobs_hell_sentinel_arrow.png" },
	glow = 12,
	expire = 0.01,
	velocity = 2, --25,
	lifetime = 18,
	rotate = -90,

	on_activate = function(self, staticdata, dtime_s)
		-- make it indestructable
		self.object:set_armor_groups({immortal = 1, fleshy = 100})
	end,


	hit_player = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = { fleshy = settings.arrow_damage_fleshy, fire = settings.arrow_damage_fire }
		}, nil)
	end,

	hit_mob = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = { fleshy = settings.arrow_damage_fleshy, fire = settings.arrow_damage_fire }
		}, nil)
	end,

	hit_node = function(self, pos, node)
		mobs:boom(self, pos, 1)
	end
})

mobs:register_egg(
	"mobs_hs:hell_sentinel",
	"Hell Sentinel",
	"mobs_hs_flame.png", -- the texture displayed for the egg in inventory
	1, -- egg image in front of your texture (1 = yes, 0 = no)
	false -- if set to true this stops spawn egg appearing in creative
)
