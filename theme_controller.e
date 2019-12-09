note
	description: "Summary description for {THEME_CONTROLLER}."
	author      : "Louis Marchand"
	date        : "July 19 2012"
	revision    : "1.0"

class
	THEME_CONTROLLER

create
	make

feature {NONE} -- Initialization



	make(theme_name:STRING)
			-- Initialization for `Current'.
		local
			pars:XML_STANDARD_PARSER
			tree_pipe: XML_CALLBACKS_DOCUMENT
		do
			has_error:=false
			is_theme_set:=false
			is_playfield_set:=false
			is_block_set:=false
			is_menu_set:=false
			set_default_values(theme_name)
			create pars.make
			create tree_pipe.make_null
			pars.set_callbacks (tree_pipe)
			pars.parse_from_path (create {PATH}.make_from_string(config_file_name))
			if pars.error_occurred then
				has_error:=true
				io.error.put_string (pars.error_message)
				io.error.flush
			else
				process_document(tree_pipe.document)
				if not (is_theme_set and is_playfield_set and is_block_set and is_menu_set) then
					has_error:=true
					io.error.put_string ("Error: missing information in "+config_file_name+" file%N")
					io.error.flush
				end
			end
		ensure
			Theme_Controller_No_Error_Found:not has_error
		end

	set_default_values(theme_name:STRING)
		local

		do
			directory_name:="./theme/"+theme_name+"/"
			bpp:=16
			fullscreen:=false
			ghost_alpha:=100
			config_file_name:=directory_name+"config.xml"
			bg_file_name:=directory_name+"bg.bmp"
			blocks_file_name:=directory_name+"blocks.bmp"
			font_file_name:=directory_name+"font.ttf"
			arrow_file_name:=directory_name+"arrow.bmp"
			menu_init_file_name:=directory_name+"menu-init.bmp"
			menu_resume_file_name:=directory_name+"menu-resume.bmp"
			game_over_file_name:=directory_name+"game-over.bmp"
			lines_anim_file_name:=directory_name+"lines_anim.bmp"
			is_title_screen:=false
			title_delay:=2000
			menu_resume_mirror:=false
			menu_new_game_mirror:=false
			menu_settings_mirror:=false
			menu_quit_mirror:=false
			block_rotation:=false
			menu_bg_alpha:=80
			game_over_time:=2000
			hold_field_show:=false
			next_field_show:=false
			score_show:=false
			lines_show:=false
			level_show:=false
			font_size:=50
			font_color:="000000"
			lines_anim_show:=false
			lines_anim_delay:=1000
			is_sound_menu_move:=false
			is_sound_menu_enter:=false
			is_sound_game_rotation:=false
			is_sound_game_drop:=false
			is_sound_game_move:=false
			is_sound_game_anim:=false
			is_sound_game_collapse:=false
			is_sound_game_down:=false
			is_music_game:=false
			is_music_game_intro:=false
			is_music_menu:=false
			is_music_menu_intro:=false
		end

	process_document(document:XML_DOCUMENT)
		local
			elements:LIST[XML_ELEMENT]
		do
			process_element(document.root_element)
			elements:=document.root_element.elements
			from
				elements.start
			until
				elements.off
			loop
				process_element(elements.item_for_iteration)
				elements.forth
			end
		end

	process_element(element:XML_ELEMENT)
		do
			if element.name.is_equal ("theme") then
				process_theme_element(element)
			elseif element.name.is_equal ("block") then
				process_block_element(element)
			elseif element.name.is_equal ("playfield") then
				process_playfield_element(element)
			elseif element.name.is_equal ("ghost") then
				process_ghost_element(element)
			elseif element.name.is_equal ("files") then
				process_files_element(element)
			elseif element.name.is_equal ("menu") then
				process_menu_element(element)
			elseif element.name.is_equal ("game_over") then
				process_game_over_element(element)
			elseif element.name.is_equal ("hold_field") then
				process_hold_field_element(element)
			elseif element.name.is_equal ("next_field") then
				process_next_field_element(element)
			elseif element.name.is_equal ("font") then
				process_font_element(element)
			elseif element.name.is_equal ("score") then
				process_score_element(element)
			elseif element.name.is_equal ("lines") then
				process_lines_element(element)
			elseif element.name.is_equal ("level") then
				process_level_element(element)
			elseif element.name.is_equal ("lines_anim") then
				process_lines_anim_element(element)
			elseif element.name.is_equal ("title") then
				process_title_element(element)
			end
		end

	process_playfield_element(element:XML_ELEMENT)
		local
			is_x_set:BOOLEAN
			is_y_set:BOOLEAN
			attributes:LIST[XML_ATTRIBUTE]
		do
			is_x_set:=false
			is_y_set:=false
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("x") then
					if attributes.item_for_iteration.value.is_integer then
						playfield_x:=attributes.item_for_iteration.value.to_integer
						is_x_set:=true
					end
				elseif attributes.item_for_iteration.name.is_equal ("y") then
					if attributes.item_for_iteration.value.is_integer then
						playfield_y:=attributes.item_for_iteration.value.to_integer
						is_y_set:=true
					end
				end
				attributes.forth
			end
			is_playfield_set:=is_x_set and then is_y_set
		end

	process_hold_field_element(element:XML_ELEMENT)
		local
			attributes:LIST[XML_ATTRIBUTE]
		do
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("x") then
					if attributes.item_for_iteration.value.is_integer then
						hold_field_x:=attributes.item_for_iteration.value.to_integer
					end
				elseif attributes.item_for_iteration.name.is_equal ("y") then
					if attributes.item_for_iteration.value.is_integer then
						hold_field_y:=attributes.item_for_iteration.value.to_integer
					end
				elseif attributes.item_for_iteration.name.is_equal ("show") then
					hold_field_show:=attributes.item_for_iteration.value.is_equal ("true")
				end
				attributes.forth
			end
		end

	process_font_element(element:XML_ELEMENT)
		local
			attributes:LIST[XML_ATTRIBUTE]
		do
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("size") then
					if attributes.item_for_iteration.value.is_integer then
						font_size:=attributes.item_for_iteration.value.to_integer
					end
				elseif attributes.item_for_iteration.name.is_equal ("color") then
					font_color:=attributes.item_for_iteration.value
				end
				attributes.forth
			end
		end

	process_title_element(element:XML_ELEMENT)
		local
			attributes:LIST[XML_ATTRIBUTE]
		do
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("delay") then
					if attributes.item_for_iteration.value.is_natural then
						title_delay:=attributes.item_for_iteration.value.to_natural
					end
				end
				attributes.forth
			end
		end

	process_lines_anim_element(element:XML_ELEMENT)
		local
			attributes:LIST[XML_ATTRIBUTE]
		do
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("show") then
					lines_anim_show:=attributes.item_for_iteration.value.is_equal ("true")
				elseif attributes.item_for_iteration.name.is_equal ("delay") then
					if attributes.item_for_iteration.value.is_natural then
						lines_anim_delay:=attributes.item_for_iteration.value.to_natural
					end
				elseif attributes.item_for_iteration.name.is_equal ("step") then
					if attributes.item_for_iteration.value.is_natural then
						lines_anim_step:=attributes.item_for_iteration.value.to_natural
					end
				end
				attributes.forth
			end
		end

	process_score_element(element:XML_ELEMENT)
		local
			attributes:LIST[XML_ATTRIBUTE]
		do
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("x") then
					if attributes.item_for_iteration.value.is_integer then
						score_x:=attributes.item_for_iteration.value.to_integer
					end
				elseif attributes.item_for_iteration.name.is_equal ("y") then
					if attributes.item_for_iteration.value.is_integer then
						score_y:=attributes.item_for_iteration.value.to_integer
					end
				elseif attributes.item_for_iteration.name.is_equal ("width") then
					if attributes.item_for_iteration.value.is_integer then
						score_w:=attributes.item_for_iteration.value.to_integer
					end
				elseif attributes.item_for_iteration.name.is_equal ("show") then
					score_show:=attributes.item_for_iteration.value.is_equal ("true")
				end
				attributes.forth
			end
		end

	process_level_element(element:XML_ELEMENT)
		local
			attributes:LIST[XML_ATTRIBUTE]
		do
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("x") then
					if attributes.item_for_iteration.value.is_integer then
						level_x:=attributes.item_for_iteration.value.to_integer
					end
				elseif attributes.item_for_iteration.name.is_equal ("y") then
					if attributes.item_for_iteration.value.is_integer then
						level_y:=attributes.item_for_iteration.value.to_integer
					end
				elseif attributes.item_for_iteration.name.is_equal ("show") then
					level_show:=attributes.item_for_iteration.value.is_equal ("true")
				end
				attributes.forth
			end
		end

	process_lines_element(element:XML_ELEMENT)
		local
			attributes:LIST[XML_ATTRIBUTE]
		do
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("x") then
					if attributes.item_for_iteration.value.is_integer then
						lines_x:=attributes.item_for_iteration.value.to_integer
					end
				elseif attributes.item_for_iteration.name.is_equal ("y") then
					if attributes.item_for_iteration.value.is_integer then
						lines_y:=attributes.item_for_iteration.value.to_integer
					end
				elseif attributes.item_for_iteration.name.is_equal ("width") then
					if attributes.item_for_iteration.value.is_integer then
						lines_w:=attributes.item_for_iteration.value.to_integer
					end
				elseif attributes.item_for_iteration.name.is_equal ("show") then
					lines_show:=attributes.item_for_iteration.value.is_equal ("true")
				end
				attributes.forth
			end
		end

	process_next_field_element(element:XML_ELEMENT)
		local
			attributes:LIST[XML_ATTRIBUTE]
		do
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("x") then
					if attributes.item_for_iteration.value.is_integer then
						next_field_x:=attributes.item_for_iteration.value.to_integer
					end
				elseif attributes.item_for_iteration.name.is_equal ("y") then
					if attributes.item_for_iteration.value.is_integer then
						next_field_y:=attributes.item_for_iteration.value.to_integer
					end
				elseif attributes.item_for_iteration.name.is_equal ("padding") then
					if attributes.item_for_iteration.value.is_integer then
						next_field_padding:=attributes.item_for_iteration.value.to_integer
					end
					elseif attributes.item_for_iteration.name.is_equal ("nb_tetrominos") then
					if attributes.item_for_iteration.value.is_integer then
						next_field_nb:=attributes.item_for_iteration.value.to_integer
					end
				elseif attributes.item_for_iteration.name.is_equal ("show") then
					next_field_show:=attributes.item_for_iteration.value.is_equal ("true")
				elseif attributes.item_for_iteration.name.is_equal ("vertical") then
					next_field_vertical:=attributes.item_for_iteration.value.is_equal ("true")
				end
				attributes.forth
			end
		end

	process_block_element(element:XML_ELEMENT)
		local
			is_width_set:BOOLEAN
			is_height_set:BOOLEAN
			attributes:LIST[XML_ATTRIBUTE]
		do
			is_width_set:=false
			is_height_set:=false
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("width") then
					if attributes.item_for_iteration.value.is_natural then
						block_width:=attributes.item_for_iteration.value.to_natural
						is_width_set:=true
					end
				elseif attributes.item_for_iteration.name.is_equal ("height") then
					if attributes.item_for_iteration.value.is_natural then
						block_height:=attributes.item_for_iteration.value.to_natural
						is_height_set:=true
					end
				elseif attributes.item_for_iteration.name.is_equal ("rotation") then
					block_rotation:=attributes.item_for_iteration.value.is_equal ("true")
				end
				attributes.forth
			end
			is_block_set:=is_width_set and then is_height_set
		end

	process_game_over_element(element:XML_ELEMENT)
		local
			attributes:LIST[XML_ATTRIBUTE]
		do
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("time") then
					if attributes.item_for_iteration.value.is_natural_32 then
						game_over_time:=attributes.item_for_iteration.value.to_natural_32
					end
				end
				attributes.forth
			end
		end

	process_ghost_element(element:XML_ELEMENT)
		local
			attributes:LIST[XML_ATTRIBUTE]
		do
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("alpha") then
					if attributes.item_for_iteration.value.is_natural_8 then
						ghost_alpha:=attributes.item_for_iteration.value.to_natural_8
					end
				end
				attributes.forth
			end
		end

	process_files_element(element:XML_ELEMENT)
		local
			attributes:LIST[XML_ATTRIBUTE]
		do
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("arrow") then
					arrow_file_name:=directory_name+attributes.item_for_iteration.value
				elseif attributes.item_for_iteration.name.is_equal ("blocks")then
					blocks_file_name:=directory_name+attributes.item_for_iteration.value
				elseif attributes.item_for_iteration.name.is_equal ("bg")then
					bg_file_name:=directory_name+attributes.item_for_iteration.value
				elseif attributes.item_for_iteration.name.is_equal ("font")then
					font_file_name:=directory_name+attributes.item_for_iteration.value
				elseif attributes.item_for_iteration.name.is_equal ("menu_init")then
					menu_init_file_name:=directory_name+attributes.item_for_iteration.value
				elseif attributes.item_for_iteration.name.is_equal ("menu_resume")then
					menu_resume_file_name:=directory_name+attributes.item_for_iteration.value
				elseif attributes.item_for_iteration.name.is_equal ("game_over")then
					game_over_file_name:=directory_name+attributes.item_for_iteration.value
				elseif attributes.item_for_iteration.name.is_equal ("title")then
					is_title_screen:=true
					title_file_name:=directory_name+attributes.item_for_iteration.value
				elseif attributes.item_for_iteration.name.is_equal ("lines_anim")then
					lines_anim_file_name:=directory_name+attributes.item_for_iteration.value
				elseif attributes.item_for_iteration.name.is_equal ("sound_menu_move")then
					is_sound_menu_move:=true
					is_sound_enable:=true
					sound_menu_move_file:=directory_name+attributes.item_for_iteration.value
				elseif attributes.item_for_iteration.name.is_equal ("sound_menu_enter")then
					is_sound_menu_enter:=true
					is_sound_enable:=true
					sound_menu_enter_file:=directory_name+attributes.item_for_iteration.value
				elseif attributes.item_for_iteration.name.is_equal ("sound_game_rotation")then
					is_sound_game_rotation:=true
					is_sound_enable:=true
					sound_game_rotation_file:=directory_name+attributes.item_for_iteration.value
				elseif attributes.item_for_iteration.name.is_equal ("sound_game_drop")then
					is_sound_game_drop:=true
					is_sound_enable:=true
					sound_game_drop_file:=directory_name+attributes.item_for_iteration.value
				elseif attributes.item_for_iteration.name.is_equal ("sound_game_move")then
					is_sound_game_move:=true
					is_sound_enable:=true
					sound_game_move_file:=directory_name+attributes.item_for_iteration.value
				elseif attributes.item_for_iteration.name.is_equal ("sound_game_down")then
					is_sound_game_down:=true
					is_sound_enable:=true
					sound_game_down_file:=directory_name+attributes.item_for_iteration.value
				elseif attributes.item_for_iteration.name.is_equal ("sound_game_anim")then
					is_sound_game_anim:=true
					is_sound_enable:=true
					sound_game_anim_file:=directory_name+attributes.item_for_iteration.value
				elseif attributes.item_for_iteration.name.is_equal ("sound_game_collapse")then
					is_sound_game_collapse:=true
					is_sound_enable:=true
					sound_game_collapse_file:=directory_name+attributes.item_for_iteration.value
				elseif attributes.item_for_iteration.name.is_equal ("music_game_loop")then
					is_music_game:=true
					is_sound_enable:=true
					music_game_loop_file:=directory_name+attributes.item_for_iteration.value
				elseif attributes.item_for_iteration.name.is_equal ("music_game_intro")then
					is_music_game_intro:=true
					is_sound_enable:=true
					music_game_intro_file:=directory_name+attributes.item_for_iteration.value
				elseif attributes.item_for_iteration.name.is_equal ("music_menu_loop")then
					is_music_menu:=true
					is_sound_enable:=true
					music_menu_loop_file:=directory_name+attributes.item_for_iteration.value
				elseif attributes.item_for_iteration.name.is_equal ("music_menu_intro")then
					is_music_menu_intro:=true
					is_sound_enable:=true
					music_menu_intro_file:=directory_name+attributes.item_for_iteration.value
				end
				attributes.forth
			end
		end

	process_theme_element(element:XML_ELEMENT)
		local
			is_name_set:BOOLEAN
			is_width_set:BOOLEAN
			is_height_set:BOOLEAN
			attributes:LIST[XML_ATTRIBUTE]
		do
			is_name_set:=false
			is_width_set:=false
			is_height_set:=false
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("name") then
					name:=attributes.item_for_iteration.value
					is_name_set:=true
				elseif attributes.item_for_iteration.name.is_equal ("width") then
					if attributes.item_for_iteration.value.is_natural then
						width:=attributes.item_for_iteration.value.to_natural
						is_width_set:=true
					end
				elseif attributes.item_for_iteration.name.is_equal ("height") then
					if attributes.item_for_iteration.value.is_natural then
						height:=attributes.item_for_iteration.value.to_natural
						is_height_set:=true
					end
				elseif attributes.item_for_iteration.name.is_equal ("bpp") then
					if attributes.item_for_iteration.value.is_natural then
						bpp:=attributes.item_for_iteration.value.to_natural
					end
				elseif attributes.item_for_iteration.name.is_equal ("fullscreen") then
						fullscreen:=attributes.item_for_iteration.value.is_equal ("true")
				end
				attributes.forth
			end
			is_theme_set:=is_name_set and then is_width_set and then is_height_set
		end

	process_menu_element(element:XML_ELEMENT)
		local
			is_resume_x_set:BOOLEAN
			is_resume_y_set:BOOLEAN
			is_new_game_x_set:BOOLEAN
			is_new_game_y_set:BOOLEAN
			is_quit_x_set:BOOLEAN
			is_quit_y_set:BOOLEAN
			attributes:LIST[XML_ATTRIBUTE]
		do
			is_resume_x_set:=false
			is_resume_y_set:=false
			is_new_game_x_set:=false
			is_new_game_y_set:=false
			is_quit_x_set:=false
			is_quit_y_set:=false
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("resume_x") then
					if attributes.item_for_iteration.value.is_integer then
						menu_resume_x:=attributes.item_for_iteration.value.to_integer
						is_resume_x_set:=true
					end
				elseif attributes.item_for_iteration.name.is_equal ("resume_y") then
					if attributes.item_for_iteration.value.is_integer then
						menu_resume_y:=attributes.item_for_iteration.value.to_integer
						is_resume_y_set:=true
					end
				elseif attributes.item_for_iteration.name.is_equal ("new_game_x") then
					if attributes.item_for_iteration.value.is_integer then
						menu_new_game_x:=attributes.item_for_iteration.value.to_integer
						is_new_game_x_set:=true
					end
				elseif attributes.item_for_iteration.name.is_equal ("new_game_y") then
					if attributes.item_for_iteration.value.is_integer then
						menu_new_game_y:=attributes.item_for_iteration.value.to_integer
						is_new_game_y_set:=true
					end
				elseif attributes.item_for_iteration.name.is_equal ("quit_x") then
					if attributes.item_for_iteration.value.is_integer then
						menu_quit_x:=attributes.item_for_iteration.value.to_integer
						is_quit_x_set:=true
					end
				elseif attributes.item_for_iteration.name.is_equal ("quit_y") then
					if attributes.item_for_iteration.value.is_integer then
						menu_quit_y:=attributes.item_for_iteration.value.to_integer
						is_quit_y_set:=true
					end
				elseif attributes.item_for_iteration.name.is_equal ("bg_alpha") then
					if attributes.item_for_iteration.value.is_natural_8 then
						menu_bg_alpha:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("resume_mirror") then
					menu_resume_mirror:=attributes.item_for_iteration.value.is_equal ("true")
				elseif attributes.item_for_iteration.name.is_equal ("new_game_mirror") then
					menu_new_game_mirror:=attributes.item_for_iteration.value.is_equal ("true")
				elseif attributes.item_for_iteration.name.is_equal ("settings_mirror") then
					menu_settings_mirror:=attributes.item_for_iteration.value.is_equal ("true")
				elseif attributes.item_for_iteration.name.is_equal ("quit_mirror") then
					menu_quit_mirror:=attributes.item_for_iteration.value.is_equal ("true")
				end
				attributes.forth
			end


			is_menu_set:=	is_resume_x_set and is_resume_y_set and is_new_game_x_set and is_new_game_y_set and
							is_quit_x_set and is_quit_y_set
		end

feature -- Access

	is_theme_set:BOOLEAN
	is_block_set:BOOLEAN
	is_playfield_set:BOOLEAN
	is_next_field_set:BOOLEAN
	is_menu_set:BOOLEAN
	is_title_screen:BOOLEAN

	name:STRING
	width:NATURAL
	height:NATURAL

	block_width:NATURAL
	block_height:NATURAL
	block_rotation:BOOLEAN

	playfield_x:INTEGER
	playfield_y:INTEGER

	bpp:NATURAL

	fullscreen:BOOLEAN

	directory_name:STRING
	config_file_name:STRING
	bg_file_name:STRING
	blocks_file_name:STRING
	menu_init_file_name:STRING
	menu_resume_file_name:STRING
	font_file_name:STRING
	arrow_file_name:STRING
	game_over_file_name:STRING
	lines_anim_file_name:STRING
	title_file_name:STRING

	title_delay:NATURAL

	ghost_alpha:NATURAL_8

	menu_resume_x:INTEGER
	menu_resume_y:INTEGER
	menu_new_game_x:INTEGER
	menu_new_game_y:INTEGER
	menu_quit_x:INTEGER
	menu_quit_y:INTEGER
	menu_resume_mirror:BOOLEAN
	menu_new_game_mirror:BOOLEAN
	menu_settings_mirror:BOOLEAN
	menu_quit_mirror:BOOLEAN
	menu_bg_alpha:NATURAL_8

	game_over_time:NATURAL_32

	hold_field_show:BOOLEAN
	hold_field_x:INTEGER
	hold_field_y:INTEGER

	next_field_show:BOOLEAN
	next_field_x:INTEGER
	next_field_y:INTEGER
	next_field_vertical:BOOLEAN
	next_field_padding:INTEGER
	next_field_nb:INTEGER

	font_size:INTEGER
	font_color:STRING

	score_show:BOOLEAN
	score_x:INTEGER
	score_y:INTEGER
	score_w:INTEGER

	lines_show:BOOLEAN
	lines_x:INTEGER
	lines_y:INTEGER
	lines_w:INTEGER

	level_show:BOOLEAN
	level_x:INTEGER
	level_y:INTEGER

	lines_anim_show:BOOLEAN
	lines_anim_delay:NATURAL
	lines_anim_step:NATURAL

	is_sound_enable:BOOLEAN
	is_sound_menu_move:BOOLEAN
	sound_menu_move_file:STRING
	is_sound_menu_enter:BOOLEAN
	sound_menu_enter_file:STRING
	is_sound_game_rotation:BOOLEAN
	sound_game_rotation_file:STRING
	is_sound_game_drop:BOOLEAN
	sound_game_drop_file:STRING
	is_sound_game_move:BOOLEAN
	sound_game_move_file:STRING
	is_sound_game_down:BOOLEAN
	sound_game_down_file:STRING
	is_sound_game_anim:BOOLEAN
	sound_game_anim_file:STRING
	is_sound_game_collapse:BOOLEAN
	sound_game_collapse_file:STRING

	is_music_game:BOOLEAN
	is_music_game_intro:BOOLEAN
	music_game_intro_file:STRING
	music_game_loop_file:STRING

	is_music_menu:BOOLEAN
	is_music_menu_intro:BOOLEAN
	music_menu_intro_file:STRING
	music_menu_loop_file:STRING

feature -- Error handelling

	has_error:BOOLEAN



end
