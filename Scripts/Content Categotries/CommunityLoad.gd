extends VBoxContainer

#I'm going to modify this script so that it can be dragged and dropped on the 
#different content loading pages, with the @export variables being changed to
#the relevent info so that I have to write less code for things that basically
# does the same thing :bigbrain:

var ItemPath = "res://Scenes/community.tscn"
var genericitem 
var CommunityList = self

func _ready():
	Satellite.connect("SafeRepo", ProceedLoadList)

func ProceedLoadList():
	genericitem = load(ItemPath)
	if CommunityList.get_child_count() > 0:
		for child in CommunityList.get_children():
			CommunityList.remove_child(child)
	var list = database.communities.size()
	for i in range(0, list):
		var CommData = database.communities[i]
		CommunityList.add_child(genericitem.instantiate())
		Satellite.emit_signal("InitDir", CommData)
