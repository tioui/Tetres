note
	description : "The L {TETROMINO}."
	author      : "Louis Marchand"
	date        : "July 19 2012"
	revision    : "1.0"

class
	TETROMINO_L

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
			-- Initialisation of `Current' using the images on `l_surface' with {BLOCK}
			-- of dimension `block_width'x`block_height'.
			-- If `rotation' is `True', apply rotation on individual {BLOCK}.
		do
			make_tetromino(l_surface,7,block_width,block_height,rotation)
		end


feature {NONE} -- Initialisation

	blocks_positions_init:ARRAY[TUPLE[row,column:INTEGER]]
			-- <Precursor>
		once
			Result:=<<	[1,3],[2,3],[2,2],[2,1],
						[3,3],[3,2],[2,2],[1,2],
						[3,1],[2,1],[2,2],[2,3],
						[1,1],[1,2],[2,2],[3,2]>>
		end

end
