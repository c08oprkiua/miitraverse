extends VSplitContainer
#Note: Code needs to be cleaned up at some point

@onready var CommID
var ScrollMode: bool
var CommunityInfo: CommRes

#This is an integer that is the "key" to getting the specific community's
#data from the Tbl

var UILink = {
	"name": "TopHalf/TopRight/Title",
	"description": "Description",
	"icon": "TopHalf/ItemIcon",
	"followers": "TopHalf/TopRight/PostNum",
}

func _ready():
	Satellite.connect("InitDir",setinfo, 4)
#	Satellite.connect("Processedicon", updooticon)
#	Satellite.connect("DownloadComplete", IsThisMyIcon)
	Satellite.connect("Gohere", GrabFocus)

#Note to self: Change this info to work off of the community_id instead of localx
func setinfo(key):
	CommunityInfo = DaBa.Tbl["Communities"]["data"][key]
	CommID = CommunityInfo.get("community_id")
	changetext()
	#ProcessIcon()
	#BrewInfo.changeicon(localx)

func changetext():
	for meta in ["name", "description", "community_id"]:
		if CommunityInfo.has(meta):
			var thing = UILink.get(meta)
			if thing == null:
				continue
			get_node(thing).text = CommunityInfo.get(meta)

#Icon setting/requesting
#func updooticon(arg1):
#	if is_same(CommID, arg1):
		#Commicon.set_texture(BrewInfo.Icon)
#		Satellite.disconnect("Processedicon", updooticon)
#		Satellite.disconnect("DownloadComplete", IsThisMyIcon)



func _on_bubble_pressed():
	if ScrollMode:
		print("Scrolling")
		return
	print(CommunityInfo.get("name"), CommID)
	API.MountedEXT = CommID
	API.FetchManager("Posts", "community.xml")
	Satellite.emit_signal("SwitchTabs", "Posts", true)

#func IsThisMyIcon():
#	BrewInfo.changeicon(CommID)

#Button related processes

func _notification(what):
	match what:
		NOTIFICATION_DRAG_BEGIN:
			ScrollMode = true
		NOTIFICATION_DRAG_END:
			ScrollMode = false

func GrabFocus(where):
	if where == CommID:
		self.grab_focus()


