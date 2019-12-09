note
	description : "Generate {TETROMINO}."
	author      : "Louis Marchand"
	date        : "July 19 2012"
	revision    : "1.0"

class
	TETROMINOS_FACTORY

create
	make,
	make_with_alpha

feature {NONE} -- Initialization

	make(ressource_surface:GAME_SURFACE;block_width,block_height:NATURAL;rotation:BOOLEAN)
			-- Initialization for `Current' using the images in `ressource_surface' to
			-- generate {BLOCK} images of dimension `block_width' by `block_height'.
			-- If `rotation' is `True', apply rotation on individual {BLOCK}.
		do
			create tet_i.make (ressource_surface, block_width, block_height,rotation)
			create tet_j.make (ressource_surface, block_width, block_height,rotation)
			create tet_l.make (ressource_surface, block_width, block_height,rotation)
			create tet_o.make (ressource_surface, block_width, block_height,rotation)
			create tet_s.make (ressource_surface, block_width, block_height,rotation)
			create tet_t.make (ressource_surface, block_width, block_height,rotation)
			create tet_z.make (ressource_surface, block_width, block_height,rotation)

		end

	make_with_alpha(ressource_surface:GAME_SURFACE;block_width,block_height:NATURAL;rotation:BOOLEAN;alpha_value:NATURAL_8)
			-- Initialization for `Current' using the images in `ressource_surface' to
			-- generate {BLOCK} images of dimension `block_width' by `block_height'and a
			-- transparency of `alpha_value'.
			-- If `rotation' is `True', apply rotation on individual {BLOCK}.
		do
			make(ressource_surface,block_width,block_height,rotation)
			tet_i.set_ghost_effect(alpha_value)
			tet_j.set_ghost_effect(alpha_value)
			tet_l.set_ghost_effect(alpha_value)
			tet_o.set_ghost_effect(alpha_value)
			tet_s.set_ghost_effect(alpha_value)
			tet_t.set_ghost_effect(alpha_value)
			tet_z.set_ghost_effect(alpha_value)
		end

feature -- Access

	get_tetromino_i:TETROMINO_I
			-- New I {TETROMINO}
		do
			create Result.make_from_other (tet_i)
		end

	get_tetromino_j:TETROMINO_J
			-- New J {TETROMINO}
		do
			create Result.make_from_other (tet_j)
		end

	get_tetromino_l:TETROMINO_L
			-- New L {TETROMINO}
		do
			create Result.make_from_other (tet_l)
		end

	get_tetromino_o:TETROMINO_O
			-- New O {TETROMINO}
		do
			create Result.make_from_other (tet_o)
		end

	get_tetromino_s:TETROMINO_S
			-- New S {TETROMINO}
		do
			create Result.make_from_other (tet_s)
		end

	get_tetromino_t:TETROMINO_T
			-- New T {TETROMINO}
		do
			create Result.make_from_other (tet_t)
		end

	get_tetromino_z:TETROMINO_Z
			-- New Z {TETROMINO}
		do
			create Result.make_from_other (tet_z )
		end

	get_tetromino_by_index(index:INTEGER):TETROMINO
			-- New {TETROMINO} using internal index.
		require
			Tetromino_Index_Valid: index>=1 and index<=7
		do
			if index=tet_i.index then
				Result:=get_tetromino_i
			elseif index=tet_j.index then
				Result:=get_tetromino_j
			elseif index=tet_l.index then
				Result:=get_tetromino_l
			elseif index=tet_o.index then
				Result:=get_tetromino_o
			elseif index=tet_s.index then
				Result:=get_tetromino_s
			elseif index=tet_t.index then
				Result:=get_tetromino_t
			elseif index=tet_z.index then
				Result:=get_tetromino_z
			end
		end

feature {NONE} -- Implementation - Variable

	tet_i:TETROMINO_I
			-- I {TETROMINO} prototype
	tet_j:TETROMINO_J
			-- J {TETROMINO} prototype
	tet_l:TETROMINO_L
			-- L {TETROMINO} prototype
	tet_o:TETROMINO_O
			-- O {TETROMINO} prototype
	tet_s:TETROMINO_S
			-- S {TETROMINO} prototype
	tet_t:TETROMINO_T
			-- T {TETROMINO} prototype
	tet_z:TETROMINO_Z
			-- Z {TETROMINO} prototype

end
