extends CatBoxContainer

#This script does the following:
#	Manages the (re)instancing of bubbles in the Settings category
#	Manages changing the color of bubbles when network is changed

var savedsettings: GlobalSettingRes

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
	add_child(load("res://Scenes/Bubbles/GlobalSettingsBubble.tscn").instantiate())
	for profiles in DaBa.ProfileArray:
		add_child(Bubble.instantiate())
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
		mountedcolor = curprofres.Tint
	else:
		mountedcolor = DaBa.Tint
	BlowBubbles()

#Maybe move this to DaBa?
func BlowBubbles():
	var bubbletex = load("res://TRESfiles/Bubbles/bubble.stylebox")
	bubbletex.bg_color = mountedcolor
	DaBa.MountedBubble = bubbletex
	Satellite.emit_signal("NewBubble")
