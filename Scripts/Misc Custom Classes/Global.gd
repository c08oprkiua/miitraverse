extends Resource
class_name GlobSet

const savepath: String = "user://settings.tres"

@export_group("Global Settings")
@export var DefaultNetwork: int
@export var OfflineCache: bool
@export var TriDS_Certificate: String
@export var Wii_U_Certificate: String
@export var Tint: Color
@export var OverrideTints: bool


func Defaults():
	DefaultNetwork = ProjectSettings.get_setting("MiiTraverse/Verse/Name")
	OfflineCache = ProjectSettings.get_setting("MiiTraverse/Globals/OfflineCache")
	Tint = ProjectSettings.get_setting("MiiTraverse/Globals/Tint")
	OverrideTints = ProjectSettings.get_setting("MiiTraverse/Globals/OverrideTints")
