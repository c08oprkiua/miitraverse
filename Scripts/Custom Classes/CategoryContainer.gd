extends Container
class_name CategoryContainer

@export_category("Content Category")
@export var ContentName: StringName
@export_subgroup("Network Related")
@export var API_Callable: String
@export var TriggerNode: String

#If it has something like {id1}, it's the job of the inhereting class to handle it
@export var CacheFileName: String

signal WhenActive #Called when the category is being hidden
signal WhenInactive #Called when the category is being shown

var xml:MiiverseParser = MiiverseParser.new()

func _init():
	Satellite.connect("SwitchTabs", VisibilityToggle)

func VisibilityToggle(tabnow:StringName, active:bool) -> void:
	if tabnow == ContentName:
		if active:
			emit_signal("WhenActive")
			show()
			print("Hello from ", ContentName)
			return
		else:
			hide()
			emit_signal("WhenInactive")
			return
	else:
		hide()
		emit_signal("WhenInactive")
		return
	return

func CheckDataSource() -> PackedByteArray:
	var path: String = ("user://"+API.CurrentAPIHost+"/"+CacheFileName)
	if DaBa.UseCache:
		if FileAccess.file_exists(path):
			return FileAccess.get_file_as_bytes(path)
	elif not API.response.is_empty():
		#return API.response
		return PackedByteArray([])
	else:
		return PackedByteArray([]) #empty array
	return PackedByteArray([])
