note
	description : "XML Loader for the game themes and configuration."
	author      : "Louis Marchand"
	date        : "July 19 2012"
	revision    : "1.0"

class
	INIT_CONTROLLER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		local
			init_file_name:STRING
			pars:XML_STANDARD_PARSER
			tree_pipe: XML_CALLBACKS_DOCUMENT
		do
			has_error:=false
			is_theme_set:=false
			init_file_name:="./init.xml"
			create pars.make
			create tree_pipe.make_null
			pars.set_callbacks (tree_pipe)
			pars.parse_from_path (create {PATH}.make_from_string(init_file_name))
			if pars.error_occurred then
				has_error:=true
				io.error.put_string (pars.error_message)
				io.error.flush
			else
				set_default_value
				process_document(tree_pipe.document)
				if not is_theme_set then
					has_error:=true
					io.error.put_string ("Error: init.xml file not valid!%N")
					io.error.flush
				end
			end
		ensure
			Init_Controller_No_Error_Found:not has_error
		end

	set_default_value
			-- Assign default values to status flags of `Current'
		do
			is_material_video_memory:=false
			is_material_double_buffer:=false
			is_ghost_show:=false
			is_font_cpf:=true
			custom_control_enable:=false
			is_sound_thread:=false
		end

	process_document(document:XML_DOCUMENT)
			-- Get values from a `document'
		local
			elements:LIST[XML_ELEMENT]
		do
			if document.root_element.name.is_equal ("init") then
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

		end

	process_element(element:XML_ELEMENT)
			-- Get values from a specific `element'
		do
			if element.name.is_equal ("theme") then
				process_theme_element(element)
			elseif element.name.is_equal ("material") then
				process_material_element(element)
			elseif element.name.is_equal ("ghost") then
				process_ghost_element(element)
			elseif element.name.is_equal ("cpf") then
				process_cpf_element(element)
			elseif element.name.is_equal ("custom_control") then
				process_custom_control_element(element)
			elseif element.name.is_equal ("sound") then
				process_sound_element(element)
			end
		end

	process_material_element(element:XML_ELEMENT)
			-- Get material values from `element'
		local
			attributes:LIST[XML_ATTRIBUTE]
		do
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("video_memory") then
					is_material_video_memory:=attributes.item_for_iteration.value.is_equal ("true")
				elseif attributes.item_for_iteration.name.is_equal ("double_buffer") then
					is_material_double_buffer:=attributes.item_for_iteration.value.is_equal ("true")
				end
				attributes.forth
			end
		end

	process_theme_element(element:XML_ELEMENT)
			-- Get theme values from `element'
		local
			is_theme_name_set:BOOLEAN
			attributes:LIST[XML_ATTRIBUTE]
		do
			is_theme_set:=false
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("name") then
					theme_name:=attributes.item_for_iteration.value
					is_theme_name_set:=true
				end
				attributes.forth
			end
			is_theme_set:=is_theme_name_set
		end

	process_ghost_element(element:XML_ELEMENT)
			-- Get tetrominos ghosts values from `element'
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
					is_ghost_show:=attributes.item_for_iteration.value.is_equal ("true")
				end
				attributes.forth
			end
		end

	process_cpf_element(element:XML_ELEMENT)
			-- Get fonts values from `element'
		local
			attributes:LIST[XML_ATTRIBUTE]
		do
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("font") then
					is_font_cpf:=attributes.item_for_iteration.value.is_equal ("true")
				end
				attributes.forth
			end
		end

	process_custom_control_element(element:XML_ELEMENT)
			-- Get controls values from `element'
		local
			elements:LIST[XML_ELEMENT]
		do
			custom_control_enable:=true
			create custom_control_ctrl.make
			elements:=element.elements
			from
				elements.start
			until
				elements.off
			loop
				if elements.item.name.is_equal ("keyboard") then
					process_custom_control_keyboard_element(elements.item)
				elseif elements.item.name.is_equal ("joystick") then
					process_custom_control_joystick_element(elements.item)
				end
				elements.forth
			end
		end

	process_custom_control_keyboard_element(element:XML_ELEMENT)
			-- Get keyboard control values from `element'
		local
			attributes:LIST[XML_ATTRIBUTE]
		do
			custom_control_ctrl.enable_keyboard
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("menu_up") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.keyboard_menu_up:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_down") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.keyboard_menu_down:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_left") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.keyboard_menu_left:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_right") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.keyboard_menu_right:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_enter") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.keyboard_menu_enter:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_back") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.keyboard_menu_back:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_left") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.keyboard_game_left:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_right") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.keyboard_game_right:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_down") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.keyboard_game_down:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_drop") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.keyboard_game_drop:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_rotate_left") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.keyboard_game_rotate_left:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_rotate_right") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.keyboard_game_rotate_right:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_hold") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.keyboard_game_hold:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_pause") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.keyboard_game_pause:=attributes.item_for_iteration.value.to_natural_8
					end
				end
				attributes.forth
			end
		end

	process_custom_control_joystick_element(element:XML_ELEMENT)
			-- Get joystick control values from `element'
		local
			attributes:LIST[XML_ATTRIBUTE]
			elements:LIST[XML_ELEMENT]
		do
			custom_control_ctrl.enable_joystick
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("device_id") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_device_id :=attributes.item_for_iteration.value.to_natural_8
					end
				end
				attributes.forth
			end
			elements:=element.elements
			from
				elements.start
			until
				elements.off
			loop
				if elements.item.name.is_equal ("buttons") then
					process_custom_control_joystick_buttons_element(elements.item)
				elseif elements.item.name.is_equal ("axis") then
					process_custom_control_joystick_axis_element(elements.item)
				end
				elements.forth
			end
		end

	process_custom_control_joystick_buttons_element(element:XML_ELEMENT)
			-- Get joystick buttons control values from `element'
		local
			attributes:LIST[XML_ATTRIBUTE]
		do
			custom_control_ctrl.enable_joystick_buttons
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("menu_up") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_button_menu_up:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_down") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_button_menu_down:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_left") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_button_menu_left:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_right") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_button_menu_right:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_enter") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_button_menu_enter:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_back") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_button_menu_back:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_left") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_button_game_left:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_right") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_button_game_right:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_down") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_button_game_down:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_drop") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_button_game_drop:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_rotate_left") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_button_game_rotate_left:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_rotate_right") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_button_game_rotate_right:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_hold") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_button_game_hold:=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_pause") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_button_game_pause:=attributes.item_for_iteration.value.to_natural_8
					end
				end
				attributes.forth
			end
		end


	process_custom_control_joystick_axis_element(element:XML_ELEMENT)
			-- Get joystck buttons control values from `element'
		local
			attributes:LIST[XML_ATTRIBUTE]
		do
			custom_control_ctrl.enable_joystick_axis
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("menu_up_lower_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_menu_up.lower_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_up_upper_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_menu_up.upper_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_up_axis_id") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_axis_menu_up.axis_id :=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_down_lower_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_menu_down.lower_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_down_upper_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_menu_down.upper_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_down_axis_id") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_axis_menu_down.axis_id :=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_left_lower_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_menu_left.lower_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_left_upper_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_menu_left.upper_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_left_axis_id") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_axis_menu_left.axis_id :=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_right_lower_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_menu_right.lower_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_right_upper_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_menu_right.upper_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_right_axis_id") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_axis_menu_right.axis_id :=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_enter_lower_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_menu_enter.lower_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_enter_upper_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_menu_enter.upper_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_enter_axis_id") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_axis_menu_enter.axis_id :=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_back_lower_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_menu_back.lower_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_back_upper_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_menu_back.upper_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("menu_back_axis_id") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_axis_menu_back.axis_id :=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_left_lower_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_game_left.lower_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_left_upper_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_game_left.upper_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_left_axis_id") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_axis_game_left.axis_id :=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_right_lower_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_game_right.lower_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_right_upper_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_game_right.upper_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_right_axis_id") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_axis_game_right.axis_id :=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_down_lower_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_game_down.lower_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_down_upper_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_game_down.upper_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_down_axis_id") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_axis_game_down.axis_id :=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_drop_lower_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_game_drop.lower_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_drop_upper_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_game_drop.upper_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_drop_axis_id") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_axis_game_drop.axis_id :=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_rotate_left_lower_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_game_rotate_left.lower_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_rotate_left_upper_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_game_rotate_left.upper_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_rotate_left_axis_id") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_axis_game_rotate_left.axis_id :=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_rotate_right_lower_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_game_rotate_right.lower_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_rotate_right_upper_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_game_rotate_right.upper_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_rotate_right_axis_id") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_axis_game_rotate_right.axis_id :=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_hold_lower_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_game_hold.lower_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_hold_upper_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_game_hold.upper_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_hold_axis_id") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_axis_game_hold.axis_id :=attributes.item_for_iteration.value.to_natural_8
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_pause_lower_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_game_pause.lower_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_pause_upper_than") then
					if attributes.item_for_iteration.value.is_integer_16 then
						custom_control_ctrl.joystick_axis_game_pause.upper_than:=attributes.item_for_iteration.value.to_integer_16
					end
				elseif attributes.item_for_iteration.name.is_equal ("game_pause_axis_id") then
					if attributes.item_for_iteration.value.is_natural_8 then
						custom_control_ctrl.joystick_axis_game_pause.axis_id :=attributes.item_for_iteration.value.to_natural_8
					end
				end
				attributes.forth
			end
		end

	process_sound_element(element:XML_ELEMENT)
			-- Get sound values from `element'
		local
			attributes:LIST[XML_ATTRIBUTE]
		do
			attributes:=element.attributes
			from
				attributes.start
			until
				attributes.off
			loop
				if attributes.item_for_iteration.name.is_equal ("thread") then
					is_sound_thread:=attributes.item_for_iteration.value.is_equal ("true")
				end
				attributes.forth
			end
		end

feature -- Access

	is_theme_set:BOOLEAN
			-- Status that indicate that a theme has been loaded.

	theme_name:STRING
			-- If `is_theme_set', the name of the theme that has been loaded.

	is_material_video_memory:BOOLEAN
			-- Status that indicate that material must be loaded in video memory
	is_material_double_buffer:BOOLEAN
			-- Status that indicate that the game must use double buffering

	is_ghost_show:BOOLEAN
			-- Status that indicate that a theme has tetromino ghosts.

	is_font_cpf:BOOLEAN
			-- Status that indicate that a theme has a font.

	custom_control_enable:BOOLEAN
			-- Status that indicate that a custon control has been set.

	custom_control_ctrl:CUSTOM_CONTROL_CONTROLLER
			-- If `custom_control_enable', the control controller that has been loaded.

	is_sound_thread:BOOLEAN
			-- Status that indicate that sound must be used in a multi-threaded context.


feature -- Error handelling

	has_error:BOOLEAN
			-- Status that indicate that there was an error in `Current'.

end
