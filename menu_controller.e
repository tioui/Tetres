note
	description: "Summary description for {MENU_CONTROLLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MENU_CONTROLLER

create
	make,
	make_with_resume

feature {NONE} -- Initialization

	make(l_init_ctrl:INIT_CONTROLLER; l_theme_ctrl:THEME_CONTROLLER; l_lib_ctrl:GAME_LIB_CONTROLLER)
			-- Initialization for `Current'.
		do
			make_default (l_init_ctrl, l_theme_ctrl, l_lib_ctrl)
			create tetris_ctrl.make(init_ctrl, theme_ctrl, lib_ctrl,theme_ctrl.menu_bg_alpha)
			resume_enable:=false
			create {GAME_SURFACE_IMG_FILE} fg_surface.make_with_alpha(theme_ctrl.menu_init_file_name)
			start_game:=true
		end

	make_with_resume(l_surface:GAME_SURFACE;l_init_ctrl:INIT_CONTROLLER; l_theme_ctrl:THEME_CONTROLLER; l_lib_ctrl:GAME_LIB_CONTROLLER)
		do
			make_default (l_init_ctrl, l_theme_ctrl, l_lib_ctrl)
			create bk_surface.make (l_surface.width, l_surface.height, l_surface.bits_per_pixel, false)
			l_surface.set_overall_alpha_value (theme_ctrl.menu_bg_alpha)
			bk_surface.fill_rect (create {GAME_COLOR}.make_rgb(0,0,0), 0, 0, bk_surface.width, bk_surface.height)
			bk_surface.set_overall_alpha_value (255)
			bk_surface.print_surface_on_surface (l_surface, 0, 0)
			resume_enable:=true
			create {GAME_SURFACE_IMG_FILE} fg_surface.make_with_alpha(theme_ctrl.menu_resume_file_name)
			is_resuming:=true
		end

	make_default(l_init_ctrl:INIT_CONTROLLER; l_theme_ctrl:THEME_CONTROLLER; l_lib_ctrl:GAME_LIB_CONTROLLER)
		do
			init_ctrl:=l_init_ctrl
			theme_ctrl:=l_theme_ctrl
			lib_ctrl:=l_lib_ctrl
			create {GAME_SURFACE_IMG_FILE} arrow_surface.make_with_alpha(theme_ctrl.arrow_file_name)
			arrow_mirror_surface:=arrow_surface.get_new_surface_mirror (true, false)
			lib_ctrl.event_controller.on_quit_signal.extend (agent on_quit)
			lib_ctrl.event_controller.on_key_down.extend (agent on_key_press)
			lib_ctrl.event_controller.on_tick.extend (agent on_tick)
			is_quitting:=false
			start_game:=false
			is_resuming:=false
			is_settings:=false
			create mem
		end

feature -- Access

	launch
		do
			lib_ctrl.launch

		end

	is_quitting:BOOLEAN

	start_game:BOOLEAN

	is_resuming:BOOLEAN

	is_settings:BOOLEAN

feature {NONE} -- Implementation - Routines

	on_tick(nb_tick:NATURAL_32)
		do
			update_screen
		end

	on_quit
		do
			is_quitting:=true
			start_game:=false
			is_resuming:=false
			is_settings:=false
			lib_ctrl.stop
		end

	on_key_press(keyboard_event:GAME_KEYBOARD_EVENT)
		do
			if keyboard_event.is_escape_key then
				if resume_enable then
					is_quitting:=false
					start_game:=false
					is_resuming:=true
					is_settings:=false
					lib_ctrl.stop
				else
					on_quit
				end

			elseif keyboard_event.is_down_key then
				move_down
			elseif keyboard_event.is_up_key then
				move_up
			elseif keyboard_event.is_return_key then
				lib_ctrl.stop
			end
		end

	move_up
		do
			if is_quitting then
				is_quitting:=false
				is_settings:=true
			elseif is_settings then
				if resume_enable then
					is_settings:=false
					is_resuming:=true
				else
					is_settings:=false
					start_game:=true
				end
			elseif is_resuming then
				is_resuming:=false
				start_game:=true
			elseif start_game then
				start_game:=false
				is_quitting:=true
			end
		end

	move_down
		do
			if is_resuming then
				is_resuming:=false
				is_settings:=true
			elseif start_game then
				if resume_enable then
					start_game:=false
					is_resuming:=true
				else
					start_game:=false
					is_settings:=true
				end

			elseif is_settings then
				is_settings:=false
				is_quitting:=true
			elseif is_quitting then
				is_quitting:=false
				start_game:=true
			end
		end

	update_screen
		do
			lib_ctrl.screen_surface.fill_rect (create {GAME_COLOR}.make_rgb(0,0,0), 0, 0, lib_ctrl.screen_surface.width, lib_ctrl.screen_surface.height)
			if resume_enable then
				lib_ctrl.screen_surface.print_surface_on_surface (bk_surface, 0, 0)
			else
				lib_ctrl.screen_surface.print_surface_on_surface (tetris_ctrl.screen_surface, 0, 0)
			end
			lib_ctrl.screen_surface.print_surface_on_surface (fg_surface, 0, 0)
			if start_game then
				if theme_ctrl.menu_new_game_mirror then
					lib_ctrl.screen_surface.print_surface_on_surface (arrow_mirror_surface,theme_ctrl.menu_new_game_x,theme_ctrl.menu_new_game_y)
				else
					lib_ctrl.screen_surface.print_surface_on_surface (arrow_surface,theme_ctrl.menu_new_game_x,theme_ctrl.menu_new_game_y)
				end
			elseif is_resuming then
				if theme_ctrl.menu_resume_mirror then
					lib_ctrl.screen_surface.print_surface_on_surface (arrow_mirror_surface,theme_ctrl.menu_resume_x,theme_ctrl.menu_resume_y)
				else
					lib_ctrl.screen_surface.print_surface_on_surface (arrow_surface,theme_ctrl.menu_resume_x,theme_ctrl.menu_resume_y)
				end
			elseif is_settings then
				if theme_ctrl.menu_settings_mirror then
					lib_ctrl.screen_surface.print_surface_on_surface (arrow_mirror_surface,theme_ctrl.menu_settings_x,theme_ctrl.menu_settings_y)
				else
					lib_ctrl.screen_surface.print_surface_on_surface (arrow_surface,theme_ctrl.menu_settings_x,theme_ctrl.menu_settings_y)
				end
			elseif is_quitting then
				if theme_ctrl.menu_quit_mirror then
					lib_ctrl.screen_surface.print_surface_on_surface (arrow_mirror_surface,theme_ctrl.menu_quit_x,theme_ctrl.menu_quit_y)
				else
					lib_ctrl.screen_surface.print_surface_on_surface (arrow_surface,theme_ctrl.menu_quit_x,theme_ctrl.menu_quit_y)
				end
			end
			lib_ctrl.flip_screen
		end

feature {NONE} -- Implementation - Variables


	mem:MEMORY
	init_ctrl:INIT_CONTROLLER
	theme_ctrl:THEME_CONTROLLER
	lib_ctrl:GAME_LIB_CONTROLLER
	tetris_ctrl:TETRIS_AUTO_CONTROLLER
	bk_surface:GAME_SURFACE
	fg_surface:GAME_SURFACE
	arrow_surface:GAME_SURFACE
	arrow_mirror_surface:GAME_SURFACE

	resume_enable:BOOLEAN

end
