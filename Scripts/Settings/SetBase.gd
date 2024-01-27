extends CatBoxContainer

#This script does the following:
#	Manages the (re)instancing of bubbles in the Settings category
#	Manages changing the color of bubbles when network is changed

var savedsettings: GlobalSettingRes

const base_pack:PackedScene = preload("res://Scenes/Content/globalsettings.tscn") as PackedScene
const prof_pack:PackedScene = preload("res://Scenes/Content/profile_settings.tscn") as PackedScene

#var fallbacknet = ProjectSettings.get_setting("MiiTraverse/Globals/Fallback_Network")
var fallbacknet: StringName = ProjectSettings.get_setting("MiiTraverse/Verse/Name")
var mountedcolor:Color

func _ready():
	my_content.vertical = true
	savedsettings = DaBa.SettingsCheck()
	if not DirAccess.dir_exists_absolute("user://Profile0"):
		DirAccess.make_dir_absolute("user://Profile0")
	DaBa.ProfileArrayFiller()
	ProfileArrayLoad()
	Satellite.connect("NewProfile", LoadProfileBubble)
	DaBa.CurrentProfile = savedsettings.DefaultNetwork #rain check this
	connect("WhenInactive", Satellite.emit_signal.bind("RefreshNetworks"))
	print("Settings init complete")

func ProfileArrayLoad():
	for childs in my_content.get_children():
		childs.queue_free()
	var bub:ContentBubble = ContentBubble.new(base_pack)
	my_content.add_child(bub)
	for profiles in DaBa.ProfileArray:
		bub = ContentBubble.new(prof_pack)
		my_content.add_child(bub)
		Satellite.emit_signal("LoadProfile", profiles)
	Satellite.emit_signal("RefreshNetworks")

func LoadProfileBubble(profval: int):
	DaBa.ProfileArray.append(profval)
	var bub:ContentBubble = ContentBubble.new(prof_pack)
	add_child(bub)
	Satellite.emit_signal("LoadProfile", profval)
