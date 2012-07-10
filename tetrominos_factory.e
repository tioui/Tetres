note
	description: "Summary description for {TETROMINOS_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TETROMINOS_FACTORY

create
	make,
	make_with_alpha

feature {NONE} -- Initialization

	make(ressource_surface:GAME_SURFACE;block_width,block_height:NATURAL;rotation:BOOLEAN)
			-- Initialization for `Current'.
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
		do
			create Result.make_from_other (tet_i)
		end

	get_tetromino_j:TETROMINO_J
		do
			create Result.make_from_other (tet_j)
		end

	get_tetromino_l:TETROMINO_L
		do
			create Result.make_from_other (tet_l)
		end

	get_tetromino_o:TETROMINO_O
		do
			create Result.make_from_other (tet_o)
		end

	get_tetromino_s:TETROMINO_S
		do
			create Result.make_from_other (tet_s)
		end

	get_tetromino_t:TETROMINO_T
		do
			create Result.make_from_other (tet_t)
		end

	get_tetromino_z:TETROMINO_Z
		do
			create Result.make_from_other (tet_z )
		end

	get_tetromino_by_index(index:INTEGER):TETROMINO
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
	tet_j:TETROMINO_J
	tet_l:TETROMINO_L
	tet_o:TETROMINO_O
	tet_s:TETROMINO_S
	tet_t:TETROMINO_T
	tet_z:TETROMINO_Z

end
