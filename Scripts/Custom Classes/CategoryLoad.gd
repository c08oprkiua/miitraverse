extends FlowContainer
class_name CatFlowContainer


@export_category("Content Category")
@export var ContentName: StringName
@export var Bubble: PackedScene
@export_subgroup("Network Related")
@export var URL: String
@export var TriggerNode: String

#If it has something like {id1}, it's the job of the inhereting class to handle it
@export var CacheFileName: String

signal WhenActive
signal WhenInactive

func _init():
	Satellite.connect("SwitchTabs", VisibilityToggle)

#This will also manage triggering the loading/downloading of content for a page
#It *should* automatically dis/connect the node to the Network finished signal, in
#order to have only the correct node loading content at a given point in time
func VisibilityToggle(tabnow, active):
	if tabnow == ContentName:
		if active:
			emit_signal("WhenActive")
			print("Hello from ", ContentName)
			show()
		else:
			emit_signal("WhenInactive")
			hide()
	else:
		emit_signal("WhenInactive")
		hide()

func CheckDataSource(filename):
	var path: String = ("user://"+API.CurrentAPIHost+"/"+filename)
	if DaBa.UseCache:
		if FileAccess.file_exists(path):
			return FileAccess.get_file_as_bytes(path)
	elif not API.response.is_empty():
		return API.response
	else:
		return PackedByteArray([]) #empty array
