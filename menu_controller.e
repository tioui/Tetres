note
	description : "Manage the game menu."
	author      : "Louis Marchand"
	date        : "July 19 2012"
	revision    : "1.0"

class
	MENU_CONTROLLER


create
	make,
	make_with_resume

feature {NONE} -- Initialization

	make(l_init_ctrl:INIT_CONTROLLER; l_theme_ctrl:THEME_CONTROLLER; l_lib_ctrl:GAME_LIB_CONTROLLER;l_audio_ctrl:AUDIO_CONTROLLER)
			-- Initialization for `Current' using `l_init_ctrl' to load config, `l_theme_ctrl' to
			-- load the theme, `l_lib_ctrl' as game library controller and `l_audio_ctrl' as audio library
			-- controller.
		do
			make_default (l_init_ctrl, l_theme_ctrl, l_lib_ctrl,l_audio_ctrl)
			create tetris_ctrl.make(init_ctrl, theme_ctrl, lib_ctrl,theme_ctrl.menu_bg_alpha)
			resume_enable:=false
			create {GAME_SURFACE_IMG_FILE} fg_surface.make_with_alpha(theme_ctrl.menu_init_file_name)
			start_game:=true
			is_animate:=true
		end

	make_with_resume(l_surface:GAME_SURFACE;l_init_ctrl:INIT_CONTROLLER; l_theme_ctrl:THEME_CONTROLLER; l_lib_ctrl:GAME_LIB_CONTROLLER;l_audio_ctrl:AUDIO_CONTROLLER)
			-- Initialization for `Current' using `l_surface' as background, `l_init_ctrl' to load config,
			-- `l_theme_ctrl' to load the theme, `l_lib_ctrl' as game library controller and
			-- `l_audio_ctrl' as audio library controller.
		do
			make_default (l_init_ctrl, l_theme_ctrl, l_lib_ctrl,l_audio_ctrl)
			create bk_surface.make_with_bit_per_pixel (l_surface.width, l_surface.height, l_surface.bits_per_pixel, false)
			l_surface.set_overall_alpha_value (theme_ctrl.menu_bg_alpha)
			bk_surface.fill_rect (create {GAME_COLOR}.make_rgb(0,0,0), 0, 0, bk_surface.width, bk_surface.height)
			bk_surface.set_overall_alpha_value (255)
			bk_surface.draw_surface (l_surface, 0, 0)
			resume_enable:=true
			create {GAME_SURFACE_IMG_FILE} fg_surface.make_with_alpha(theme_ctrl.menu_resume_file_name)
			is_resuming:=true
			is_animate:=false
			update_screen
		end

	make_default(l_init_ctrl:INIT_CONTROLLER; l_theme_ctrl:THEME_CONTROLLER; l_lib_ctrl:GAME_LIB_CONTROLLER;l_audio_ctrl:AUDIO_CONTROLLER)
			-- Initialization for `Current' using `l_init_ctrl' to load config, `l_theme_ctrl' to
			-- load the theme, `l_lib_ctrl' as game library controller and `l_audio_ctrl' as audio library
			-- controller.
		local
			music:AUDIO_SOUND_SND_FILE
		do
			init_ctrl:=l_init_ctrl
			theme_ctrl:=l_theme_ctrl
			lib_ctrl:=l_lib_ctrl
			audio_ctrl:=l_audio_ctrl
			create {GAME_SURFACE_IMG_FILE} arrow_surface.make_with_alpha(theme_ctrl.arrow_file_name)
			arrow_mirror_surface:=arrow_surface.surface_mirrored (true, false)
			lib_ctrl.event_controller.on_quit_signal.extend (agent on_quit)
			if init_ctrl.custom_control_enable then
				if init_ctrl.custom_control_ctrl.keyboard_enable then
					lib_ctrl.event_controller.on_key_down.extend (agent on_custom_key_press)
					lib_ctrl.event_controller.on_key_up.extend (agent on_custom_key_release)
				end
				if init_ctrl.custom_control_ctrl.joystick_enable then
					lib_ctrl.event_controller.enable_joystick_event
					if init_ctrl.custom_control_ctrl.joystick_buttons_enable then
						lib_ctrl.event_controller.on_joystick_button_pressed.extend (agent custom_joystick_button_press)
						lib_ctrl.event_controller.on_joystick_button_released.extend (agent custom_joystick_button_release)
					end
					if init_ctrl.custom_control_ctrl.joystick_axis_enable then
						lib_ctrl.event_controller.on_joystick_axis_change.extend (agent custom_joystick_axis_change)
					end
				end

			else
				lib_ctrl.event_controller.on_key_down.extend (agent on_default_key_press)
			end
			if theme_ctrl.is_sound_enable then
				audio_ctrl.add_source
				sound_source:=audio_ctrl.last_source
				if theme_ctrl.is_sound_menu_enter then
					create {AUDIO_SOUND_SND_FILE} sound_enter.make (theme_ctrl.sound_menu_enter_file)
				end
				if theme_ctrl.is_sound_menu_move then
					create {AUDIO_SOUND_SND_FILE} sound_move.make (theme_ctrl.sound_menu_move_file)
				end
				if theme_ctrl.is_music_menu then
					audio_ctrl.add_source
					music_source:=audio_ctrl.last_source
					if theme_ctrl.is_music_menu_intro then
						create music.make (theme_ctrl.music_menu_intro_file)
						music_source.queue_sound (music)
					end
					create music.make (theme_ctrl.music_menu_loop_file)
					music_source.queue_sound_infinite_loop (music)
					music_source.play
				end
			end

			lib_ctrl.event_controller.on_iteration.extend (agent on_tick)
			is_quitting:=false
			start_game:=false
			is_resuming:=false
