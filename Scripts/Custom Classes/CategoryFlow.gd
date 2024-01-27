class_name CatFlowContainer
extends CategoryContainer

var my_content:FlowContainer = FlowContainer.new()

func _init():
	add_child(my_content, false, Node.INTERNAL_MODE_FRONT)
	super._init()

func get_flow() -> FlowContainer:
	return my_content
