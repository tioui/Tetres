note
	description: "Summary description for {PLAYFIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYFIELD

create
	make

feature {NONE} -- Initialization

	make(l_x,l_y:INTEGER;l_block_width,l_block_height:NATURAL)
			-- Initialization for `Current'.
		local
			i,j:INTEGER
			line:ARRAYED_LIST[BLOCK]
		do
			x:=l_x
			y:=l_y
			block_height:=l_block_height.to_integer_32
			block_width:=l_block_width.to_integer_32
			create {ARRAYED_LIST[LIST[BLOCK]]} blocks_matrix.make(height.to_integer_32)
			from
				i:=1
			until
				i>height.to_integer_32
			loop
				create line.make (width.to_integer_32)
				from
					j:=1
				until
					j>width.to_integer_32
				loop
					line.extend (Void)
					j:=j+1
				end
				blocks_matrix.extend (line)
				i:=i+1
			end
			create {ARRAYED_LIST[INTEGER]} full_lines_index.make_filled (4)
			nb_full_lines:=0
		end

feature -- Access

	x:INTEGER
	y:INTEGER

	width:NATURAL
		once
			Result:=10
		end

	height:NATURAL
		once
			Result:=20
		end

	freeze_tetromino(l_tetromino:TETROMINO)
		local
			i,j,pos_y,pos_x:INTEGER
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
					pos_y:=l_tetromino.y-(i-1)
					pos_x:=l_tetromino.x+j-1
					if l_tetromino.blocks_matrix.at (i).at (j)/=Void and then pos_y>0 and then pos_y<=height.to_integer_32 and then pos_x>0 and then pos_x<=width.to_integer_32 then
						blocks_matrix.at (pos_y).at (pos_x):=l_tetromino.blocks_matrix.at (i).at (j)
					end
					j:=j+1
				end
				i:=i+1
			end
		end

	print_playfield_with_tetromino(l_tetromino:TETROMINO;l_surface:GAME_SURFACE)
		local

		do
			print_playfield(l_surface)
			print_tetromino(l_tetromino,l_surface)
		end

	print_playfield_with_tetromino_and_ghost(l_tetromino,l_ghost:TETROMINO;l_surface:GAME_SURFACE)
		local

		do
			print_playfield(l_surface)
			print_tetromino(l_ghost,l_surface)
			print_tetromino(l_tetromino,l_surface)
		end

	print_playfield(l_surface:GAME_SURFACE)
		local
			i,j:INTEGER
		do
			from
				i:=1
			until
				i>height.to_integer_32
			loop
				from
					j:=1
				until
					j>width.to_integer_32
				loop
					if blocks_matrix.at (i).at (j)/=Void then
						l_surface.print_surface_on_surface (blocks_matrix.at (i).at (j).surface, (j-1)*block_width+x, (height.to_integer_32-i)*block_height+y)
					end
					j:=j+1
				end
				i:=i+1
			end
		end

	print_tetromino(l_tetromino:TETROMINO;l_surface:GAME_SURFACE)
		local
			i,j,pos_y,pos_x:INTEGER
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
					pos_y:=l_tetromino.y-(i-1)
					pos_x:=j+l_tetromino.x-1
					if l_tetromino.blocks_matrix.at (i).at (j)/=Void and then pos_x>0 and then pos_x<=width.to_integer_32 and then pos_y>0 and then pos_y<=height.to_integer_32 then
						l_surface.print_surface_on_surface (l_tetromino.blocks_matrix.at (i).at (j).surface,(pos_x-1)*block_width+x,(height.to_integer_32-pos_y)*block_height+y)
					end
					j:=j+1
				end
				i:=i+1
			end
		end

	detect_collision(l_tetromino:TETROMINO):BOOLEAN
		local
			i,j,pos_y,pos_x:INTEGER
		do
			Result:=false
			from
				i:=1
			until
				i>4 or else
				Result=true
			loop
				from
					j:=1
				until
					j>4 or else
					Result=true
				loop
					pos_y:=l_tetromino.y-(i-1)
					pos_x:=l_tetromino.x+j-1
					if 	l_tetromino.blocks_matrix.at (i).at (j)/=Void and then
							((pos_y<1) or else (pos_x>width.to_integer_32) or else (pos_x<1) or else
							((pos_y<=height.to_integer_32) and then blocks_matrix.at (pos_y).at (pos_x)/=Void)) then
						Result:=true
					end
					j:=j+1
				end
				i:=i+1
			end
		end

	check_full_lines
		local
			i,j:INTEGER
			is_hole:BOOLEAN
		do
			nb_full_lines:=0
			from
				i:=1
			until
				i>height.to_integer_32
			loop

				from
					j:=1
					is_hole:=false
				until
					is_hole or else
					j>width.to_integer_32
				loop
					if blocks_matrix.at (i).at (j)=Void then
						is_hole:=true
					end
					j:=j+1
				end
				if not is_hole then
					nb_full_lines:=nb_full_lines+1
					full_lines_index.at (nb_full_lines):=i
				end
				i:=i+1
			end
		end

	delete_full_line
		local
			i,j:INTEGER
			line:ARRAYED_LIST[BLOCK]
		do
			from
				i:=nb_full_lines
			until
				i<1
			loop
				blocks_matrix.go_i_th (full_lines_index.at (i))
				blocks_matrix.remove
				create line.make (width.to_integer_32)
				from
					j:=1
				until
					j>width.to_integer_32
				loop
					line.extend (Void)
					j:=j+1
				end
				blocks_matrix.extend (line)
				i:=i-1
			end
			nb_full_lines:=0
		end

	blocks_matrix:LIST[LIST[BLOCK]]

	nb_full_lines:INTEGER

	full_lines_index:LIST[INTEGER]

feature {NONE} -- Implementation - Routine



feature {NONE} -- Implementation - Variables

	block_width:INTEGER
	block_height:INTEGER

end
