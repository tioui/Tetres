note
	description: "Summary description for {TETRIS_CONTROLLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TETRIS_CONTROLLER

create
	make

feature {NONE} -- Initialization

	make(l_init_ctrl:INIT_CONTROLLER; l_theme_ctrl:THEME_CONTROLLER; l_lib_ctrl:GAME_LIB_CONTROLLER)
			-- Initialization for `Current'.
		do
			init_ctrl:=l_init_ctrl
			theme_ctrl:=l_theme_ctrl
			lib_ctrl:=l_lib_ctrl
			event_controller:=l_lib_ctrl.event_controller
			create blocks_surface.make (l_theme_ctrl.blocks_file_name)
			screen_surface:=lib_ctrl.screen_surface
			create bg_surface.make (theme_ctrl.bg_file_name)

			create tetrominos_fact.make (blocks_surface, theme_ctrl.block_width, theme_ctrl.block_height)
			if init_ctrl.is_ghost_show then
				create tetrominos_fact_ghost.make_with_alpha (blocks_surface, theme_ctrl.block_width, theme_ctrl.block_height,theme_ctrl.ghost_alpha)
			end
			create pfield.make (theme_ctrl.playfield_x.to_integer_32, theme_ctrl.playfield_y.to_integer_32, theme_ctrl.block_width, theme_ctrl.block_height)
			create rnd_bag.make(lib_ctrl,1,7)
			init_currents_tetrominos
			is_init:=false
			create font.make (theme_ctrl.font_file_name, theme_ctrl.font_size)
			is_game_over:=false
			create mem
			create text_color.make_from_hex_string_rgb (theme_ctrl.font_color)
			event_controller.on_key_down.extend (agent on_key_press)
			event_controller.on_key_up.extend (agent on_key_up)
			event_controller.on_tick.extend(agent on_tick)
			event_controller.on_quit_signal.extend(agent on_quit)
			down_delay:=1000
			is_hold_used:=false
			nb_lines:=0
			points:=0
		end

feature -- Access

	launch
		do
			lib_ctrl.launch
		end

	resume
		do
			lib_ctrl.replace_event_controller (event_controller)
		end

	is_game_over:BOOLEAN

	last_image_surface:GAME_SURFACE



feature {NONE} -- Implementation - Routines

	on_tick(nb_tick:NATURAL_32)
		do
			if not is_init then
				down_tick_number:=lib_ctrl.get_ticks
				is_init:=true
			elseif down_pressed and then lib_ctrl.get_ticks>down_tick_number+30 then
				down_tick_number:=lib_ctrl.get_ticks
				go_down
			elseif lib_ctrl.get_ticks>down_tick_number+down_delay then
				down_tick_number:=lib_ctrl.get_ticks
				go_down
			elseif left_pressed and then lib_ctrl.get_ticks>move_tick_number+move_delay then
				move_tick_number:=lib_ctrl.get_ticks
				move_delay:=30
				move_left
			elseif right_pressed and then lib_ctrl.get_ticks>move_tick_number+move_delay then
				move_tick_number:=lib_ctrl.get_ticks
				move_delay:=30
				move_right
			end

			update_screen
		end

	on_quit
		do
			lib_ctrl.stop
			create last_image_surface.make (screen_surface.width, screen_surface.height, screen_surface.bits_per_pixel, false)
			last_image_surface.print_surface_on_surface (bg_surface, 0, 0)
			if theme_ctrl.score_show then
				print_score(last_image_surface)
			end
			if theme_ctrl.lines_show then
				print_lines(last_image_surface)
			end
			if theme_ctrl.level_show then
				print_level(last_image_surface)
			end
		end

	on_key_press(keyboard_event:GAME_KEYBOARD_EVENT)
		local
			old_tetromino:TETROMINO
		do
			if keyboard_event.is_left_key then
				move_left
				move_delay:=300
				move_tick_number:=lib_ctrl.get_ticks
				left_pressed:=true
			elseif keyboard_event.is_right_key then
				move_right
				move_delay:=300
				move_tick_number:=lib_ctrl.get_ticks
				right_pressed:=true
			elseif keyboard_event.is_down_key then
				down_pressed:=true
			elseif keyboard_event.is_a_key then
				rotate_left
			elseif keyboard_event.is_s_key then
				rotate_right
			elseif keyboard_event.is_up_key then
				from
					old_tetromino:=currents_tetrominos.first
				until
					old_tetromino/=currents_tetrominos.first
				loop
					go_down
				end
			elseif keyboard_event.is_escape_key then
				on_quit
			elseif keyboard_event.is_tab_key then
				if theme_ctrl.hold_field_show then
					hold_tetromino
				end

			end
			update_screen
		end

	on_key_up(keyboard_event:GAME_KEYBOARD_EVENT)
		do
			if keyboard_event.is_left_key then
				left_pressed:=false
			elseif keyboard_event.is_right_key then
				right_pressed:=false
			elseif keyboard_event.is_down_key then
				down_pressed:=false
			end
		end

	rotate_left
		do
			currents_tetrominos.first.rotate_left
			if pfield.detect_collision (currents_tetrominos.first) then
				currents_tetrominos.first.cancel_last_move
			end
			update_ghost
		end

	rotate_right
		do
			currents_tetrominos.first.rotate_right
			if pfield.detect_collision (currents_tetrominos.first) then
				currents_tetrominos.first.cancel_last_move
			end
			update_ghost
		end

	move_left
		do
			currents_tetrominos.first.move_left
			if pfield.detect_collision (currents_tetrominos.first) then
				currents_tetrominos.first.cancel_last_move
			end
			update_ghost
		end

	move_right
		do
			currents_tetrominos.first.move_right
			if pfield.detect_collision (currents_tetrominos.first) then
				currents_tetrominos.first.cancel_last_move
			end
			update_ghost
		end

	go_down
		do
			currents_tetrominos.first.go_down
			if pfield.detect_collision (currents_tetrominos.first) then
				currents_tetrominos.first.cancel_last_move
				pfield.freeze_tetromino (currents_tetrominos.first)
				valid_lines
				change_current_tetromino
			end
		end

	valid_lines
		local
			new_delay:INTEGER
		do
			pfield.check_full_lines
			if pfield.nb_full_lines/=0 then
				if pfield.nb_full_lines=1 then
					points:=points+100*level
				elseif pfield.nb_full_lines=2 then
					points:=points+300*level
				elseif pfield.nb_full_lines=3 then
					points:=points+500*level
				else
					points:=points+800*level
				end
				if points>999999999 then
					points:=999999999
				end
				nb_lines:=nb_lines+pfield.nb_full_lines
				if nb_lines>999999999 then
					nb_lines:=999999999
				end
				new_delay:=1050-(50*level)
				if new_delay<=0 then
					new_delay:=1
				end
				down_delay:=new_delay.to_natural_32
				pfield.delete_full_line
				mem.full_collect
			end
		end

	update_ghost
		do
			if init_ctrl.is_ghost_show then
				from
					current_tetromino_ghost.copy_state_from_other (currents_tetrominos.first)
				until
					pfield.detect_collision (current_tetromino_ghost)
				loop
					current_tetromino_ghost.go_down
				end
				current_tetromino_ghost.cancel_last_move
			end

		end

	hold_tetromino
		local
			swap_tetromino:TETROMINO
		do
			if not is_hold_used then
				if holded_tetromino=Void then
					holded_tetromino:=currents_tetrominos.first
					holded_tetromino.default_state
					change_current_tetromino
				else
					down_pressed:=false
					swap_tetromino:=holded_tetromino
					holded_tetromino:=currents_tetrominos.first
					currents_tetrominos.start
					currents_tetrominos.replace (swap_tetromino)
					holded_tetromino.default_state
					if init_ctrl.is_ghost_show then
						current_tetromino_ghost:=tetrominos_fact_ghost.get_tetromino_by_index (currents_tetrominos.first.index)
					end
				end
			end
			is_hold_used:=true
		end

	change_current_tetromino
		local
			new_tetromino_index:INTEGER
		do
			is_hold_used:=false
			down_pressed:=false
			rnd_bag.pick
			new_tetromino_index:=rnd_bag.get_last_pick
			currents_tetrominos.start
			currents_tetrominos.remove
			currents_tetrominos.extend (tetrominos_fact.get_tetromino_by_index (new_tetromino_index))
			if init_ctrl.is_ghost_show then
				current_tetromino_ghost:=tetrominos_fact_ghost.get_tetromino_by_index (currents_tetrominos.first.index)
			end
			if pfield.detect_collision (currents_tetrominos.first) then
				game_over
			end
		end

	init_currents_tetrominos
		local
			new_tetromino_index,i,nb_next:INTEGER
		do
			if not theme_ctrl.next_field_show then
				nb_next:=1
			else
				nb_next:=theme_ctrl.next_field_nb+1
			end
			create {LINKED_LIST[TETROMINO]} currents_tetrominos.make
			from
				i:=1
			until
				i>nb_next
			loop
				rnd_bag.pick
				new_tetromino_index:=rnd_bag.get_last_pick
				currents_tetrominos.extend (tetrominos_fact.get_tetromino_by_index (new_tetromino_index))
				i:=i+1
			end
			if init_ctrl.is_ghost_show then
				current_tetromino_ghost:=tetrominos_fact_ghost.get_tetromino_by_index (currents_tetrominos.first.index)
			end
		end

	update_screen
		do
			screen_surface.print_surface_on_surface (bg_surface, 0, 0)
			if init_ctrl.is_ghost_show then
				update_ghost
				pfield.print_playfield_with_tetromino_and_ghost (currents_tetrominos.first,current_tetromino_ghost, screen_surface)
			else
				pfield.print_playfield_with_tetromino (currents_tetrominos.first,screen_surface)
			end
			if theme_ctrl.hold_field_show and holded_tetromino/=Void then
				holded_tetromino.print_on_surface (screen_surface, theme_ctrl.hold_field_x, theme_ctrl.hold_field_y)
			end
			if theme_ctrl.next_field_show then
				print_next_field
			end
			if theme_ctrl.score_show then
				print_score(screen_surface)
			end
			if theme_ctrl.lines_show then
				print_lines(screen_surface)
			end
			if theme_ctrl.level_show then
				print_level(screen_surface)
			end
			lib_ctrl.flip_screen
		end

	print_level(target_surface:GAME_SURFACE)
		local
			text:GAME_SURFACE_TEXT
		do
			create text.make_blended (level.out, font, text_color)
			target_surface.print_surface_on_surface (text, theme_ctrl.level_x, theme_ctrl.level_y)
		end

	print_lines(target_surface:GAME_SURFACE)
		local
			text:GAME_SURFACE_TEXT
		do
			create text.make_blended (nb_lines.out, font, text_color)
			target_surface.print_surface_on_surface (text, theme_ctrl.lines_x+(theme_ctrl.lines_w - text.width)//2, theme_ctrl.lines_y)
		end

	print_score(target_surface:GAME_SURFACE)
		local
			text:GAME_SURFACE_TEXT
		do
			create text.make_blended (points.out, font, text_color)
			target_surface.print_surface_on_surface (text, theme_ctrl.score_x+(theme_ctrl.score_w - text.width)//2, theme_ctrl.score_y)
		end

	print_next_field
		local
			pos:INTEGER
		do
			from
				pos:=0
				currents_tetrominos.start
				currents_tetrominos.forth
			until currents_tetrominos.exhausted
			loop
				if theme_ctrl.next_field_vertical then
					currents_tetrominos.item.print_on_surface (screen_surface, theme_ctrl.next_field_x, theme_ctrl.next_field_y+pos)
					pos:=pos+theme_ctrl.block_width.to_integer_32*2+theme_ctrl.next_field_padding
					currents_tetrominos.forth
				else
					currents_tetrominos.item.print_on_surface (screen_surface, theme_ctrl.next_field_x+pos, theme_ctrl.next_field_y)
					if currents_tetrominos.item.index=1 then
						pos:=pos+theme_ctrl.block_width.to_integer_32*4+theme_ctrl.next_field_padding
					else
						pos:=pos+theme_ctrl.block_width.to_integer_32*3+theme_ctrl.next_field_padding
					end
					currents_tetrominos.forth
				end

			end
			currents_tetrominos.start
		end

	game_over
		do
			update_screen
			lib_ctrl.stop
			is_game_over:=true
			create last_image_surface.make (screen_surface.width, screen_surface.height, lib_ctrl.screen_surface.bits_per_pixel, false)
			last_image_surface.print_surface_on_surface (screen_surface, 0, 0)
		end


	level:INTEGER
		do
			Result:=(nb_lines//10)+1
		end

feature {NONE} -- Implementation - Variables


	mem:MEMORY
	init_ctrl:INIT_CONTROLLER
	theme_ctrl:THEME_CONTROLLER
	lib_ctrl:GAME_LIB_CONTROLLER
	event_controller:GAME_EVENT_CONTROLLER
	rnd_bag:RANDOM_BAG
	blocks_surface:GAME_SURFACE_IMG_FILE
	bg_surface:GAME_SURFACE_IMG_FILE
	screen_surface:GAME_SURFACE
	tetrominos_fact:TETROMINOS_FACTORY
	tetrominos_fact_ghost:TETROMINOS_FACTORY
	pfield:PLAYFIELD
	is_init:BOOLEAN
	is_hold_used:BOOLEAN

	current_tetromino_ghost:TETROMINO
	currents_tetrominos:LINKED_LIST[TETROMINO]
	holded_tetromino:TETROMINO
	left_pressed,right_pressed,down_pressed:BOOLEAN

	down_tick_number:NATURAL
	move_tick_number:NATURAL

	down_delay:NATURAL
	move_delay:NATURAL

	nb_lines:INTEGER

	points:INTEGER

	font:GAME_FONT
	text_color:GAME_COLOR





end
