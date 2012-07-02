note
	description: "Summary description for {TETROMINO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TETROMINO

feature {NONE} -- Initialisation

	make(l_surface:GAME_SURFACE;l_index:NATURAL_8;block_width,block_height:NATURAL)
		local

		do
			index:=l_index
			default_state
			create_matrix
			fill_matrix(l_surface,block_width,block_height)
		end

	make_from_other(other:TETROMINO)
		do
			index:=other.index
			list_blocks_matrix:=other.list_blocks_matrix
			copy_state_from_other(other)
		end

feature -- Access

	index:NATURAL_8

	rotation_index:INTEGER

	blocks_matrix:LIST[LIST[BLOCK]]
		do
			Result:=list_blocks_matrix.at (rotation_index+1)
		end

	rotate_left
		do
			save_state
			rotation_index:=(rotation_index+3)\\4
		end

	rotate_right
		do
			save_state
			rotation_index:=(rotation_index+1)\\4
		end

	move_left
		do
			save_state
			x:=x-1
		end

	move_right
		do
			save_state
			x:=x+1
		end

	go_down
		do
			save_state
			y:=y-1
		end

	x:INTEGER

	y:INTEGER

	cancel_last_move
		do
			x:=old_x
			y:=old_y
			rotation_index:=old_rotation_index
		end

	set_ghost_effect(alpha_value:NATURAL_8)
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
		require
			Tetromino_Copy_State_Same_Tetromino: other.index=index
		do
			x:=other.x
			y:=other.y
			rotation_index:=other.rotation_index
		end

	default_state
		do
			rotation_index:=0
			x:=4
			y:=20
		end

	print_on_surface(l_surface:GAME_SURFACE;l_x,l_y:INTEGER)
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
						l_surface.print_surface_on_surface (blocks_matrix.at (i).at (j).surface,(j-1)*blocks_matrix.at (i).at (j).surface.width+l_x,(i-1)*blocks_matrix.at (i).at (j).surface.height+l_y)
					end
					j:=j+1
				end
				i:=i+1
			end
		end

feature {NONE} -- Implementation - Routines



	blocks_positions_init:ARRAY[TUPLE[row,column:INTEGER]]
	deferred
	end


	create_matrix
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

	fill_matrix(l_surface:GAME_SURFACE;block_width,block_height:NATURAL)
		local
			i:INTEGER
		do
			from
				i:=1
			until
				i>16
			loop
				list_blocks_matrix.at ((i-1)//4+1).at (blocks_positions_init.at (i).row).at (blocks_positions_init.at (i).column) :=
						create {BLOCK}.make(l_surface.get_sub_surface (((i-1)\\4)*block_width.to_integer_32, (index-1)*block_height.to_integer_32,
												block_width.to_integer_32, block_height.to_integer_32).get_new_surface_rotate_90_degree ((i-1)//4))
				i:=i+1
			end
		end

	save_state
		do
			old_x:=x
			old_y:=y
			old_rotation_index:=rotation_index
		end




feature {TETROMINO} -- Implementation - Variables

	list_blocks_matrix:LIST[LIST[LIST[BLOCK]]]

	old_x:INTEGER
	old_y:INTEGER
	old_rotation_index:INTEGER


invariant
	Blocks_Matrix_Valid: list_blocks_matrix /= Void

end
