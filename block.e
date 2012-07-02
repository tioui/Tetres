note
	description: "Summary description for {BLOCK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BLOCK

create
	make
	
feature {NONE} -- initialisation

	make(l_surface:GAME_SURFACE)
		do
			surface:=l_surface
		end

feature -- Access

	surface:GAME_SURFACE

end
