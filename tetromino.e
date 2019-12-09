note
	description : "Agncement of 4 {BLOCK}"
	author      : "Louis Marchand"
	date        : "July 19 2012"
	revision    : "1.0"

deferred class
	TETROMINO

feature {NONE} -- Initialisation

	make(l_surface:GAME_SURFACE;l_index:NATURAL_8;block_width,block_height:NATURAL;rotation:BOOLEAN)
			-- Initialisation of `Current' using the images on `l_surface' at index
			-- `l_index' with {BLOCK} of dimension `block_width'x`block_height'.
			-- If `rotation' is `True', apply rotation on individual {BLOCK}.
		do
			index:=l_index
			default_state
			create_matrix
			fill_matrix(l_surface,block_width,block_height,rotation)
			init_wall_kicks_list
		end

	make_from_other(other:TETROMINO)
			-- Initialisation of `Current' using values of `other'.
		do
			index:=other.index
			list_blocks_matrix:=other.list_blocks_matrix
			copy_state_from_other(other)
			init_wall_kicks_list
		end

feature -- Access

	index:NATURAL_8
			-- Sub-image block index of `Current'

	rotation_index:INTEGER
			-- The number of 90 degree rotation to apply

	blocks_matrix:LIST[LIST[BLOCK]]
			-- Every {BLOCK} of `Current'
		do
			Result:=list_blocks_matrix.at (rotation_index+1)
		end

	rotate_left
			-- Rotate `Current' 90 degree to the left.
		do
			save_state
			rotation_index:=(rotation_index+3)\\4
			wall_kick_exhausted:=false
			wall_kick_index:=0
			wall_kick_nb:=old_rotation_index+1
		end



	rotate_right
			-- Rotate `Current' 90 degree to the right.
		do
			save_state
			rotation_index:=(rotation_index+1)\\4
			wall_kick_exhausted:=false
			wall_kick_index:=0
			wall_kick_nb:=old_rotation_index+1
		end

	move_left
			-- Move `Current' to the left.
		do
			save_state
			x:=x-1
		end

	move_right
			-- Move `Current' to the right.
		do
			save_state
			x:=x+1
		end

	go_down
			-- Move down `Current'.
		do
			save_state
			y:=y-1
		end

	x:INTEGER
			-- Horizontal position of `Current'

	y:INTEGER
			-- Vertical position of `Current'

	cancel_last_move
			-- Get back to the previous position and rotation.
		do
			x:=old_x
			y:=old_y
			rotation_index:=old_rotation_index
			wall_kick_exhausted:=true
		end

	set_ghost_effect(alpha_value:NATURAL_8)
			-- Apply a ghost effect of `alpha_value' transparency
		local
			h,i,j:INTEGER
		do

			from
				h:=1
			until
				h>4
			loop

				from
					i:=1
				until
					i>4
				loop
					from
						j:=1
					until
						j>4
					loop
						if list_blocks_matrix.at (h).at (i).at (j)/=Void then
							list_blocks_matrix.at (h).at (i).at (j).surface.set_overall_alpha_value (alpha_value)
						end
						j:=j+1
					end
					i:=i+1
				end

				h:=h+1
			end


		end


	copy_state_from_other(other:TETROMINO)
			-- Copy every values from `other' into `Current'
		require
			Tetromino_Copy_State_Same_Tetromino: other.index=index
		do
			x:=other.x
			y:=other.y
			rotation_index:=other.rotation_index
			wall_kick_exhausted:=true
		end

	default_state
			-- Set default values of `Current'
		do
			rotation_index:=0
			x:=4
			y:=20
			wall_kick_exhausted:=true
		end

	print_on_surface(l_surface:GAME_SURFACE;l_x,l_y:INTEGER)
			-- Show `Current' on `l_surface' at position (`l_x',`l_y').
		local
			i,j:INTEGER
		do
			from
				i:=1
			until
				i>4
			loop
				from
					j:=1
				until
					j>4
				loop
					if blocks_matrix.at (i).at (j)/=Void then
						l_surface.draw_surface (blocks_matrix.at (i).at (j).surface,(j-1)*blocks_matrix.at (i).at (j).surface.width+l_x,(i-1)*blocks_matrix.at (i).at (j).surface.height+l_y)
					end
					j:=j+1
				end
				i:=i+1
			end
		end

	wall_kick
			-- Manage the kick of a wall
		do
			if not wall_kick_exhausted then
				wall_kick_index:=wall_kick_index+1
				x:=old_x+wall_kicks_list.at (wall_kick_nb).at (wall_kick_index).x
				y:=old_y+wall_kicks_list.at (wall_kick_nb).at (wall_kick_index).y
				if wall_kick_index+1>wall_kicks_list.at (wall_kick_nb).count then
					wall_kick_exhausted:=true
				end
			end
		end

	wall_kick_index:INTEGER
			-- Manage the number of `wall_kick' managed by `current'

	wall_kick_exhausted:BOOLEAN
			-- Apply a maximum number of `wall_kick' managed by `current'

feature {NONE} -- Implementation - Routines



	blocks_positions_init:ARRAY[TUPLE[row,column:INTEGER]]
			-- The position of the {BLOCK} in `Current'
	deferred
	end


	create_matrix
			-- Generate the {BOLCK} matrix of `Current' using `blocks_positions_init'
		local
			matrix:ARRAYED_LIST[LIST[BLOCK]]
			line:ARRAYED_LIST[BLOCK]
			i,j,k:NATURAL
		do
			create {ARRAYED_LIST[LIST[LIST[BLOCK]]]} list_blocks_matrix.make(4)
			from
				i:=1
			until
				i>4
			loop
				create matrix.make (4)
				from
					j:=1
				until
					j>4
				loop
					create line.make (4)
					from
						k:=1
					until
						k>4
					loop
						line.extend (Void)
						k:=k+1
					end
					matrix.extend (line)
					j:=j+1
				end
				list_blocks_matrix.extend (matrix)
				i:=i+1
			end
		end

	fill_matrix(l_surface:GAME_SURFACE;block_width,block_height:NATURAL;rotation:BOOLEAN)
			-- Show `block_width' by `block_height' {BLOCK} of `Current' on `l_surface'.
			-- If `rotation' is `True', apply a rotation on individual {BLOCK}.
		local
			i:INTEGER
			nb_rotation:INTEGER
		do
			from
				i:=1
			until
				i>16
			loop
				if rotation then
					nb_rotation:=(i-1)//4
				else
					nb_rotation:=0
				end
				list_blocks_matrix.at ((i-1)//4+1).at (blocks_positions_init.at (i).row).at (blocks_positions_init.at (i).column) :=
						create {BLOCK}.make(l_surface.sub_surface (((i-1)\\4)*block_width.to_integer_32, (index-1)*block_height.to_integer_32,
												block_width.to_integer_32, block_height.to_integer_32).surface_rotated_90_degree (nb_rotation))
				i:=i+1
			end
		end

	save_state
		do
			old_x:=x
			old_y:=y
			old_rotation_index:=rotation_index
		end

	init_wall_kicks_list
			-- List used to manage wall kick
		local
			temp_list:ARRAYED_LIST[TUPLE[x,y:INTEGER]]
		do
			create {ARRAYED_LIST[LIST[TUPLE[x,y:INTEGER]]]} wall_kicks_list.make(8)
			create temp_list.make(5)
			temp_list.extend ([0,0])
			temp_list.extend ([-1,0])
			temp_list.extend ([-1,1])
			temp_list.extend ([0,-2])
			temp_list.extend ([-1,-2])
			wall_kicks_list.extend (temp_list)		-- 0->R
			create temp_list.make(5)
			temp_list.extend ([0,0])
			temp_list.extend ([1,0])
			temp_list.extend ([1,-1])
			temp_list.extend ([0,2])
			temp_list.extend ([1,2])
			wall_kicks_list.extend (temp_list)		-- R->2
			create temp_list.make(5)
			temp_list.extend ([0,0])
			temp_list.extend ([1,0])
			temp_list.extend ([1,1])
			temp_list.extend ([0,-2])
			temp_list.extend ([1,-2])
			wall_kicks_list.extend (temp_list)		-- 2->L
			create temp_list.make(5)
			temp_list.extend ([0,0])
			temp_list.extend ([-1,0])
			temp_list.extend ([-1,-1])
			temp_list.extend ([0,2])
			temp_list.extend ([-1,2])
			wall_kicks_list.extend (temp_list)		-- L->0

			wall_kicks_list.extend (wall_kicks_list.at (3))		-- 0->L
			wall_kicks_list.extend (wall_kicks_list.at (2))		-- R->0
			wall_kicks_list.extend (wall_kicks_list.at (1))		-- 2->R
			wall_kicks_list.extend (wall_kicks_list.at (4))		-- L->2


		end




feature {TETROMINO} -- Implementation - Variables

	list_blocks_matrix:LIST[LIST[LIST[BLOCK]]]
			-- List of Matrix of {BLOCK} (one matrix per rotation).

	old_x:INTEGER
			-- Previous horizontal position.
	old_y:INTEGER
			-- Previous vertical position.
	old_rotation_index:INTEGER
			-- Previous rotation index.

	wall_kicks_list:LIST[LIST[TUPLE[x,y:INTEGER]]]
			-- List of wall kick possibility
	wall_kick_nb:INTEGER
			-- Number of wall kick used in `Current'


invariant
	Blocks_Matrix_Valid: list_blocks_matrix /= Void

end
