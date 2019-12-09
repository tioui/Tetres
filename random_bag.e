note
	description : "A bag that is used to randomize {TETROMINO} `pick' order."
	author      : "Louis Marchand"
	date        : "July 19 2012"
	revision    : "1.0"

class
	RANDOM_BAG

create
	make

feature {NONE} -- Initialization

	make(rnd_ctrl:GAME_RANDOM_CONTROLLER;min,max:INTEGER)
			-- Initialization for `Current' using `rnd_ctrl' as `random_ctrl' and
			-- `min' and `max' as possible value in the `bag'.
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
		-- Assign the next element of `Current' to `last_pick' and remove it.
		do
			if bag.count<1 then
				fill_bag
			end
			last_pick:=bag.item
			bag.remove
		ensure
			Random_Bag_Pick_Value_Valid: last_pick>=min_value and last_pick<=max_value
		end

	last_pick:INTEGER
			-- The last element that has been assign by `pick'

	max_value:INTEGER
			-- The maximal value that `Current' can `pick'

	min_value:INTEGER
			-- The minimal value that `Current' can `pick'

feature {NONE} -- Implementation - Routines

	fill_bag
			-- Add every possible element between `min_value'
			-- and `max_value' in the `bag' with random order.
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
			-- {STACK} that contain every element to `pick' in random order.

	random_ctrl:GAME_RANDOM_CONTROLLER
			-- Random manager used to randomize the elements of `bag'

end
