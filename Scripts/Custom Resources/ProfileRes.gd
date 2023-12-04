extends Resource
class_name ProfileRes

#These settings are influenced by Default()
@export_group("Profile Settings")
@export var name: String
@export var url: StringName
@export var OfflineCache: bool
@export_enum("null", "Wii U", "3DS") var Mimicked_Device: int
@export var Tint: Color
@export var UseUniqueTint: bool
@export var Region: int #This is an enum of 18 or something values but I ain't typing allat rn
@export var AccountServ3DS: StringName
@export var AccountServWiiU: StringName
@export var ShowSpoilers: bool

#These are excempt from Default()
@export_group("Login information")
@export var Username: String
@export var Password: String
@export var PID: String

func Defaults():
	name = ProjectSettings.get_setting("MiiTraverse/Verse/Name")
	url = ProjectSettings.get_setting("MiiTraverse/Verse/URL")
	OfflineCache = ProjectSettings.get_setting("MiiTraverse/Verse/OfflineCache")
	Mimicked_Device = ProjectSettings.get_setting("MiiTraverse/Verse/Mimicked_Device")
	Tint = ProjectSettings.get_setting("MiiTraverse/Verse/Tint")
	UseUniqueTint = ProjectSettings.get_setting("MiiTraverse/Verse/UseUniqueTint")
	Region = ProjectSettings.get_setting("MiiTraverse/Verse/Region")
	AccountServ3DS = ProjectSettings.get_setting("MiiTraverse/Verse/AccountServ3DS")
	AccountServWiiU = ProjectSettings.get_setting("MiiTraverse/Verse/AccountServWiiU")
	ShowSpoilers = ProjectSettings.get_setting("MiiTraverse/Verse/ShowSpoilers")