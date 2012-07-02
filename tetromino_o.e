note
	description: "Summary description for {TETROMINO_O}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TETROMINO_O

inherit
	TETROMINO
	rename
		make as make_tetromino
	end


create
	make,
	make_from_other

feature {NONE} -- Initialization

	make(l_surface:GAME_SURFACE;block_width,block_height:NATURAL)
			-- Initialization for `Current'.
		do
			make_tetromino(l_surface,2,block_width,block_height)
		end


feature {NONE} -- Initialisation

	blocks_positions_init:ARRAY[TUPLE[row,column:INTEGER]]
		once
			Result:=<<	[1,2],[1,3],[2,3],[2,2],
						[1,3],[2,3],[2,2],[1,2],
						[2,3],[2,2],[1,2],[1,3],
						[2,2],[1,2],[1,3],[2,3]>>
		end
end
