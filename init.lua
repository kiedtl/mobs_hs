futil.check_version({ year = 2023, month = 11, day = 1 }) -- is_player

mobs_hs = fmod.create()

mobs_hs.dofile("api", "init")
mobs_hs.dofile("entity")
mobs_hs.dofile("spawn")

if mobs_hs.settings.debug then
	mobs_hs.dofile("third_party", "inspect")
end

mobs:alias_mob("mobs:hell_sentinel", "mobs_hs:hell_sentinel")
