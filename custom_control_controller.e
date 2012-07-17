note
	description: "Summary description for {CUSTOM_CONTROL_CONTROLLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CUSTOM_CONTROL_CONTROLLER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do

		end


feature -- Access

	keyboard_enable:BOOLEAN
	keyboard_menu_up:NATURAL_8 assign set_keyboard_menu_up
	keyboard_menu_down:NATURAL_8 assign set_keyboard_menu_down
	keyboard_menu_left:NATURAL_8 assign set_keyboard_menu_left
	keyboard_menu_right:NATURAL_8 assign set_keyboard_menu_right
	keyboard_menu_enter:NATURAL_8 assign set_keyboard_menu_enter
	keyboard_menu_back:NATURAL_8 assign set_keyboard_menu_back
	keyboard_game_left:NATURAL_8 assign set_keyboard_game_left
	keyboard_game_right:NATURAL_8 assign set_keyboard_game_right
	keyboard_game_down:NATURAL_8 assign set_keyboard_game_down
	keyboard_game_drop:NATURAL_8 assign set_keyboard_game_drop
	keyboard_game_rotate_left:NATURAL_8 assign set_keyboard_game_rotate_left
	keyboard_game_rotate_right:NATURAL_8 assign set_keyboard_game_rotate_right
	keyboard_game_hold:NATURAL_8 assign set_keyboard_game_hold
	keyboard_game_pause:NATURAL_8 assign set_keyboard_game_pause


	joystick_enable:BOOLEAN
	joystick_device_id:NATURAL_8  assign set_joystick_device_id

	joystick_buttons_enable:BOOLEAN
	joystick_button_menu_up:NATURAL_8 assign set_joystick_button_menu_up
	joystick_button_menu_down:NATURAL_8 assign set_joystick_button_menu_down
	joystick_button_menu_left:NATURAL_8 assign set_joystick_button_menu_left
	joystick_button_menu_right:NATURAL_8 assign set_joystick_button_menu_right
	joystick_button_menu_enter:NATURAL_8 assign set_joystick_button_menu_enter
	joystick_button_menu_back:NATURAL_8 assign set_joystick_button_menu_back
	joystick_button_game_left:NATURAL_8 assign set_joystick_button_game_left
	joystick_button_game_right:NATURAL_8 assign set_joystick_button_game_right
	joystick_button_game_down:NATURAL_8 assign set_joystick_button_game_down
	joystick_button_game_drop:NATURAL_8 assign set_joystick_button_game_drop
	joystick_button_game_rotate_left:NATURAL_8 assign set_joystick_button_game_rotate_left
	joystick_button_game_rotate_right:NATURAL_8 assign set_joystick_button_game_rotate_right
	joystick_button_game_hold:NATURAL_8 assign set_joystick_button_game_hold
	joystick_button_game_pause:NATURAL_8 assign set_joystick_button_game_pause

	joystick_axis_enable:BOOLEAN
	joystick_axis_menu_up:TUPLE[lower_than,upper_than:INTEGER_16;axis_id:NATURAL_8]
	joystick_axis_menu_down:TUPLE[lower_than,upper_than:INTEGER_16;axis_id:NATURAL_8]
	joystick_axis_menu_left:TUPLE[lower_than,upper_than:INTEGER_16;axis_id:NATURAL_8]
	joystick_axis_menu_right:TUPLE[lower_than,upper_than:INTEGER_16;axis_id:NATURAL_8]
	joystick_axis_menu_enter:TUPLE[lower_than,upper_than:INTEGER_16;axis_id:NATURAL_8]
	joystick_axis_menu_back:TUPLE[lower_than,upper_than:INTEGER_16;axis_id:NATURAL_8]
	joystick_axis_game_left:TUPLE[lower_than,upper_than:INTEGER_16;axis_id:NATURAL_8]
	joystick_axis_game_right:TUPLE[lower_than,upper_than:INTEGER_16;axis_id:NATURAL_8]
	joystick_axis_game_down:TUPLE[lower_than,upper_than:INTEGER_16;axis_id:NATURAL_8]
	joystick_axis_game_drop:TUPLE[lower_than,upper_than:INTEGER_16;axis_id:NATURAL_8]
	joystick_axis_game_rotate_left:TUPLE[lower_than,upper_than:INTEGER_16;axis_id:NATURAL_8]
	joystick_axis_game_rotate_right:TUPLE[lower_than,upper_than:INTEGER_16;axis_id:NATURAL_8]
	joystick_axis_game_hold:TUPLE[lower_than,upper_than:INTEGER_16;axis_id:NATURAL_8]
	joystick_axis_game_pause:TUPLE[lower_than,upper_than:INTEGER_16;axis_id:NATURAL_8]

