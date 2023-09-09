extends VBoxContainer
var genericitem = preload("res://Scenes/community.tscn")
@onready var CommunityList = self

func _ready():
	Satellite.connect("SafeRepo", ProceedLoadList)

func ProceedLoadList():
	if CommunityList.get_child_count() > 0:
		for child in CommunityList.get_children():
			CommunityList.remove_child(child)
	var list = database.communities.size()
	for i in range(0, list):
		CommunityList.add_child(genericitem.instantiate())
		Satellite.emit_signal("InitDir", i)
