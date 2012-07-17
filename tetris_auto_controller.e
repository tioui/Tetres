note
	description: "Summary description for {TETRIS_AUTO_CONTROLLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TETRIS_AUTO_CONTROLLER

inherit
	TETRIS_CONTROLLER
	rename
		make as make_tetris
	export
		{MENU_CONTROLLER} screen_surface
	undefine
		update_screen
	redefine
		on_tick,
		change_current_tetromino,
		game_over
	end

create
	make

feature {NONE} -- Initialization

	make(l_init_ctrl:INIT_CONTROLLER; l_theme_ctrl:THEME_CONTROLLER; l_lib_ctrl:GAME_LIB_CONTROLLER;alpha:NATURAL_8)
			-- Initialization for `Current'.
		local
			ghost_alpha:INTEGER
		do
			init_ctrl:=l_init_ctrl
			theme_ctrl:=l_theme_ctrl
			lib_ctrl:=l_lib_ctrl
			event_controller:=l_lib_ctrl.event_controller
			create blocks_surface.make (l_theme_ctrl.blocks_file_name)
			create screen_surface.make (lib_ctrl.screen_surface.width, lib_ctrl.screen_surface.height, lib_ctrl.screen_surface.bits_per_pixel, false)
			screen_surface.set_overall_alpha_value (255)
			create bg_surface.make_with_alpha (theme_ctrl.bg_file_name)
			create tetrominos_fact.make_with_alpha (blocks_surface, theme_ctrl.block_width, theme_ctrl.block_height,theme_ctrl.block_rotation,alpha)
			if init_ctrl.is_ghost_show then
				ghost_alpha:=(theme_ctrl.ghost_alpha//(255//alpha.to_integer_32)).to_natural_8
				create tetrominos_fact_ghost.make_with_alpha (blocks_surface, theme_ctrl.block_width, theme_ctrl.block_height,theme_ctrl.block_rotation,ghost_alpha.to_natural_8)
			end
			create pfield.make (theme_ctrl.playfield_x.to_integer_32, theme_ctrl.playfield_y.to_integer_32, theme_ctrl.block_width, theme_ctrl.block_height)
			create rnd_bag.make(lib_ctrl,1,7)
			init_currents_tetrominos
			is_init:=false
			is_game_over:=false
			create mem
			bg_surface.set_overall_alpha_value (alpha)
			event_controller.on_tick.extend(agent on_tick)
			down_delay:=200
			auto_move_delay:=100
			auto_move_tick:=lib_ctrl.get_ticks
			lib_ctrl.generate_new_random
			auto_next_tetromino_position:=lib_ctrl.last_random_integer_between (1, 7)
			lib_ctrl.generate_new_random
			auto_left_tetromino_rotation:=lib_ctrl.last_random_integer_between (1, 7)
			lib_ctrl.generate_new_random
			auto_right_tetromino_rotation:=lib_ctrl.last_random_integer_between (1, 7)
		end

feature -- Access

	print_screen
		do
			screen_surface.fill_rect (create {GAME_COLOR}.make_rgb(0,0,0), 0, 0, lib_ctrl.screen_surface.width, lib_ctrl.screen_surface.height)
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
		end

feature {NONE} -- Implementation - Routines

	on_tick(nb_tick:NATURAL_32)
		do
			if lib_ctrl.get_ticks>auto_move_tick+auto_move_delay then
				if auto_left_tetromino_rotation>0 then
					rotate_left
					auto_left_tetromino_rotation:=auto_left_tetromino_rotation-1
				elseif auto_right_tetromino_rotation>0 then
					rotate_right
					auto_right_tetromino_rotation:=auto_right_tetromino_rotation-1
				elseif not right_pressed and then auto_next_tetromino_position>currents_tetrominos.first.x then
					start_move_right
				elseif not left_pressed and then auto_next_tetromino_position<currents_tetrominos.first.x then
					start_move_left
				elseif right_pressed and then auto_next_tetromino_position<=currents_tetrominos.first.x then
					right_pressed:=false
				elseif left_pressed and then auto_next_tetromino_position>=currents_tetrominos.first.x then
					left_pressed:=false
				else
					down_pressed:=true
				end
				auto_move_tick:=lib_ctrl.get_ticks
			end
			precursor(nb_tick)
		end

	change_current_tetromino
		do
			precursor
			lib_ctrl.generate_new_random
			auto_next_tetromino_position:=lib_ctrl.last_random_integer_between (1, 7)
			lib_ctrl.generate_new_random
			auto_left_tetromino_rotation:=lib_ctrl.last_random_integer_between (0, 3)
			lib_ctrl.generate_new_random
			auto_right_tetromino_rotation:=lib_ctrl.last_random_integer_between (0, 3)
		end

	update_screen
		do

		end

	game_over
		do
			create pfield.make (theme_ctrl.playfield_x.to_integer_32, theme_ctrl.playfield_y.to_integer_32, theme_ctrl.block_width, theme_ctrl.block_height)
			mem.full_collect
		end

feature {NONE} -- Implementation - Variables

	auto_next_tetromino_position:INTEGER
	auto_left_tetromino_rotation:INTEGER
	auto_right_tetromino_rotation:INTEGER
	auto_down_delay:NATURAL
	auto_move_delay:NATURAL
	auto_move_tick:NATURAL

end
