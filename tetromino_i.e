note
	description: "Summary description for {TETROMINO_I}."
	author      : "Louis Marchand"
	date        : "July 19 2012"
	revision    : "1.0"

class
	TETROMINO_I

inherit
	TETROMINO
	rename
		make as make_tetromino
	redefine
		default_state,
		init_wall_kicks_list
	end


create
	make,
	make_from_other

feature {NONE} -- Initialization

	make(l_surface:GAME_SURFACE;block_width,block_height:NATURAL;rotation:BOOLEAN)
			-- Initialization for `Current'.
		do
			make_tetromino(l_surface,1,block_width,block_height,rotation)
			y:=21
		end

feature -- Access

	default_state
		do
			precursor
			y:=21
		end

feature {NONE} -- Initialisation

	blocks_positions_init:ARRAY[TUPLE[row,column:INTEGER]]
		once
			Result:=<<	[2,1],[2,2],[2,3],[2,4],
						[1,3],[2,3],[3,3],[4,3],
						[3,4],[3,3],[3,2],[3,1],
						[4,2],[3,2],[2,2],[1,2]>>
		end


	init_wall_kicks_list
		local
			temp_list:ARRAYED_LIST[TUPLE[x,y:INTEGER]]
		do
			create {ARRAYED_LIST[LIST[TUPLE[x,y:INTEGER]]]} wall_kicks_list.make(8)
			create temp_list.make(5)
			temp_list.extend ([0,0])
			temp_list.extend ([-2,0])
			temp_list.extend ([1,0])
			temp_list.extend ([-2,-1])
			temp_list.extend ([1,2])
			wall_kicks_list.extend (temp_list)		-- 0->R

			create temp_list.make(5)
			temp_list.extend ([0,0])
			temp_list.extend ([-1,0])
			temp_list.extend ([2,0])
			temp_list.extend ([-1,2])
			temp_list.extend ([2,-1])
			wall_kicks_list.extend (temp_list)		-- R->2

			create temp_list.make(5)
			temp_list.extend ([0,0])
			temp_list.extend ([2,0])
			temp_list.extend ([-1,0])
			temp_list.extend ([2,1])
			temp_list.extend ([-1,-2])
			wall_kicks_list.extend (temp_list)		-- 2->L

			create temp_list.make(5)
			temp_list.extend ([0,0])
			temp_list.extend ([1,0])
			temp_list.extend ([-2,0])
			temp_list.extend ([1,-2])
			temp_list.extend ([-2,1])
			wall_kicks_list.extend (temp_list)		-- L->0


			wall_kicks_list.extend (wall_kicks_list.at (2))		-- 0->L
			wall_kicks_list.extend (wall_kicks_list.at (3))		-- R->0
			wall_kicks_list.extend (wall_kicks_list.at (4))		-- 2->R
			wall_kicks_list.extend (wall_kicks_list.at (1))		-- L->2


		end

end
