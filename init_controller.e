note
	description: "Summary description for {INIT_CONTROLLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INIT_CONTROLLER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		local
			init_file_name:STRING
			pars:XML_LITE_PARSER
			tree_pipe: XML_CALLBACKS_DOCUMENT
		do
			has_error:=false
			is_theme_set:=false
			init_file_name:="./init.xml"
			create pars.make
			create tree_pipe.make_null
			pars.set_callbacks (tree_pipe)
			pars.parse_from_filename (init_file_name)
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
		do
			is_material_video_memory:=false
			is_material_double_buffer:=false
			is_ghost_show:=false
			is_font_cpf:=true
		end

	process_document(document:XML_DOCUMENT)
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
		do
			if element.name.is_equal ("theme") then
				process_theme_element(element)
			elseif element.name.is_equal ("material") then
				process_material_element(element)
			elseif element.name.is_equal ("ghost") then
				process_ghost_element(element)
			elseif element.name.is_equal ("cpf") then
				process_cpf_element(element)
			end
		end

	process_material_element(element:XML_ELEMENT)
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

feature -- Access

	is_theme_set:BOOLEAN
	theme_name:STRING

	is_material_video_memory:BOOLEAN
	is_material_double_buffer:BOOLEAN

	is_ghost_show:BOOLEAN

	is_font_cpf:BOOLEAN

feature -- Error handelling

	has_error:BOOLEAN

end
