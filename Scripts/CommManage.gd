extends PanelContainer
#Note: Code needs to be cleaned up at some point

@onready var Bubble = $"Bubble"
@onready var CommunityInfo 
@onready var CommID

#This is an integer that is the "key" to getting the specific community's
#data from the Tbl
var CommKey

var UILink = {
	"name": "Margins/Content/TopHalf/TopRight/Title",
	"description": "Margins/Content/Description",
	"icon": "Margins/Content/TopHalf/ItemIcon",
	"followers": "Margins/Content/TopHalf/TopRight/PostNum",
}


func _ready():
	Satellite.connect("InitDir",setinfo, 4)
#	Satellite.connect("Processedicon", updooticon)
#	Satellite.connect("DownloadComplete", IsThisMyIcon)
	Satellite.connect("Gohere", GrabFocus)
	Bubble.self_modulate = DaBa.GlobalColorTint
	Satellite.connect("ColorTint", ChangeColor)


func ChangeColor(newtint):
	Bubble.self_modulate = newtint


#Note to self: Change this info to work off of the community_id instead of localx
func setinfo(CommData):
	CommunityInfo = CommData
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

func ProcessIcon():
	var b64raw = DaBa.communities[CommID].get("icon")
	if b64raw == null:
		return
	var de64d = Marshalls.base64_to_raw(b64raw)
	#This max is just gonna be a ridiculously high number cause idk what the
	#actual max size of a painting is tbh
	var de64d2 = de64d.decompress_dynamic(10000000, 3)
	var painting = Image.new().load_tga_from_buffer(de64d2)
	get_node(UILink.get("icon")).set_texture(ImageTexture.create_from_image(painting))

func _on_community_pressed():
	print(CommunityInfo.get("name"))
	var posts = ("/v1/commmunities/"+CommID+"/posts")
	print(posts)

#func IsThisMyIcon():
#	BrewInfo.changeicon(CommID)

#Button related processes

func GrabFocus(where):
	if where == CommID:
		self.grab_focus()
