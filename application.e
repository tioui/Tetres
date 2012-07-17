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
		do
			create lib_ctrl.make
			run_standard(lib_ctrl)
			lib_ctrl.quit_library
		end

	run_standard(lib_ctrl:GAME_LIB_CONTROLLER)
		local
			init_ctrl:INIT_CONTROLLER
			theme_ctrl:THEME_CONTROLLER
			ressource_cpf:GAME_PACKAGE_FILE
			icon_trans_color:GAME_COLOR
			tetris_ctrl:TETRIS_CONTROLLER
			width,height:NATURAL
			temp_surface:GAME_SURFACE
			is_resume:BOOLEAN
			mem:MEMORY
		do
			create mem
			ressource_cpf:=create_cpf
			if ressource_cpf/=Void then
				create init_ctrl.make
				if not init_ctrl.has_error then

					create theme_ctrl.make (init_ctrl.theme_name)
					if not theme_ctrl.has_error then
						lib_ctrl.enable_video
						if theme_ctrl.is_sound_enable then
							lib_ctrl.enable_sound
							if init_ctrl.is_sound_thread then
								lib_ctrl.enable_sound_thread
							end
						end
						lib_ctrl.hide_mouse_cursor
						lib_ctrl.enable_text
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
						create icon_trans_color.make_rgb (255,0,255)
						width:=theme_ctrl.width
						height:=theme_ctrl.height
						lib_ctrl.create_screen_surface_with_icon_cpf (
													ressource_cpf, 1, icon_trans_color, width.to_integer_32, height.to_integer_32,
													theme_ctrl.bpp.to_integer_32, init_ctrl.is_material_video_memory, init_ctrl.is_material_double_buffer,
													false, true, theme_ctrl.fullscreen)
						from
							quitting:=false
							is_resume:=false
							temp_surface:=Void
						until
							quitting
						loop
							show_menu(is_resume,temp_surface,init_ctrl, theme_ctrl, lib_ctrl)
							lib_ctrl.clear_event_controller
							mem.full_collect
							mem.full_coalesce
							if starting or resuming then
								if starting then
									lib_ctrl.wipe_sources
									create tetris_ctrl.make(init_ctrl, theme_ctrl, lib_ctrl)
									mem.full_collect
									mem.full_coalesce
								end
								if resuming then
									tetris_ctrl.resume
								end
								tetris_ctrl.launch
								lib_ctrl.clear_event_controller
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
		end

	show_menu(is_resume:BOOLEAN;l_surface:GAME_SURFACE;l_init_ctrl:INIT_CONTROLLER; l_theme_ctrl:THEME_CONTROLLER; l_lib_ctrl:GAME_LIB_CONTROLLER)
		local
			menu_ctrl:MENU_CONTROLLER
		do
			if is_resume then

				create menu_ctrl.make_with_resume(l_surface,l_init_ctrl, l_theme_ctrl, l_lib_ctrl)
			else
				create menu_ctrl.make (l_init_ctrl, l_theme_ctrl, l_lib_ctrl)
			end
			menu_ctrl.launch
			quitting:=menu_ctrl.is_quitting
			resuming:=menu_ctrl.is_resuming
			starting:=menu_ctrl.start_game
			menu_ctrl.dispose
		end

	create_cpf:GAME_PACKAGE_FILE
		local
			l_file:RAW_FILE
		do
			create l_file.make_open_read ("ressources.cpf")
			if l_file.exists and then l_file.is_readable then
				create Result.make ("ressources.cpf",false)
				if Result.sub_files_count/=1 then
					io.error.put_string ("Error: file ressources.cpf not valid%N")
					io.error.flush
					Result:=Void
					check false end
				end
			else
				io.error.put_string ("Error: ressources.cpf file not found%N")
				io.error.flush
				Result:=Void
			end
		end

	game_over_screen(lib_ctrl:GAME_LIB_CONTROLLER;theme_ctrl:THEME_CONTROLLER;l_surface:GAME_SURFACE)
		local
			game_over_surface:GAME_SURFACE_IMG_FILE
		do
			l_surface.set_overall_alpha_value (theme_ctrl.menu_bg_alpha)
			lib_ctrl.screen_surface.fill_rect (create {GAME_COLOR}.make_rgb(0,0,0), 0, 0, lib_ctrl.screen_surface.width, lib_ctrl.screen_surface.height)
			lib_ctrl.screen_surface.print_surface_on_surface (l_surface, 0, 0)
			create game_over_surface.make_with_alpha (theme_ctrl.game_over_file_name)
			lib_ctrl.screen_surface.print_surface_on_surface (game_over_surface, 0, 0)
			lib_ctrl.flip_screen
			lib_ctrl.delay (theme_ctrl.game_over_time)
		end

	quitting:BOOLEAN

	starting:BOOLEAN

	resuming:BOOLEAN


end
