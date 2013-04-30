note
	description : "Mouse-text application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
		local
			lib_ctrl:GAME_LIB_CONTROLLER
			audio_ctrl:AUDIO_CONTROLLER
			text_ctrl:GAME_TEXT_CONTROLLER
			img_ctrl:GAME_IMG_CONTROLLER
		do
			create lib_ctrl.make
			create audio_ctrl.make
			create text_ctrl.make
			create img_ctrl.make
			run_standard(lib_ctrl,audio_ctrl,text_ctrl)
			img_ctrl.quit_library
			text_ctrl.quit_library
			audio_ctrl.quit_library
			lib_ctrl.quit_library
		end

	run_standard(lib_ctrl:GAME_LIB_CONTROLLER;audio_ctrl:AUDIO_CONTROLLER;text_ctrl:GAME_TEXT_CONTROLLER)
		local
			init_ctrl:INIT_CONTROLLER
			theme_ctrl:THEME_CONTROLLER
			icon_trans_color:GAME_COLOR
			tetris_ctrl:TETRIS_CONTROLLER
			width,height:NATURAL
			temp_surface:GAME_SURFACE
			is_resume:BOOLEAN
			mem:MEMORY
			title_tick:NATURAL
		do
			create mem
			create init_ctrl.make
			if not init_ctrl.has_error then
				create theme_ctrl.make (init_ctrl.theme_name)
				if not theme_ctrl.has_error then
					lib_ctrl.enable_video
					create icon_trans_color.make_rgb (255,0,255)
					width:=theme_ctrl.width
					height:=theme_ctrl.height
					lib_ctrl.create_screen_surface_with_icon (
												"tetres.bmp", icon_trans_color, width.to_integer_32, height.to_integer_32,
												theme_ctrl.bpp.to_integer_32, init_ctrl.is_material_video_memory, init_ctrl.is_material_double_buffer,
												false, true, theme_ctrl.fullscreen)
					if theme_ctrl.is_title_screen then
						show_title(theme_ctrl,lib_ctrl)
						title_tick:=lib_ctrl.get_ticks
					end
					if theme_ctrl.is_sound_enable then
						audio_ctrl.enable_sound
						if init_ctrl.is_sound_thread then
							audio_ctrl.launch_in_thread
						end
					end
					if theme_ctrl.score_show or theme_ctrl.lines_show or theme_ctrl.level_show then
						text_ctrl.enable_text
					end
					lib_ctrl.hide_mouse_cursor

					if init_ctrl.custom_control_enable and then init_ctrl.custom_control_ctrl.joystick_enable then
						lib_ctrl.enable_joystick
						lib_ctrl.enable_event_thread
						if init_ctrl.custom_control_ctrl.joystick_device_id<lib_ctrl.get_joystick_count then
							lib_ctrl.get_joystick (init_ctrl.custom_control_ctrl.joystick_device_id).open
						else
							io.error.put_string ("Warning: Cannot open Joystick number "+init_ctrl.custom_control_ctrl.joystick_device_id.out)
							io.error.put_new_line
							io.error.flush
						end
					end
					from
						quitting:=false
						is_resume:=false
						temp_surface:=Void
					until
						quitting
					loop
						if theme_ctrl.is_title_screen then
							from
							until title_tick+theme_ctrl.title_delay<lib_ctrl.get_ticks
							loop
							end
						end
						show_menu(is_resume,temp_surface,init_ctrl, theme_ctrl, lib_ctrl,audio_ctrl)
						lib_ctrl.clear_event_controller
						if theme_ctrl.is_sound_enable and then not init_ctrl.is_sound_thread then
							lib_ctrl.event_controller.on_tick.extend (agent audio_ctrl.update)
						end
						mem.full_collect
						mem.full_coalesce
						if starting or resuming then
							if starting then
								audio_ctrl.wipe_sources
								create tetris_ctrl.make(init_ctrl, theme_ctrl, lib_ctrl,audio_ctrl)
								mem.full_collect
								mem.full_coalesce
							end
							if resuming then
								tetris_ctrl.resume
							end
							tetris_ctrl.launch
							lib_ctrl.clear_event_controller
							if theme_ctrl.is_sound_enable and then not init_ctrl.is_sound_thread then
								lib_ctrl.event_controller.on_tick.extend (agent audio_ctrl.update)
							end
							mem.full_collect
							mem.full_coalesce
							if tetris_ctrl.is_game_over then
								game_over_screen (lib_ctrl, theme_ctrl,tetris_ctrl.last_image_surface)
								temp_surface:=Void
								is_resume:=false
							else
								temp_surface:=tetris_ctrl.last_image_surface
								is_resume:=true
							end
						end
					end
				end
			end
		end

	show_title(l_theme_ctrl:THEME_CONTROLLER; l_lib_ctrl:GAME_LIB_CONTROLLER)
		local
			title_surface:GAME_SURFACE_IMG_FILE
		do
			create title_surface.make (l_theme_ctrl.title_file_name)
			l_lib_ctrl.screen_surface.draw_surface (title_surface, 0, 0)
			l_lib_ctrl.flip_screen
		end

	show_menu(is_resume:BOOLEAN;l_surface:GAME_SURFACE;l_init_ctrl:INIT_CONTROLLER; l_theme_ctrl:THEME_CONTROLLER; l_lib_ctrl:GAME_LIB_CONTROLLER;l_audio_ctrl:AUDIO_CONTROLLER)
		local
			menu_ctrl:MENU_CONTROLLER
		do
			if is_resume then

				create menu_ctrl.make_with_resume(l_surface,l_init_ctrl, l_theme_ctrl, l_lib_ctrl,l_audio_ctrl)
			else
				create menu_ctrl.make (l_init_ctrl, l_theme_ctrl, l_lib_ctrl,l_audio_ctrl)
			end
			menu_ctrl.launch
			quitting:=menu_ctrl.is_quitting
			resuming:=menu_ctrl.is_resuming
			starting:=menu_ctrl.start_game
			menu_ctrl.dispose
		end


	game_over_screen(lib_ctrl:GAME_LIB_CONTROLLER;theme_ctrl:THEME_CONTROLLER;l_surface:GAME_SURFACE)
		local
			game_over_surface:GAME_SURFACE_IMG_FILE
		do
			l_surface.set_overall_alpha_value (theme_ctrl.menu_bg_alpha)
			lib_ctrl.screen_surface.fill_rect (create {GAME_COLOR}.make_rgb(0,0,0), 0, 0, lib_ctrl.screen_surface.width, lib_ctrl.screen_surface.height)
			lib_ctrl.screen_surface.draw_surface (l_surface, 0, 0)
			create game_over_surface.make_with_alpha (theme_ctrl.game_over_file_name)
			lib_ctrl.screen_surface.draw_surface (game_over_surface, 0, 0)
			lib_ctrl.flip_screen
			lib_ctrl.delay (theme_ctrl.game_over_time)
		end

	quitting:BOOLEAN

	starting:BOOLEAN

	resuming:BOOLEAN


end
