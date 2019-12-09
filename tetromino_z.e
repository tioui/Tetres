note
	description: "Summary description for {TETROMINO_Z}."
	author      : "Louis Marchand"
	date        : "July 19 2012"
	revision    : "1.0"

class
	TETROMINO_Z

inherit
	TETROMINO
	rename
		make as make_tetromino
	end


create
	make,
	make_from_other

feature {NONE} -- Initialization

	make(l_surface:GAME_SURFACE;block_width,block_height:NATURAL;rotation:BOOLEAN)
			-- Initialization for `Current'.
		do
			make_tetromino(l_surface,5,block_width,block_height,rotation)
		end


feature {NONE} -- Initialisation

	blocks_positions_init:ARRAY[TUPLE[row,column:INTEGER]]
		once
			Result:=<<	[1,1],[1,2],[2,2],[2,3],
						[1,3],[2,3],[2,2],[3,2],
						[3,3],[3,2],[2,2],[2,1],
						[3,1],[2,1],[2,2],[1,2]>>
		end

end
