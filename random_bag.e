note
	description: "Summary description for {RANDOM_BAG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RANDOM_BAG

create
	make

feature {NONE} -- Initialization

	make(rnd_ctrl:GAME_RANDOM_CONTROLLER;min,max:INTEGER)
			-- Initialization for `Current'.
		require
			rnd_ctrl/=Void
		do
			min_value:=min
			max_value:=max
			random_ctrl:=rnd_ctrl
			create bag.make (max-min+1)
		end

feature -- Access

	pick
		do
			if bag.count<1 then
				fill_bag
			end
			get_last_pick:=bag.item
			bag.remove
		ensure
			Random_Bag_Pick_Value_Valid:get_last_pick>=min_value and get_last_pick<=max_value
		end

	get_last_pick:INTEGER

	max_value:INTEGER

	min_value:INTEGER

feature {NONE} -- Implementation - Routines

	fill_bag
		local
			value_list:LINKED_LIST[INTEGER]
			i:INTEGER
			index:INTEGER
		do
			create value_list.make
			from
				i:=min_value
			until
				i>max_value
			loop
				value_list.extend (i)
				i:=i+1
			end
			from
				i:=max_value-min_value+1
			until
				i<1
			loop
				random_ctrl.generate_new_random
				index:=random_ctrl.last_random_integer_between (1, i)
				value_list.go_i_th (index)
				bag.put (value_list.item)
				value_list.remove
				i:=i-1
			end
		end

feature {NONE} -- Implementation - Variables

	bag:ARRAYED_STACK[INTEGER]
	random_ctrl:GAME_RANDOM_CONTROLLER

end
