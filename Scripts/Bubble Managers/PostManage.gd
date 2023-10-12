extends VBoxContainer

@onready var PostID
var ScrollMode: bool
var CommunityInfo
var url = "/v1/communities/"+PostID+"/posts"
#This is an integer that is the "key" to getting the specific community's
#data from the Tbl

var UILink = {
	"username": "Meta/UserName",
	"yeahs": "Meta/Yeah",
	"icon": "Meta/UserIcon",
	"replies": "Meta/Replies",
	"text": "Content/Text",
	"screenshot": "Content/Screenshot",
	"painting": "Content/Painting",
}

func _ready():
	Satellite.connect("InitDir",setinfo, 4)
#	Satellite.connect("Processedicon", updooticon)
#	Satellite.connect("DownloadComplete", IsThisMyIcon)
	Satellite.connect("Gohere", GrabFocus)

#Note to self: Change this info to work off of the community_id instead of localx
func setinfo(key):
	CommunityInfo = DaBa.Tbl["Communities"]["data"][key]
	PostID = CommunityInfo.get("community_id")
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

func ProcessIcon():
	var b64raw = DaBa.communities[PostID].get("icon")
	if b64raw == null:
		return
	var de64d = Marshalls.base64_to_raw(b64raw)
	#This max is just gonna be a ridiculously high number cause idk what the
	#actual max size of a painting is tbh
	var de64d2 = de64d.decompress_dynamic(10000000, 3)
	var painting = Image.new().load_tga_from_buffer(de64d2)
	get_node(UILink.get("icon")).set_texture(ImageTexture.create_from_image(painting))

func _on_community_pressed():
	if ScrollMode:
		print("Scrolling")
		return
	print(CommunityInfo.get("name"))
	var posts = ("/v1/commmunities/"+PostID+"/posts")
	Network.MountedEXT = PostID
	Network.FetchManager("Posts")

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
