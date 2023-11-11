extends VBoxContainer

@onready var PostID
var ScrollMode: bool
var CommunityInfo: Dictionary
var url = "/v1/communities/"+PostID+"/posts"

var PostInfo: PostRes

#This is an integer that is the "key" to getting the specific community's
#data from the Tbl

var UILink = {
	"username": "Meta/UserName",
	"yeahs": "Meta/Yeah",
	"icon": "Meta/UserIcon",
	"replies": "Meta/Replies",
	"body": "Content/Text",
	"screenshot": "Content/Screenshot",
	"painting": "Content/Painting",
}

func _ready():
	Satellite.connect("InitDir", setinfo, 4)
	Satellite.connect("Gohere", GrabFocus)

#Note to self: Change this info to work off of the community_id instead of localx
func setinfo(key):
	CommunityInfo = DaBa.Tbl["Communities"]["data"][key]
	PostID = CommunityInfo.get("community_id")
	changetext()

func changetext():
	for meta in ["name", "description", "community_id"]:
		if CommunityInfo.has(meta):
			var thing = UILink.get(meta)
			if thing == null:
				continue
			get_node(thing).text = CommunityInfo.get(meta)

func NewChangeText():
	for meta in UILink:
		PostInfo.get(meta)

func _on_community_pressed():
	if ScrollMode:
		print("Scrolling")
		return
	print(CommunityInfo.get("name"))
	var posts = ("/v1/commmunities/"+PostID+"/posts")
	API.MountedEXT = PostID
	API.FetchManager("Posts", PostID+"posts.xml")

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
	if where == PostID:
		self.grab_focus()

func ReplyRequest():
	pass

func _on_bubble_pressed():
	pass # Replace with function body.

func _on_yeah_toggled(button_pressed):
	pass # Replace with function body.

func _on_admin_opts_toggled(button_pressed):
	pass # Replace with function body.

func _on_dl_screenshot_pressed():
	pass # Replace with function body.

func _on_dl_painting_pressed():
	var image: Image = PostInfo.PaintingToImage()
	pass # Replace with function body.

func _on_replies_toggled(button_pressed):
	pass # Replace with function body.
