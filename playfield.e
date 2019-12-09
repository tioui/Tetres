note
	description : "Manage the playing area of the game."
	author      : "Louis Marchand"
	date        : "July 19 2012"
	revision    : "1.0"

class
	PLAYFIELD

create
	make,
	make_with_anim

feature {NONE} -- Initialization

	make(l_x,l_y:INTEGER;l_block_width,l_block_height:NATURAL)
			-- Initialization for `Current' starting at (`l_x',`l_y') and
			-- of dimension `l_block_width' by `l_block_height' blocks.
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
			-- Initialization for `Current' starting at (`l_x',`l_y') and
			-- of dimension `l_block_width' by `l_block_height' blocks,
			-- used for automatic animation on `l_anim_surface' with
			-- `l_max_anim_value' maximum update of the `Current'.
		do
			make(l_x,l_y,l_block_width,l_block_height)
			anim_surface:=l_anim_surface
			is_anim_enable:=true
			max_anim_value:=l_max_anim_value
			med_anim_value:=max_anim_value//2
		end

feature -- Access

	x:INTEGER
			-- Horizontal coordinate of `Current'
	y:INTEGER
			-- Vertical coordinate of `Current'

	width:NATURAL
			-- The horizontal dimension of `Current'
		once
			Result:=10
		end

	height:NATURAL
			-- The vertical dimension of `Current'
		once
			Result:=20
		end

	freeze_tetromino(l_tetromino:TETROMINO)
			-- When `l_tetromino' is place on `Current', freeze it if
			-- it cannot move anymore.
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
			-- Show `Current' and the `l_tetromino' on `l_surface'
		local

		do
			print_playfield(l_surface)
			print_tetromino(l_tetromino,l_surface)
		end

	print_playfield_with_tetromino_and_ghost(l_tetromino,l_ghost:TETROMINO;l_surface:GAME_SURFACE)
			-- Show `Current', the `l_tetromino' and the tetromino `l_ghost' on `l_surface'
		local

		do
			print_playfield(l_surface)
			print_tetromino(l_ghost,l_surface)
			print_tetromino(l_tetromino,l_surface)
		end

	print_playfield_with_anim (l_surface: GAME_SURFACE;value:NATURAL)
			-- Show the `value' iteration of the automatic animation
			-- of `Current' in `l_surface'
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
						l_surface.draw_sub_surface (anim_list.item.surface, 0, 0, x, (height.to_integer_32-anim_list.item.line)*block_height+y, ((anim_list.item.surface.width.to_natural_32//med_anim_value)*value).to_integer_32, anim_list.item.surface.height)
					else
						temp_x:=((anim_list.item.surface.width.to_natural_32//med_anim_value)*(value-med_anim_value)).to_integer_32
						l_surface.draw_sub_surface (anim_list.item.surface, temp_x, 0, x+temp_x, (height.to_integer_32-anim_list.item.line)*block_height+y, anim_list.item.surface.width-temp_x, anim_list.item.surface.height)
					end

					anim_list.forth
				end
			end

		end

	print_playfield(l_surface:GAME_SURFACE)
			-- Show `Current' on `l_surface'
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
						l_surface.draw_surface (blocks_matrix.at (i).at (j).surface, (j-1)*block_width+x, (height.to_integer_32-i)*block_height+y)
					end
					j:=j+1
				end
				i:=i+1
			end
		end

	print_tetromino(l_tetromino:TETROMINO;l_surface:GAME_SURFACE)
			-- Show `l_tetromino' on `l_surface'
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
						l_surface.draw_surface (l_tetromino.blocks_matrix.at (i).at (j).surface,(pos_x-1)*block_width+x,(height.to_integer_32-pos_y)*block_height+y)
					end
					j:=j+1
				end
				i:=i+1
			end
		end

	detect_collision(l_tetromino:TETROMINO):BOOLEAN
			-- `True' if `l_tetromino' has a collision with a {TETROMINO} of `Current' or
			-- The edge of `Current'
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
			-- Remove every block of a single line of `Current' if this one is
			-- full.
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
			-- Detect full lines of {BOLCK} and animate the suppression of this line.
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
			-- Prepare the animation of the suppression of a full line of {BLOCK}
		require
			Prepare_Anim_Enable: is_anim_enable
		do
			create {LINKED_LIST[TUPLE[surface:GAME_SURFACE;line:INTEGER]]} anim_List.make
			if nb_full_lines=1 then
				anim_list.extend ([anim_surface.sub_surface (0, 0, block_width*width.to_integer_32, block_height),full_lines_index.first])
			elseif nb_full_lines=2 then
				if full_lines_index.at (1)+1=full_lines_index.at (2) then
					anim_list.extend ([anim_surface.sub_surface (0, block_height, block_width*width.to_integer_32, block_height*2),full_lines_index.at(2)])
				else
					anim_list.extend ([anim_surface.sub_surface (0, block_height*3, block_width*width.to_integer_32, block_height),full_lines_index.at(2)])
					anim_list.extend ([anim_surface.sub_surface (0, block_height*4, block_width*width.to_integer_32, block_height),full_lines_index.at(1)])
				end
			elseif nb_full_lines=3 then
				if full_lines_index.at (1)+2=full_lines_index.at (3) then
					anim_list.extend ([anim_surface.sub_surface (0, block_height*5, block_width*width.to_integer_32, block_height*3),full_lines_index.at(3)])
				elseif full_lines_index.at (1)+1=full_lines_index.at (2) then
					anim_list.extend ([anim_surface.sub_surface (0, block_height*8, block_width*width.to_integer_32, block_height),full_lines_index.at(3)])
					anim_list.extend ([anim_surface.sub_surface (0, block_height*9, block_width*width.to_integer_32, block_height*2),full_lines_index.at(2)])
				else
					anim_list.extend ([anim_surface.sub_surface (0, block_height*11, block_width*width.to_integer_32, block_height*2),full_lines_index.at(3)])
					anim_list.extend ([anim_surface.sub_surface (0, block_height*13, block_width*width.to_integer_32, block_height),full_lines_index.at(1)])
				end
			elseif nb_full_lines=4 then
				anim_list.extend ([anim_surface.sub_surface (0, block_height*14, block_width*width.to_integer_32, block_height*4),full_lines_index.last])
			end
		end

	clear_anim
			-- Stop the `Current' full line animation.
		require
			Clear_Anim_Enable: is_anim_enable
		do
			anim_List:=Void
		end

	blocks_matrix:LIST[LIST[BLOCK]]
			-- Every fixed {BOLCK} of `Current'

	nb_full_lines:INTEGER
			-- The number of line full of {BLOCK}

	full_lines_index:LIST[INTEGER]
			-- The indexes of every lines full of {BLOCK}

	is_anim_enable:BOOLEAN
			-- Is `Current' performing an automatic animation

	anim_List:LIST[TUPLE[surface:GAME_SURFACE;line:INTEGER]]
			-- The list of line to show in the automatic animation of `Current'

	max_anim_value:NATURAL
			-- Maximum number of iteration to show `Current'
	med_anim_value:NATURAL
			-- Medium number of iteration to show `Current'

feature {NONE} -- Implementation - Variables

	block_width:INTEGER
			-- The number of {BLOCK} in a line of `Current'
	block_height:INTEGER
			-- The number of {BLOCK} in a column of `Current'

	anim_surface:GAME_SURFACE
			-- The image used to draw `Current' when on automatic animation





end