--			is_settings:=false
			stop_on_enter_sound_finish:=false
		end

feature -- Access

	launch
			-- Main loop of the menu.
		do
			lib_ctrl.launch
			if stop_on_enter_sound_finish then
				from
				until not sound_source.is_playing
				loop
					audio_ctrl.update
					lib_ctrl.delay (100)
				end
			end
		end

	is_quitting:BOOLEAN
			-- Status flag that indicate that the menu must quit

	start_game:BOOLEAN
			-- Status flag that indicate that the menu must start the game

	is_resuming:BOOLEAN
			-- Status flag that indicate that the menu must resume a paused game

--	is_settings:BOOLEAN
			-- Status flag that indicate that the menu must shot settings screen.

	dispose
			-- Close every ressources used by `Current'
		do
			if theme_ctrl.is_sound_enable then
				sound_source.stop
				audio_ctrl.prune_source (sound_source)
				if theme_ctrl.is_music_menu then
					music_source.stop
					audio_ctrl.prune_source (music_source)
				end
			end

		end

feature {NONE} -- Implementation - Routines

	on_tick
			-- Manage menu FPS
		do
			if last_tick+100<lib_ctrl.get_ticks then
				update_screen
				last_tick:=lib_ctrl.get_ticks
			end
		end

	on_quit
			-- Manage the quitting
		do
			is_quitting:=true
			start_game:=false
			is_resuming:=false
--			is_settings:=false
			lib_ctrl.stop
		end

	on_default_key_press(keyboard_event:GAME_KEYBOARD_EVENT)
			-- When a user press a key specified in `keyboard_event'.
			-- Manage the default hard coded key values
		do
			if keyboard_event.is_escape_key then
				if resume_enable then
					is_quitting:=false
					start_game:=false
					is_resuming:=true
--					is_settings:=false
					lib_ctrl.stop
				else
					on_quit
				end

			elseif keyboard_event.is_down_key then
				move_down
			elseif keyboard_event.is_up_key then
				move_up
			elseif keyboard_event.is_return_key then
				on_enter
			end
		end

	on_custom_key_press(keyboard_event:GAME_KEYBOARD_EVENT)
			-- When a user press a key specified in `keyboard_event'.
			-- Manage the key values managed by `init_ctrl'.`custom_control_ctrl'
		do
			if not back_pressed and keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_menu_back then
				if resume_enable then
					is_quitting:=false
					start_game:=false
					is_resuming:=true
--					is_settings:=false
					lib_ctrl.stop
				else
					on_quit
				end
				back_pressed:=true
			elseif not down_pressed and keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_menu_down then
				move_down
				down_pressed:=true
			elseif  not up_pressed and keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_menu_up then
				move_up
				up_pressed:=true
			elseif  not enter_pressed and keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_menu_enter then
				on_enter
				enter_pressed:=true
			end
		end

	on_custom_key_release(keyboard_event:GAME_KEYBOARD_EVENT)
			-- When a user release a key specified in `keyboard_event'.
			-- Manage the key values managed by `init_ctrl'.`custom_control_ctrl'
		do
			if keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_menu_back then
				back_pressed:=false
			elseif keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_menu_down then
				down_pressed:=false
			elseif keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_menu_up then
				up_pressed:=false
			elseif keyboard_event.scancode = init_ctrl.custom_control_ctrl.keyboard_menu_enter then
				enter_pressed:=false
			end
		end

	custom_joystick_button_press(button_id,device_id:NATURAL_8)
			-- When a user press the joystick button specified by `device_id' and `button_id'
			-- Manage the joystick button managed by `init_ctrl'.`custom_control_ctrl'
		do
			if device_id=init_ctrl.custom_control_ctrl.joystick_device_id then
				if not back_pressed and button_id = init_ctrl.custom_control_ctrl.joystick_button_menu_back then
					if resume_enable then
						is_quitting:=false
						start_game:=false
						is_resuming:=true
