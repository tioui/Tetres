note
	description: "Summary description for {TETROMINO_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TETROMINO_I

inherit
	TETROMINO
	rename
		make as make_tetromino
	redefine
		default_state
	end


create
	make,
	make_from_other

feature {NONE} -- Initialization

	make(l_surface:GAME_SURFACE;block_width,block_height:NATURAL)
			-- Initialization for `Current'.
		do
			make_tetromino(l_surface,1,block_width,block_height)
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


end
