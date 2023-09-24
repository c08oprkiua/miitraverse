extends VBoxContainer

#I'm going to modify this script so that it can be dragged and dropped on the 
#different content loading pages, with the @export variables being changed to
#the relevent info so that I have to write less code for things that basically
# does the same thing :bigbrain:

@export var ItemPath = "res://Scenes/community.tscn"
@export_enum("Activity Feed", "Communities", "Home", "DMs", "Notifications", "Page") var PageInt: int

const ObjToLoad = {
	0: "Activity Feed",
	1: "res://Scenes/community.tscn",
	2: "Home",
	3: "DMs",
	4: "Notifications",
	
}
var DBToLoad = {
	0: "Activity Feed",
	1: DaBa.communities,
	2: "Landing Page",
	3: "DMs",
	4: "Notifications",
}

var IntToText = {
	0: "Activity Feed",
	1: "Communities",
	2: "Landing Page",
	3: "DMs",
	4: "Notifications",
}

var genericitem

func _ready():
	Satellite.connect("LoadInfo", ProceedLoadList)

func ProceedLoadList(check):
	var converted = IntToText.get(PageInt)
	print("Let's match")
	#Check a table that converts the int key to text value
	if not check == converted:
		print("No.")
		return
	if check == converted:
		print("Yay!", converted)
	else:
		print("No match")
	genericitem = load(ObjToLoad.get(PageInt))
	if get_child_count() > 0:
		for child in get_children():
			remove_child(child)
	var DataSize = DaBa.Tbl[converted].get("data").size()
	for i in range(0, DataSize):
		var CommData = DaBa.Tbl[converted]["data"].get(i)
		add_child(genericitem.instantiate())
		Satellite.emit_signal("InitDir", CommData)
