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

	make(l_init_ctrl:INIT_CONTROLLER; l_theme_ctrl:THEME_CONTROLLER; l_lib_ctrl:GAME_LIB_CONTROLLER;l_audio_ctrl:AUDIO_CONTROLLER)
			-- Initialization for `Current'.
		local
			anim_surface:GAME_SURFACE_IMG_FILE
			music:AUDIO_SOUND_SND_FILE
		do
			init_ctrl:=l_init_ctrl
			theme_ctrl:=l_theme_ctrl
			lib_ctrl:=l_lib_ctrl
			audio_ctrl:=l_audio_ctrl
			event_controller:=l_lib_ctrl.event_controller
			create blocks_surface.make (l_theme_ctrl.blocks_file_name)
			screen_surface:=lib_ctrl.screen_surface
			create bg_surface.make (theme_ctrl.bg_file_name)
			create tetrominos_fact.make (blocks_surface, theme_ctrl.block_width, theme_ctrl.block_height,theme_ctrl.block_rotation)
			if init_ctrl.is_ghost_show then
				create tetrominos_fact_ghost.make_with_alpha (blocks_surface, theme_ctrl.block_width, theme_ctrl.block_height,theme_ctrl.block_rotation,theme_ctrl.ghost_alpha)
			end
			if theme_ctrl.lines_anim_show then
				create anim_surface.make (theme_ctrl.lines_anim_file_name)
				create pfield.make_with_anim (theme_ctrl.playfield_x.to_integer_32, theme_ctrl.playfield_y.to_integer_32, theme_ctrl.block_width, theme_ctrl.block_height,anim_surface,theme_ctrl.lines_anim_delay)
			else
				create pfield.make (theme_ctrl.playfield_x.to_integer_32, theme_ctrl.playfield_y.to_integer_32, theme_ctrl.block_width, theme_ctrl.block_height)
			end

			create rnd_bag.make(lib_ctrl,1,7)
			init_currents_tetrominos
			is_init:=false
			create font.make (theme_ctrl.font_file_name, theme_ctrl.font_size)
			is_game_over:=false
			create mem
			create text_color.make_from_hex_string_rgb (theme_ctrl.font_color)
			if init_ctrl.custom_control_enable then
				if init_ctrl.custom_control_ctrl.keyboard_enable then
					event_controller.on_key_down.extend (agent custom_keyboard_press)
					event_controller.on_key_up.extend (agent custom_keyboard_up)
				end
				if init_ctrl.custom_control_ctrl.joystick_enable then
					event_controller.enable_joystick_event
					if init_ctrl.custom_control_ctrl.joystick_buttons_enable then
						event_controller.on_joystick_button_pressed.extend (agent custom_joystick_button_press)
						event_controller.on_joystick_button_released.extend (agent custom_joystick_button_release)
					end
					if init_ctrl.custom_control_ctrl.joystick_axis_enable then
						event_controller.on_joystick_axis_change.extend (agent custom_joystick_axis_change)
					end
				end

			else
				event_controller.on_key_down.extend (agent default_key_press)
				event_controller.on_key_up.extend (agent on_key_up)
			end
			event_controller.on_iteration.extend(agent on_iteration)
			event_controller.on_quit_signal.extend(agent on_quit)
			play_sound:=theme_ctrl.is_sound_enable
			if play_sound then
				audio_ctrl.add_source
				sound_source:=audio_ctrl.last_source
				if theme_ctrl.is_sound_game_drop then
					create {AUDIO_SOUND_SND_FILE} sound_drop.make(theme_ctrl.sound_game_drop_file)
				end
				if theme_ctrl.is_sound_game_rotation then
					create {AUDIO_SOUND_SND_FILE} sound_rotation.make(theme_ctrl.sound_game_rotation_file)
				end
				if theme_ctrl.is_sound_game_move then
					create {AUDIO_SOUND_SND_FILE} sound_move.make(theme_ctrl.sound_game_move_file)
				end
				if theme_ctrl.is_sound_game_down then
					create {AUDIO_SOUND_SND_FILE} sound_down.make(theme_ctrl.sound_game_down_file)
				end
				if theme_ctrl.is_sound_game_anim then
					create {AUDIO_SOUND_SND_FILE} sound_anim.make(theme_ctrl.sound_game_anim_file)
				end
				if theme_ctrl.is_sound_game_collapse then
					create {AUDIO_SOUND_SND_FILE} sound_collapse.make(theme_ctrl.sound_game_collapse_file)
				end
				if theme_ctrl.is_music_game then
					audio_ctrl.add_source
					music_source:=audio_ctrl.last_source
					if theme_ctrl.is_music_game_intro then
						create music.make (theme_ctrl.music_game_intro_file)
						music_source.queue_sound (music)
					end
					create music.make (theme_ctrl.music_game_loop_file)
					music_source.queue_sound_infinite_loop (music)
					music_source.play
				end
			end
			down_delay:=1000
			is_hold_used:=false
			nb_lines:=0
			points:=0
			anim_in_progress:=false
			if theme_ctrl.score_show then
				create score_surface.make_blended (points.out, font, text_color)
			end
			if theme_ctrl.lines_show then
				create lines_surface.make_blended (nb_lines.out, font, text_color)
			end
			if theme_ctrl.level_show then
				create level_surface.make_blended (level.out, font, text_color)
			end
		end

feature -- Access

	launch
		do
			lib_ctrl.launch
		end

	resume
		do
			lib_ctrl.replace_event_controller (event_controller)
			left_pressed:=false
			right_pressed:=false
			down_pressed:=false
			rotate_left_pressed:=false
			rotate_right_pressed:=false
			drop_pressed:=false
			pause_pressed:=false
			hold_pressed:=false
			if play_sound then
				if sound_source.is_pause then
					sound_source.play
				end
				music_source.play
			end

		end

	is_game_over:BOOLEAN

	last_image_surface:GAME_SURFACE



feature {NONE} -- Implementation - Routines

	on_iteration
		do
			if anim_in_progress then
				cont_anim
			else
				if not is_init then
					down_tick_number:=lib_ctrl.get_ticks
					is_init:=true
					update_screen
				elseif down_pressed and then lib_ctrl.get_ticks>down_tick_number+30 then
					down_tick_number:=lib_ctrl.get_ticks
					go_down(true)
					update_screen
				elseif lib_ctrl.get_ticks>down_tick_number+down_delay then
					down_tick_number:=lib_ctrl.get_ticks
					go_down(true)
					update_screen
				elseif left_pressed and then lib_ctrl.get_ticks>move_tick_number+move_delay then
					move_tick_number:=lib_ctrl.get_ticks
					move_delay:=30
					move_left
					update_screen
				elseif right_pressed and then lib_ctrl.get_ticks>move_tick_number+move_delay then
					move_tick_number:=lib_ctrl.get_ticks
					move_delay:=30
					move_right
					update_screen
				end

			end

		end

	on_quit
		do
			if play_sound then
				if sound_source.is_playing then
					sound_source.pause
				end
				music_source.pause
			end

			lib_ctrl.stop
			create last_image_surface.make (screen_surface.width, screen_surface.height)
			last_image_surface.draw_surface (bg_surface, 0, 0)
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

	default_key_press(keyboard_event:GAME_KEYBOARD_EVENT)
		do
			if keyboard_event.is_left_key then
				start_move_left
			elseif keyboard_event.is_right_key then
				start_move_right
			elseif keyboard_event.is_down_key then
				down_pressed:=true
			elseif keyboard_event.is_a_key then
				rotate_left
			elseif keyboard_event.is_s_key then
				rotate_right
			elseif keyboard_event.is_up_key then
				drop
			elseif keyboard_event.is_escape_key then
				on_quit
			elseif keyboard_event.is_tab_key then
				hold
			end
			update_screen
		end

	custom_keyboard_press(keyboard_event:GAME_KEYBOARD_EVENT)
		do
			if not left_pressed and keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_game_left then
				start_move_left
				update_screen
			elseif not right_pressed and keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_game_right then
				start_move_right
				update_screen
			elseif not down_pressed and keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_game_down then
				down_pressed:=true
			elseif not rotate_left_pressed and keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_game_rotate_left then
				rotate_left
				update_screen
				rotate_left_pressed:=true
			elseif not rotate_right_pressed and keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_game_rotate_right then
				rotate_right
				update_screen
				rotate_right_pressed:=true
			elseif not drop_pressed and keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_game_drop then
				drop
				update_screen
				drop_pressed:=true
			elseif not pause_pressed and keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_game_pause then
				on_quit
				pause_pressed:=true
			elseif not hold_pressed and keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_game_hold then
				hold
				update_screen
				hold_pressed:=true
			end

		end

	custom_joystick_button_press(button_id,device_id:NATURAL_8)
		do
			if device_id=init_ctrl.custom_control_ctrl.joystick_device_id then
				if not left_pressed and button_id = init_ctrl.custom_control_ctrl.joystick_button_game_left then
					start_move_left
					update_screen
				elseif not right_pressed and button_id = init_ctrl.custom_control_ctrl.joystick_button_game_right then
					start_move_right
					update_screen
				elseif not down_pressed and button_id = init_ctrl.custom_control_ctrl.joystick_button_game_down then
					down_pressed:=true
				elseif not rotate_left_pressed and button_id = init_ctrl.custom_control_ctrl.joystick_button_game_rotate_left then
					rotate_left
					update_screen
					rotate_left_pressed:=true
				elseif not rotate_right_pressed and button_id = init_ctrl.custom_control_ctrl.joystick_button_game_rotate_right then
					rotate_right
					update_screen
					rotate_right_pressed:=true
				elseif not drop_pressed and button_id = init_ctrl.custom_control_ctrl.joystick_button_game_drop then
					drop
					update_screen
					drop_pressed:=true
				elseif not pause_pressed and button_id = init_ctrl.custom_control_ctrl.joystick_button_game_pause then
					on_quit
					pause_pressed:=true
				elseif not hold_pressed and button_id = init_ctrl.custom_control_ctrl.joystick_button_game_hold then
					hold
					update_screen
					hold_pressed:=true
				end
			end

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

	custom_keyboard_up(keyboard_event:GAME_KEYBOARD_EVENT)
		do
			if keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_game_left then
				left_pressed:=false
			elseif keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_game_right then
				right_pressed:=false
			elseif keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_game_down then
				down_pressed:=false
			elseif keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_game_rotate_left then
				rotate_left_pressed:=false
			elseif keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_game_rotate_right then
				rotate_right_pressed:=false
			elseif keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_game_drop then
				drop_pressed:=false
			elseif keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_game_pause then
				pause_pressed:=false
			elseif keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_game_hold then
				hold_pressed:=false
			end
		end

	custom_joystick_button_release(button_id,device_id:NATURAL_8)
		do
			if device_id=init_ctrl.custom_control_ctrl.joystick_device_id then
				if button_id = init_ctrl.custom_control_ctrl.joystick_button_game_left then
					left_pressed:=false
				elseif button_id = init_ctrl.custom_control_ctrl.joystick_button_game_right then
					right_pressed:=false
				elseif button_id = init_ctrl.custom_control_ctrl.joystick_button_game_down then
					down_pressed:=false
				elseif button_id = init_ctrl.custom_control_ctrl.joystick_button_game_rotate_left then
					rotate_left_pressed:=false
				elseif button_id = init_ctrl.custom_control_ctrl.joystick_button_game_rotate_right then
					rotate_right_pressed:=false
				elseif button_id = init_ctrl.custom_control_ctrl.joystick_button_game_drop then
					drop_pressed:=false
				elseif button_id = init_ctrl.custom_control_ctrl.joystick_button_game_pause then
					pause_pressed:=false
				elseif button_id = init_ctrl.custom_control_ctrl.joystick_button_game_hold then
					hold_pressed:=false
				end
			end
		end

	custom_joystick_axis_change(value:INTEGER_16;axis_id,device_id:NATURAL_8)
		local
			active_state:BOOLEAN
		do
			if device_id=init_ctrl.custom_control_ctrl.joystick_device_id then
				if axis_id=init_ctrl.custom_control_ctrl.joystick_axis_game_left.axis_id then
					active_state:=	value>init_ctrl.custom_control_ctrl.joystick_axis_game_left.upper_than or
									value<init_ctrl.custom_control_ctrl.joystick_axis_game_left.lower_than
					if not left_pressed and active_state then
						start_move_left
						update_screen
					else
						left_pressed:=active_state
					end
				end
				if axis_id=init_ctrl.custom_control_ctrl.joystick_axis_game_right.axis_id then
					active_state:=	value>init_ctrl.custom_control_ctrl.joystick_axis_game_right.upper_than or
									value<init_ctrl.custom_control_ctrl.joystick_axis_game_right.lower_than
					if not right_pressed and active_state then
						start_move_right
						update_screen
					else
						right_pressed:=active_state
					end
				end
				if axis_id=init_ctrl.custom_control_ctrl.joystick_axis_game_down.axis_id then
					active_state:=	value>init_ctrl.custom_control_ctrl.joystick_axis_game_down.upper_than or
									value<init_ctrl.custom_control_ctrl.joystick_axis_game_down.lower_than
					down_pressed:=active_state
				end
				if axis_id=init_ctrl.custom_control_ctrl.joystick_axis_game_rotate_left.axis_id then
					active_state:=	value>init_ctrl.custom_control_ctrl.joystick_axis_game_rotate_left.upper_than or
									value<init_ctrl.custom_control_ctrl.joystick_axis_game_rotate_left.lower_than
					if not rotate_left_pressed and active_state then
						rotate_left
						update_screen
						rotate_left_pressed:=true
					else
						rotate_left_pressed:=active_state
					end
				end
				if axis_id=init_ctrl.custom_control_ctrl.joystick_axis_game_rotate_right.axis_id then
					active_state:=	value>init_ctrl.custom_control_ctrl.joystick_axis_game_rotate_right.upper_than or
									value<init_ctrl.custom_control_ctrl.joystick_axis_game_rotate_right.lower_than
					if not rotate_right_pressed and active_state then
						rotate_right
						update_screen
						rotate_right_pressed:=true
					else
						rotate_right_pressed:=active_state
					end
				end
				if axis_id=init_ctrl.custom_control_ctrl.joystick_axis_game_drop.axis_id then
					active_state:=	value>init_ctrl.custom_control_ctrl.joystick_axis_game_drop.upper_than or
									value<init_ctrl.custom_control_ctrl.joystick_axis_game_drop.lower_than
					if not drop_pressed and active_state then
						drop
						update_screen
						drop_pressed:=true
					else
						drop_pressed:=active_state
					end
				end
				if axis_id=init_ctrl.custom_control_ctrl.joystick_axis_game_pause.axis_id then
					active_state:=	value>init_ctrl.custom_control_ctrl.joystick_axis_game_pause.upper_than or
									value<init_ctrl.custom_control_ctrl.joystick_axis_game_pause.lower_than
					if not pause_pressed and active_state then
						on_quit
						pause_pressed:=true
					else
						pause_pressed:=active_state
					end
				end
				if axis_id=init_ctrl.custom_control_ctrl.joystick_axis_game_hold.axis_id then
					active_state:=	value>init_ctrl.custom_control_ctrl.joystick_axis_game_hold.upper_than or
									value<init_ctrl.custom_control_ctrl.joystick_axis_game_hold.lower_than
					if not hold_pressed and active_state then
						hold
						update_screen
						hold_pressed:=true
					else
						hold_pressed:=active_state
					end
				end
			end
		end

	rotate_left
		do
			if not anim_in_progress then
				currents_tetrominos.first.rotate_left
				finish_rotation
			end
		end

	rotate_right
		do
			if not anim_in_progress then
				currents_tetrominos.first.rotate_right
				finish_rotation
			end
		end

	start_move_left
		do
			if not anim_in_progress then
				move_left
				move_delay:=300
				move_tick_number:=lib_ctrl.get_ticks
				left_pressed:=true
			end

		end

	start_move_right
		do
			if not anim_in_progress then
				move_right
				move_delay:=300
				move_tick_number:=lib_ctrl.get_ticks
				right_pressed:=true
			end
		end

	drop
		local
			old_y:INTEGER
		do
			if not anim_in_progress then
				from
					old_y:=currents_tetrominos.first.y+1
				until
					not (old_y>currents_tetrominos.first.y)
				loop
					old_y:=currents_tetrominos.first.y
					go_down(false)

				end
			end
		end

	hold
		do
			if theme_ctrl.hold_field_show and not anim_in_progress then
				hold_tetromino
			end
		end

	finish_rotation
		do
			from
				currents_tetrominos.first.wall_kick
			until
				not pfield.detect_collision (currents_tetrominos.first) or
				currents_tetrominos.first.wall_kick_exhausted
			loop
				currents_tetrominos.first.wall_kick
			end
			if pfield.detect_collision (currents_tetrominos.first) then
				currents_tetrominos.first.cancel_last_move
			end
			update_ghost
			if play_sound and then theme_ctrl.is_sound_game_rotation then
				sound_source.stop
				sound_rotation.restart
				sound_source.queue_sound (sound_rotation)
				sound_source.play
			end
		end

	move_left
		do
			if not anim_in_progress then
				currents_tetrominos.first.move_left
				finish_move
			end
		end

	move_right
		do
			if not anim_in_progress then
				currents_tetrominos.first.move_right
				finish_move
			end
		end

	finish_move
		do
			if pfield.detect_collision (currents_tetrominos.first) then
				currents_tetrominos.first.cancel_last_move
			else
				update_ghost
					if play_sound and then theme_ctrl.is_sound_game_move then
					sound_source.stop
					sound_move.restart
					sound_source.queue_sound (sound_move)
					sound_source.play
				end
			end
		end

	go_down(down_sound:BOOLEAN)
		do
			if not anim_in_progress then
				currents_tetrominos.first.go_down
				if pfield.detect_collision (currents_tetrominos.first) then
					currents_tetrominos.first.cancel_last_move
					pfield.freeze_tetromino (currents_tetrominos.first)
					valid_lines
					if not anim_in_progress then
						change_current_tetromino
						down_tick_number:=lib_ctrl.get_ticks
					end
				else
					if play_sound and then down_sound and theme_ctrl.is_sound_game_down then
						sound_source.stop
						sound_down.restart
						sound_source.queue_sound (sound_down)
						sound_source.play
					end
				end

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
				if theme_ctrl.score_show then
					create score_surface.make_blended (points.out, font, text_color)
				end
				if theme_ctrl.lines_show then
					create lines_surface.make_blended (nb_lines.out, font, text_color)
				end
				if theme_ctrl.level_show then
					create level_surface.make_blended (level.out, font, text_color)
				end
				new_delay:=1050-(50*level)
				if new_delay<=0 then
					new_delay:=50
				end
				down_delay:=new_delay.to_natural_32
				if theme_ctrl.lines_anim_show then
					pfield.prepare_anim
					anim_in_progress:=true
					anim_start:=lib_ctrl.get_ticks
					if play_sound and then theme_ctrl.is_sound_game_anim then
						sound_source.stop
						sound_anim.restart
						sound_source.queue_sound (sound_anim)
						sound_source.play
					end
				else
					if play_sound and then theme_ctrl.is_sound_game_collapse then
						sound_source.stop
						sound_collapse.restart
						sound_source.queue_sound (sound_collapse)
						sound_source.play
					end
					pfield.delete_full_line
					mem.full_collect
				end
			else
				if play_sound and then theme_ctrl.is_sound_game_drop then
					sound_source.stop
					sound_drop.restart
					sound_source.queue_sound (sound_drop)
					sound_source.play
				end
			end
		end

	cont_anim
		local
			old_value:NATURAL
			l_ticks:NATURAL
		do
			l_ticks:=lib_ctrl.get_ticks
			if l_ticks>=anim_start+(theme_ctrl.lines_anim_delay*theme_ctrl.lines_anim_step) then
				anim_current_value:=theme_ctrl.lines_anim_delay
				update_screen
				anim_in_progress:=false
				pfield.delete_full_line
				mem.full_collect
				if play_sound and then theme_ctrl.is_sound_game_collapse then
					sound_source.stop
					sound_collapse.restart
					sound_source.queue_sound (sound_collapse)
					sound_source.play
				end
				change_current_tetromino
				update_screen
				down_tick_number:=lib_ctrl.get_ticks
			else
				old_value:=anim_current_value
				anim_current_value:=(l_ticks-anim_start)//theme_ctrl.lines_anim_step
				if old_value<=pfield.med_anim_value and anim_current_value>pfield.med_anim_value then
					pfield.remove_full_lines_block
				end
				update_screen
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
			screen_surface.draw_surface (bg_surface, 0, 0)
			if not anim_in_progress then
				if init_ctrl.is_ghost_show then
					update_ghost
					pfield.print_playfield_with_tetromino_and_ghost (currents_tetrominos.first,current_tetromino_ghost, screen_surface)
				else
					pfield.print_playfield_with_tetromino (currents_tetrominos.first,screen_surface)
				end
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
			if anim_in_progress then
				pfield.print_playfield_with_anim (screen_surface, anim_current_value)
			end
			lib_ctrl.flip_screen

		end

	print_level(target_surface:GAME_SURFACE)
		do
			target_surface.draw_surface (level_surface, theme_ctrl.level_x, theme_ctrl.level_y)
		end

	print_lines(target_surface:GAME_SURFACE)
		do
			target_surface.draw_surface (lines_surface, theme_ctrl.lines_x+(theme_ctrl.lines_w - lines_surface.width)//2, theme_ctrl.lines_y)
		end

	print_score(target_surface:GAME_SURFACE)
		do
			target_surface.draw_surface (score_surface, theme_ctrl.score_x+(theme_ctrl.score_w - score_surface.width)//2, theme_ctrl.score_y)
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
			create last_image_surface.make (screen_surface.width, screen_surface.height)
			last_image_surface.draw_surface (screen_surface, 0, 0)
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
	audio_ctrl:AUDIO_CONTROLLER
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
	left_pressed,right_pressed,down_pressed,drop_pressed,hold_pressed,pause_pressed,rotate_left_pressed,rotate_right_pressed:BOOLEAN

	down_tick_number:NATURAL
	move_tick_number:NATURAL

	down_delay:NATURAL
	move_delay:NATURAL

	nb_lines:INTEGER


	points:INTEGER

	font:GAME_FONT
	text_color:GAME_COLOR

	level_surface:GAME_SURFACE_TEXT
	score_surface:GAME_SURFACE_TEXT
	lines_surface:GAME_SURFACE_TEXT

	anim_in_progress:BOOLEAN
	anim_start:NATURAL
	anim_current_value:NATURAL

	sound_source:AUDIO_SOURCE
	sound_drop:AUDIO_SOUND
	sound_move:AUDIO_SOUND
	sound_down:AUDIO_SOUND
	sound_rotation:AUDIO_SOUND
	sound_anim:AUDIO_SOUND
	sound_collapse:AUDIO_SOUND

	play_sound:BOOLEAN

	music_source:AUDIO_SOURCE



end
