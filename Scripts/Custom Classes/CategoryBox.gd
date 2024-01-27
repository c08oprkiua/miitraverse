class_name CatBoxContainer
extends CategoryContainer

var my_content:BoxContainer = BoxContainer.new()

func _init():
	add_child(my_content, false, Node.INTERNAL_MODE_FRONT)
	super._init()

func get_box() ->BoxContainer:
	return my_content