--						is_settings:=false
						lib_ctrl.stop
					else
						on_quit
					end
					back_pressed:=true
				elseif not down_pressed and button_id = init_ctrl.custom_control_ctrl.joystick_button_menu_down then
					move_down
					down_pressed:=true
				elseif  not up_pressed and button_id = init_ctrl.custom_control_ctrl.joystick_button_menu_up then
					move_up
					up_pressed:=true
				elseif  not enter_pressed and button_id = init_ctrl.custom_control_ctrl.joystick_button_menu_enter then
					on_enter
					enter_pressed:=true
				end
			end
		end

	custom_joystick_button_release(button_id,device_id:NATURAL_8)
			-- When a user release the joystick button specified by `device_id' and `button_id'
			-- Manage the joystick button managed by `init_ctrl'.`custom_control_ctrl'
		do
			if device_id=init_ctrl.custom_control_ctrl.joystick_device_id then
				if button_id = init_ctrl.custom_control_ctrl.joystick_button_menu_back then
					back_pressed:=false
				elseif button_id = init_ctrl.custom_control_ctrl.joystick_button_menu_down then
					down_pressed:=false
				elseif button_id = init_ctrl.custom_control_ctrl.joystick_button_menu_up then
					up_pressed:=false
				elseif button_id = init_ctrl.custom_control_ctrl.joystick_button_menu_enter then
					enter_pressed:=false
				end
			end
		end

	custom_joystick_axis_change(value:INTEGER_16;axis_id,device_id:NATURAL_8)
			-- When a user change the joystick axis `value' specified by `device_id' and `axis_id'
			-- Manage the joystick axis values managed by `init_ctrl'.`custom_control_ctrl'
		local
			active_state:BOOLEAN
		do
			if device_id=init_ctrl.custom_control_ctrl.joystick_device_id then
				if axis_id=init_ctrl.custom_control_ctrl.joystick_axis_menu_back.axis_id then
					active_state:=	value>init_ctrl.custom_control_ctrl.joystick_axis_menu_back.upper_than or
									value<init_ctrl.custom_control_ctrl.joystick_axis_menu_back.lower_than
					if not back_pressed and active_state then
						if resume_enable then
							is_quitting:=false
							start_game:=false
							is_resuming:=true
--							is_settings:=false
							lib_ctrl.stop
						else
							on_quit
						end
						back_pressed:=true
					else
						back_pressed:=active_state
					end
				end
				if axis_id=init_ctrl.custom_control_ctrl.joystick_axis_menu_down.axis_id then
					active_state:=	value>init_ctrl.custom_control_ctrl.joystick_axis_menu_down.upper_than or
									value<init_ctrl.custom_control_ctrl.joystick_axis_menu_down.lower_than
					if not down_pressed and active_state then
						move_down
						down_pressed:=true
					else
						down_pressed:=active_state
					end
				end
				if axis_id=init_ctrl.custom_control_ctrl.joystick_axis_menu_up.axis_id then
					active_state:=	value>init_ctrl.custom_control_ctrl.joystick_axis_menu_up.upper_than or
									value<init_ctrl.custom_control_ctrl.joystick_axis_menu_up.lower_than
					if not up_pressed and active_state then
						move_up
						up_pressed:=true
					else
						up_pressed:=active_state
					end
				end
				if axis_id=init_ctrl.custom_control_ctrl.joystick_axis_menu_enter.axis_id then
					active_state:=	value>init_ctrl.custom_control_ctrl.joystick_axis_menu_enter.upper_than or
									value<init_ctrl.custom_control_ctrl.joystick_axis_menu_enter.lower_than
					if not enter_pressed and active_state then
						on_enter
						enter_pressed:=true
					else
						enter_pressed:=active_state
					end
				end
			end
		end

	move_up
			-- Move the menu cursor up
		do
			if is_quitting then
				is_quitting:=false
				if resume_enable then
					is_resuming:=true
				else
					start_game:=true
				end
--			elseif is_settings then
--				if resume_enable then
--					is_settings:=false
--					is_resuming:=true
--				else
--					is_settings:=false
--					start_game:=true
--				end
			elseif is_resuming then
				is_resuming:=false
				start_game:=true
			elseif start_game then
				start_game:=false
				is_quitting:=true
			end
			if theme_ctrl.is_sound_menu_move then
				sound_source.stop
				sound_move.restart
				sound_source.queue_sound (sound_move)
				sound_source.play
			end

			update_screen
		end

	move_down
			-- Move the menu cursor down
		do
			if is_resuming then
				is_resuming:=false
				is_quitting:=true
			elseif start_game then
				start_game:=false
				if resume_enable then
					is_resuming:=true
				else
					is_quitting:=true
				end

