note
	description: "Summary description for {PLAYFIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYFIELD

create
	make,
	make_with_anim

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
			is_anim_enable:=false
		end

	make_with_anim(l_x,l_y:INTEGER;l_block_width,l_block_height:NATURAL;l_anim_surface:GAME_SURFACE;l_max_anim_value:NATURAL)
		do
			make(l_x,l_y,l_block_width,l_block_height)
			anim_surface:=l_anim_surface
			is_anim_enable:=true
			max_anim_value:=l_max_anim_value
			med_anim_value:=max_anim_value//2
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

	print_playfield_with_anim (l_surface: GAME_SURFACE;value:NATURAL)
		require
			Print_Playfield_With_Anim_Precent_Valid: value<=max_anim_value
			Print_Playfield_With_Anim_List_Not_Void: anim_List/=Void
			Print_Playfield_With_Anim_Enable: is_anim_enable
		local
			temp_x:INTEGER
		do
			print_playfield(l_surface)
			if value>0 and value<max_anim_value then
				from
					anim_list.start
				until
					anim_list.exhausted
				loop
					if value<med_anim_value then
						l_surface.print_surface_part_on_surface (anim_list.item.surface, 0, 0, x, (height.to_integer_32-anim_list.item.line)*block_height+y, ((anim_list.item.surface.width.to_natural_32//med_anim_value)*value).to_integer_32, anim_list.item.surface.height)
					else
						temp_x:=((anim_list.item.surface.width.to_natural_32//med_anim_value)*(value-med_anim_value)).to_integer_32
						l_surface.print_surface_part_on_surface (anim_list.item.surface, temp_x, 0, x+temp_x, (height.to_integer_32-anim_list.item.line)*block_height+y, anim_list.item.surface.width-temp_x, anim_list.item.surface.height)
					end

					anim_list.forth
				end
			end

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

	remove_full_lines_block
		local
			i:INTEGER
		do
			from
				i:=1
			until
				i>nb_full_lines
			loop
				blocks_matrix.go_i_th (full_lines_index.at (i))
				from
					blocks_matrix.item.start
				until
					blocks_matrix.item.exhausted
				loop
					blocks_matrix.item.replace (Void)
					blocks_matrix.item.forth
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

		prepare_anim
		require
			Prepare_Anim_Enable: is_anim_enable
		do
			create {LINKED_LIST[TUPLE[surface:GAME_SURFACE;line:INTEGER]]} anim_List.make
			if nb_full_lines=1 then
				anim_list.extend ([anim_surface.get_sub_surface (0, 0, block_width*width.to_integer_32, block_height),full_lines_index.first])
			elseif nb_full_lines=2 then
				if full_lines_index.at (1)+1=full_lines_index.at (2) then
					anim_list.extend ([anim_surface.get_sub_surface (0, block_height, block_width*width.to_integer_32, block_height*2),full_lines_index.at(2)])
				else
					anim_list.extend ([anim_surface.get_sub_surface (0, block_height*3, block_width*width.to_integer_32, block_height),full_lines_index.at(2)])
					anim_list.extend ([anim_surface.get_sub_surface (0, block_height*4, block_width*width.to_integer_32, block_height),full_lines_index.at(1)])
				end
			elseif nb_full_lines=3 then
				if full_lines_index.at (1)+2=full_lines_index.at (3) then
					anim_list.extend ([anim_surface.get_sub_surface (0, block_height*5, block_width*width.to_integer_32, block_height*3),full_lines_index.at(3)])
				elseif full_lines_index.at (1)+1=full_lines_index.at (2) then
					anim_list.extend ([anim_surface.get_sub_surface (0, block_height*8, block_width*width.to_integer_32, block_height),full_lines_index.at(3)])
					anim_list.extend ([anim_surface.get_sub_surface (0, block_height*9, block_width*width.to_integer_32, block_height*2),full_lines_index.at(2)])
				else
					anim_list.extend ([anim_surface.get_sub_surface (0, block_height*11, block_width*width.to_integer_32, block_height*2),full_lines_index.at(3)])
					anim_list.extend ([anim_surface.get_sub_surface (0, block_height*13, block_width*width.to_integer_32, block_height),full_lines_index.at(1)])
				end
			elseif nb_full_lines=4 then
				anim_list.extend ([anim_surface.get_sub_surface (0, block_height*14, block_width*width.to_integer_32, block_height*4),full_lines_index.last])
			end
		end

	clear_anim
		require
			Clear_Anim_Enable: is_anim_enable
		do
			anim_List:=Void
		end

	blocks_matrix:LIST[LIST[BLOCK]]

	nb_full_lines:INTEGER

	full_lines_index:LIST[INTEGER]

	is_anim_enable:BOOLEAN

	anim_List:LIST[TUPLE[surface:GAME_SURFACE;line:INTEGER]]

	max_anim_value:NATURAL
	med_anim_value:NATURAL

feature {NONE} -- Implementation - Routine



feature {NONE} -- Implementation - Variables

	block_width:INTEGER
	block_height:INTEGER

	anim_surface:GAME_SURFACE





end
