extends CatBoxContainer

#This script does the following:
#	Manages the (re)instancing of bubbles in the Settings category
#	Manages changing the color of bubbles when network is changed

var savedsettings: GlobalSettingRes

static var base_pack:PackedScene = preload("res://Scenes/Content/globalsettings.tscn") as PackedScene
static var prof_pack:PackedScene = preload("res://Scenes/Content/profile_settings.tscn") as PackedScene

#var fallbacknet = ProjectSettings.get_setting("MiiTraverse/Globals/Fallback_Network")
var fallbacknet: StringName = ProjectSettings.get_setting("MiiTraverse/Verse/Name")
var mountedcolor

func _ready():
	savedsettings = DaBa.SettingsCheck()
	if not DirAccess.dir_exists_absolute("user://Profile0"):
		DirAccess.make_dir_absolute("user://Profile0")
	DaBa.ProfileArrayFiller()
	ProfileArrayLoad()
	Satellite.connect("NewProfile", LoadProfileBubble)
	DaBa.CurrentProfile = savedsettings.DefaultNetwork #rain check this
	Satellite.connect("SwapNetworks", SetFuncVars)
	Satellite.connect("RefreshNetworks", ActiveNow)
	connect("WhenInactive", ActiveNow)
	SetFuncVars(savedsettings.DefaultNetwork)
	Satellite.connect("SwitchTabs", VisibilityToggle)
	print("Settings init complete")

func ProfileArrayLoad():
	for childs in get_children():
		childs.queue_free()
	var bub:ContentBubble = ContentBubble.new(base_pack)
	add_child(bub)
	for profiles in DaBa.ProfileArray:
		bub = ContentBubble.new(prof_pack)
		add_child(bub)
		Satellite.emit_signal("LoadProfile", profiles)
	Satellite.emit_signal("RefreshNetworks")

func LoadProfileBubble(profval: int):
	DaBa.ProfileArray.append(profval)
	add_child(Bubble.instantiate())
	Satellite.emit_signal("LoadProfile", profval)

#Padding function to call SetFuncVars in instances where an int is not provided
func ActiveNow():
	if DaBa.ProfileArray.has(savedsettings.DefaultNetwork):
		SetFuncVars(savedsettings.DefaultNetwork)
	else:
		SetFuncVars(0)

func SetFuncVars(number: int):
	#Check if cache should be enabled
	var curprofres: ProfileRes = DaBa.ProfileCheck(number)
	if DaBa.OfflineCache or curprofres.OfflineCache:
		DaBa.UseCache = true
	else:
		DaBa.UseCache = false
	#Check which UI color should be used. I want to clean this up.
	if DaBa.OverrideTints:
		mountedcolor = DaBa.Tint
	elif curprofres.UseUniqueTint:
		mountedcolor = curprofres.BubbleTint
	else:
		mountedcolor = DaBa.Tint