--			elseif is_settings then
--				is_settings:=false
--				is_quitting:=true
			elseif is_quitting then
				is_quitting:=false
				start_game:=true
			end
			if theme_ctrl.is_sound_menu_move then
				sound_source.stop
				sound_move.restart
				sound_source.queue_sound (sound_move)
				sound_source.play
			end
			update_screen
		end

	on_enter
			-- Enter the selected menu item
		do
			if theme_ctrl.is_sound_menu_enter then
				sound_source.stop
				sound_enter.restart
				sound_source.queue_sound (sound_enter)
				sound_source.play
				stop_on_enter_sound_finish:=true
			end
			lib_ctrl.stop
		end

	update_screen
			-- Redraw `Current'
		do
			lib_ctrl.screen_surface.fill_rect (create {GAME_COLOR}.make_rgb(0,0,0), 0, 0, lib_ctrl.screen_surface.width, lib_ctrl.screen_surface.height)
			if resume_enable then
				lib_ctrl.screen_surface.draw_surface (bk_surface, 0, 0)
			else
				tetris_ctrl.print_screen
				lib_ctrl.screen_surface.draw_surface (tetris_ctrl.screen_surface, 0, 0)
			end
			lib_ctrl.screen_surface.draw_surface (fg_surface, 0, 0)
			if start_game then
				if theme_ctrl.menu_new_game_mirror then
					lib_ctrl.screen_surface.draw_surface (arrow_mirror_surface,theme_ctrl.menu_new_game_x,theme_ctrl.menu_new_game_y)
				else
					lib_ctrl.screen_surface.draw_surface (arrow_surface,theme_ctrl.menu_new_game_x,theme_ctrl.menu_new_game_y)
				end
			elseif is_resuming then
				if theme_ctrl.menu_resume_mirror then
					lib_ctrl.screen_surface.draw_surface (arrow_mirror_surface,theme_ctrl.menu_resume_x,theme_ctrl.menu_resume_y)
				else
					lib_ctrl.screen_surface.draw_surface (arrow_surface,theme_ctrl.menu_resume_x,theme_ctrl.menu_resume_y)
				end
--			elseif is_settings then
--				if theme_ctrl.menu_settings_mirror then
--					lib_ctrl.screen_surface.draw_surface (arrow_mirror_surface,theme_ctrl.menu_settings_x,theme_ctrl.menu_settings_y)
--				else
--					lib_ctrl.screen_surface.draw_surface (arrow_surface,theme_ctrl.menu_settings_x,theme_ctrl.menu_settings_y)
--				end
			elseif is_quitting then
				if theme_ctrl.menu_quit_mirror then
					lib_ctrl.screen_surface.draw_surface (arrow_mirror_surface,theme_ctrl.menu_quit_x,theme_ctrl.menu_quit_y)
				else
					lib_ctrl.screen_surface.draw_surface (arrow_surface,theme_ctrl.menu_quit_x,theme_ctrl.menu_quit_y)
				end
			end
			lib_ctrl.flip_screen
		end


feature {NONE} -- Implementation - Variables

	init_ctrl:INIT_CONTROLLER
			-- The configuration loaded from a config file
	theme_ctrl:THEME_CONTROLLER
			-- The theme to use in `Current'
	lib_ctrl:GAME_LIB_CONTROLLER
			-- The game library to use in `Current'
	audio_ctrl:AUDIO_CONTROLLER
			-- The audio library to use in `Current'
	tetris_ctrl:TETRIS_AUTO_CONTROLLER
			-- A tetris that play automatically
	bk_surface:GAME_SURFACE
			-- The image to show in the background
	fg_surface:GAME_SURFACE
			-- The image to show in the foreground
	arrow_surface:GAME_SURFACE
			-- Image of the cursor
	arrow_mirror_surface:GAME_SURFACE
			-- The `arrow_surface' mirrored
	is_animate:BOOLEAN
			-- Status flags that indicate that `Curent' is animaged

	resume_enable:BOOLEAN
			-- Status flags that indicate that `Curent' can resume a paused game

	last_tick:NATURAL
			-- Used to manage FPS

	back_pressed:BOOLEAN
			-- Indicate that the back button is pressed.
	up_pressed:BOOLEAN
			-- Indicate that the up button is pressed.
	down_pressed:BOOLEAN
			-- Indicate that the down button is pressed.
	enter_pressed:BOOLEAN
			-- Indicate that the enter button is pressed.

	sound_source:AUDIO_SOURCE
			-- The audio source used when changing selected item.
	sound_move:AUDIO_SOUND
			-- The sound used when changing selected item.
	sound_enter:AUDIO_SOUND
			-- The sound used when entering a selected item.

	stop_on_enter_sound_finish:BOOLEAN
			-- If `True', wait for the sound to finish before changing screen.

	music_source:AUDIO_SOURCE
			-- The audio source used for the backgroud music.


end
