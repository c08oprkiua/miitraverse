extends TextureButton
#Note: Code needs to be cleaned up at some point

var BrewInfo
var BetterDownloading

@onready var genericitem = $"."
@onready var Commicon = $"GenericItem/VBoxContainer/HSplitContainer/ItemIcon"
@onready var Commname = $"VBoxContainer/HSplitContainer/Title"
@onready var Commdesc = $"VBoxContainer/RichTextLabel"
@onready var localx

func _ready():
	Satellite.connect("InitDir",setinfo, 4)
	Satellite.connect("Processedicon", updooticon)
	Satellite.connect("DownloadComplete", IsThisMyIcon)
	Satellite.connect("Gohere", GrabFocus)

func setinfo(arg1):
	localx = arg1
	changetext()
	ProcessIcon()
	#BrewInfo.changeicon(localx)

func changetext():
	Commname.text = database.communities[localx].get("name")
	Commdesc.text = database.communities[localx].get("description")

#Icon setting/requesting
func updooticon(arg1):
	if is_same(localx, arg1):
		#Commicon.set_texture(BrewInfo.Icon)
		Satellite.disconnect("Processedicon", updooticon)
		Satellite.disconnect("DownloadComplete", IsThisMyIcon)

func ProcessIcon():
	var b64raw = database.communities[localx].get("icon")
	var de64d = Marshalls.base64_to_variant(b64raw)
	var image = Image.new().create_from_data(128, 18, false, Image.FORMAT_ETC2_R11, de64d)
	Commicon.set_texture(image)

func IsThisMyIcon():
	BrewInfo.changeicon(localx)

#Button related processes

func whenfocus():
	BrewInfo.updatevars(localx)
	Satellite.emit_signal("Thisitem", localx)
	if FileAccess.file_exists(BrewInfo.UserFiles+"Icons/"+BrewInfo.appname+".png"):
		BrewInfo.changeicon(localx)
	else:
		BetterDownloading.DownloadIcon(BrewInfo.appname)

func GrabFocus(where):
	if where == localx:
		self.grab_focus()

func _on_focus_entered():
	whenfocus()

func _on_mouse_entered():
	whenfocus()