feature -- Setters


	enable_keyboard
		do
			keyboard_enable:=true
			keyboard_menu_up:=keyboard_menu_up.max_value
			keyboard_menu_down:=keyboard_menu_down.max_value
			keyboard_menu_left:=keyboard_menu_left.max_value
			keyboard_menu_right:=keyboard_menu_right.max_value
			keyboard_menu_back:=keyboard_menu_back.max_value
			keyboard_menu_enter:=keyboard_menu_enter.max_value
			keyboard_game_left:=keyboard_game_left.max_value
			keyboard_game_right:=keyboard_game_right.max_value
			keyboard_game_down:=keyboard_game_down.max_value
			keyboard_game_drop:=keyboard_game_drop.max_value
			keyboard_game_rotate_left:=keyboard_game_rotate_left.max_value
			keyboard_game_rotate_right:=keyboard_game_rotate_right.max_value
			keyboard_game_hold:=keyboard_game_hold.max_value
			keyboard_game_pause:=keyboard_game_pause.max_value
		end

	set_keyboard_menu_up(value:NATURAL_8)
		do
			keyboard_menu_up:=value
		end

	set_keyboard_menu_down(value:NATURAL_8)
		do
			keyboard_menu_down:=value
		end

	set_keyboard_menu_left(value:NATURAL_8)
		do
			keyboard_menu_left:=value
		end

	set_keyboard_menu_right(value:NATURAL_8)
		do
			keyboard_menu_right:=value
		end

	set_keyboard_menu_enter(value:NATURAL_8)
		do
			keyboard_menu_enter:=value
		end

	set_keyboard_menu_back(value:NATURAL_8)
		do
			keyboard_menu_back:=value
		end

	set_keyboard_game_left(value:NATURAL_8)
		do
			keyboard_game_left:=value
		end

	set_keyboard_game_right(value:NATURAL_8)
		do
			keyboard_game_right:=value
		end

	set_keyboard_game_down(value:NATURAL_8)
		do
			keyboard_game_down:=value
		end

	set_keyboard_game_drop(value:NATURAL_8)
		do
			keyboard_game_drop:=value
		end

	set_keyboard_game_rotate_left(value:NATURAL_8)
		do
			keyboard_game_rotate_left:=value
		end

	set_keyboard_game_rotate_right(value:NATURAL_8)
		do
			keyboard_game_rotate_right:=value
		end

	set_keyboard_game_hold(value:NATURAL_8)
		do
			keyboard_game_hold:=value
		end

	set_keyboard_game_pause(value:NATURAL_8)
		do
			keyboard_game_pause:=value
		end

	enable_joystick
		do
			joystick_enable:=true
		end

	set_joystick_device_id(value:NATURAL_8)
		do
			joystick_device_id:=value
		end

	enable_joystick_buttons
		do
			joystick_buttons_enable:=true
			joystick_button_menu_up:=joystick_button_menu_up.max_value
			joystick_button_menu_down:=joystick_button_menu_down.max_value
			joystick_button_menu_left:=joystick_button_menu_left.max_value
			joystick_button_menu_right:=joystick_button_menu_right.max_value
			joystick_button_menu_enter:=joystick_button_menu_enter.max_value
			joystick_button_menu_back:=joystick_button_menu_back.max_value
			joystick_button_game_left:=joystick_button_game_left.max_value
			joystick_button_game_right:=joystick_button_game_right.max_value
			joystick_button_game_down:=joystick_button_game_down.max_value
			joystick_button_game_drop:=joystick_button_game_drop.max_value
			joystick_button_game_rotate_left:=joystick_button_game_rotate_left.max_value
			joystick_button_game_rotate_right:=joystick_button_game_rotate_right.max_value
			joystick_button_game_hold:=joystick_button_game_hold.max_value
			joystick_button_game_pause:=joystick_button_game_pause.max_value
		end

	set_joystick_button_menu_up(value:NATURAL_8)
		do
			joystick_button_menu_up:=value
		end

	set_joystick_button_menu_down(value:NATURAL_8)
		do
			joystick_button_menu_down:=value
		end

	set_joystick_button_menu_left(value:NATURAL_8)
		do
			joystick_button_menu_left:=value
		end

	set_joystick_button_menu_right(value:NATURAL_8)
		do
			joystick_button_menu_right:=value
		end

	set_joystick_button_menu_enter(value:NATURAL_8)
		do
			joystick_button_menu_enter:=value
		end

	set_joystick_button_menu_back(value:NATURAL_8)
		do
			joystick_button_menu_back:=value
		end

	set_joystick_button_game_left(value:NATURAL_8)
		do
			joystick_button_game_left:=value
		end

	set_joystick_button_game_right(value:NATURAL_8)
		do
			joystick_button_game_right:=value
		end

	set_joystick_button_game_down(value:NATURAL_8)
		do
			joystick_button_game_down:=value
		end

	set_joystick_button_game_drop(value:NATURAL_8)
		do
			joystick_button_game_drop:=value
		end

	set_joystick_button_game_rotate_left(value:NATURAL_8)
		do
			joystick_button_game_rotate_left:=value
		end

	set_joystick_button_game_rotate_right(value:NATURAL_8)
		do
			joystick_button_game_rotate_right:=value
		end

	set_joystick_button_game_hold(value:NATURAL_8)
		do
			joystick_button_game_hold:=value
		end

	set_joystick_button_game_pause(value:NATURAL_8)
		do
			joystick_button_game_pause:=value
		end

	enable_joystick_axis
		local
			temp_int_16:INTEGER_16
			default_id:NATURAL_8
		do
			joystick_axis_enable:=true
			default_id:=default_id.max_value
			joystick_axis_menu_up:=[temp_int_16.min_value,temp_int_16.max_value,default_id]
			joystick_axis_menu_down:=[temp_int_16.min_value,temp_int_16.max_value,default_id]
			joystick_axis_menu_left:=[temp_int_16.min_value,temp_int_16.max_value,default_id]
			joystick_axis_menu_right:=[temp_int_16.min_value,temp_int_16.max_value,default_id]
			joystick_axis_menu_enter:=[temp_int_16.min_value,temp_int_16.max_value,default_id]
			joystick_axis_menu_back:=[temp_int_16.min_value,temp_int_16.max_value,default_id]
			joystick_axis_game_left:=[temp_int_16.min_value,temp_int_16.max_value,default_id]
			joystick_axis_game_right:=[temp_int_16.min_value,temp_int_16.max_value,default_id]
			joystick_axis_game_down:=[temp_int_16.min_value,temp_int_16.max_value,default_id]
			joystick_axis_game_drop:=[temp_int_16.min_value,temp_int_16.max_value,default_id]
			joystick_axis_game_rotate_left:=[temp_int_16.min_value,temp_int_16.max_value,default_id]
			joystick_axis_game_rotate_right:=[temp_int_16.min_value,temp_int_16.max_value,default_id]
			joystick_axis_game_hold:=[temp_int_16.min_value,temp_int_16.max_value,default_id]
			joystick_axis_game_pause:=[temp_int_16.min_value,temp_int_16.max_value,default_id]
		end

	set_joystick_axis_menu_up_axis_id(value:NATURAL_8)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_menu_up.axis_id:=value
		end

	set_joystick_axis_menu_up_lower_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_menu_up.lower_than:=value
		end

	set_joystick_axis_menu_up_upper_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_menu_up.upper_than:=value
		end

	set_joystick_axis_menu_down_axis_id(value:NATURAL_8)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_menu_down.axis_id:=value
		end

	set_joystick_axis_menu_down_lower_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_menu_down.lower_than:=value
		end

	set_joystick_axis_menu_down_upper_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_menu_down.upper_than:=value
		end

	set_joystick_axis_menu_left_axis_id(value:NATURAL_8)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_menu_left.axis_id:=value
		end

	set_joystick_axis_menu_left_lower_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_menu_left.lower_than:=value
		end

	set_joystick_axis_menu_left_upper_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_menu_left.upper_than:=value
		end

	set_joystick_axis_menu_right_axis_id(value:NATURAL_8)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_menu_right.axis_id:=value
		end

	set_joystick_axis_menu_right_lower_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_menu_right.lower_than:=value
		end

	set_joystick_axis_menu_right_upper_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_menu_right.upper_than:=value
		end

	set_joystick_axis_menu_enter_axis_id(value:NATURAL_8)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_menu_enter.axis_id:=value
		end

	set_joystick_axis_menu_enter_lower_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_menu_enter.lower_than:=value
		end

	set_joystick_axis_menu_enter_upper_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_menu_enter.upper_than:=value
		end

	set_joystick_axis_menu_back_axis_id(value:NATURAL_8)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_menu_back.axis_id:=value
		end

	set_joystick_axis_menu_back_lower_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_menu_back.lower_than:=value
		end

	set_joystick_axis_menu_back_upper_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_menu_back.upper_than:=value
		end

	set_joystick_axis_game_left_axis_id(value:NATURAL_8)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_left.axis_id:=value
		end

	set_joystick_axis_game_left_lower_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_left.lower_than:=value
		end

	set_joystick_axis_game_left_upper_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_left.upper_than:=value
		end

	set_joystick_axis_game_right_axis_id(value:NATURAL_8)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_right.axis_id:=value
		end

	set_joystick_axis_game_right_lower_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_right.lower_than:=value
		end

	set_joystick_axis_game_right_upper_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_right.upper_than:=value
		end

	set_joystick_axis_game_down_axis_id(value:NATURAL_8)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_down.axis_id:=value
		end

	set_joystick_axis_game_down_lower_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_down.lower_than:=value
		end

	set_joystick_axis_game_down_upper_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_down.upper_than:=value
		end

	set_joystick_axis_game_drop_axis_id(value:NATURAL_8)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_drop.axis_id:=value
		end

	set_joystick_axis_game_drop_lower_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_drop.lower_than:=value
		end

	set_joystick_axis_game_drop_upper_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_drop.upper_than:=value
		end

	set_joystick_axis_game_rotate_left_axis_id(value:NATURAL_8)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_rotate_left.axis_id:=value
		end

	set_joystick_axis_game_rotate_left_lower_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_rotate_left.lower_than:=value
		end

	set_joystick_axis_game_rotate_left_upper_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_rotate_left.upper_than:=value
		end

	set_joystick_axis_game_rotate_right_axis_id(value:NATURAL_8)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_rotate_right.axis_id:=value
		end

	set_joystick_axis_game_rotate_right_lower_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_rotate_right.lower_than:=value
		end

	set_joystick_axis_game_rotate_right_upper_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_rotate_right.upper_than:=value
		end

	set_joystick_axis_game_hold_axis_id(value:NATURAL_8)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_hold.axis_id:=value
		end

	set_joystick_axis_game_hold_lower_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_hold.lower_than:=value
		end

	set_joystick_axis_game_hold_upper_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_hold.upper_than:=value
		end

	set_joystick_axis_game_pause_axis_id(value:NATURAL_8)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_pause.axis_id:=value
		end

	set_joystick_axis_game_pause_lower_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_pause.lower_than:=value
		end

	set_joystick_axis_game_pause_upper_than(value:INTEGER_16)
		require
			Is_Joystick_Axis_Enable:joystick_axis_enable
		do
			joystick_axis_game_pause.upper_than:=value
		end

end
