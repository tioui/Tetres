note
	description : "Every block used in the {TETROMINO}"
	author      : "Louis Marchand"
	date        : "July 19 2012"
	revision    : "1.0"

class
	BLOCK

create
	make

feature {NONE} -- initialisation

	make(l_surface:GAME_SURFACE)
			-- Initialization of `Current' using `l_surface' as `surface'
		do
			surface:=l_surface
		end

feature -- Access

	surface:GAME_SURFACE
			-- Internal image of `Current'

end
