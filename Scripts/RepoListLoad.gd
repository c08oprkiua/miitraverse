extends Node
var genericitem = preload("res://Scenes/community.tscn")

func _ready():
	Satellite.connect("SafeRepo", ProceedLoadList)

func ProceedLoadList():
	if get_child_count() > 0:
		for child in get_children():
			remove_child(child)
	var list #= BrewInfo.Information.packages.size()
	for i in range(0, list):
		add_child(genericitem.instantiate())
		Satellite.emit_signal("InitDir", i)
