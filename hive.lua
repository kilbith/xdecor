local hive = {}

function hive.construct(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	local formspec = [[ size[8,5;]
			label[1.35,0;Bees are making honey]
			label[1.35,0.5;with pollen around...]
			image[6,0;1,1;hive_bee.png]
			image[5,0;1,1;hive_layout.png]
			list[context;honey;5,0;1,1;]
			list[current_player;main;0,1.35;8,4;] ]]
			..xbg..default.get_hotbar_bg(0,1.35)

	meta:set_string("formspec", formspec)
	meta:set_string("infotext", "Artificial Hive")
	inv:set_size("honey", 1)
end

xdecor.register("hive", {
	description = "Artificial Hive",
	tiles = {
		"xdecor_hive_top.png", "xdecor_hive_top.png",
		"xdecor_hive_side.png", "xdecor_hive_side.png",
		"xdecor_hive_side.png", "xdecor_hive_front.png"
	},
	groups = {choppy=3, oddly_breakable_by_hand=2, flammable=1},
	on_construct = hive.construct,
	can_dig = function(pos, _)
		return minetest.get_meta(pos):get_inventory():is_empty("honey")
	end,
	on_punch = function(_, _, puncher)
		puncher:set_hp(puncher:get_hp()-4)
	end,
	allow_metadata_inventory_put = function() return 0 end
})

minetest.register_abm({
	nodenames = {"xdecor:hive"},
	interval = 30, chance = 10,
	action = function(pos, _, _, _)
		local inv = minetest.get_meta(pos):get_inventory()
		local honeystack = inv:get_stack("honey", 1)
		local honey = honeystack:get_count()

		local radius = 4
		local minp = vector.add(pos, -radius)
		local maxp = vector.add(pos, radius)
		local flowers = minetest.find_nodes_in_area(minp, maxp, "group:flower")

		if #flowers >= 2 and honey < 16 then
			inv:add_item("honey", "xdecor:honey")
		end
	end
})
