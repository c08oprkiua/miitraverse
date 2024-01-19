extends FileDialog

class_name ImgDialog

#Constructor
func _init():
	file_mode = FileDialog.FILE_MODE_OPEN_FILE
	access = FileDialog.ACCESS_FILESYSTEM
	root_subfolder = OS.get_system_dir(OS.SYSTEM_DIR_PICTURES, true)
	clear_filters()
	add_filter("*.png, *.jpg", "Images")
	#use_native_dialog = true
	connect("canceled", on_cancel_pressed)
	connect("close_requested", on_cancel_pressed)
	connect("file_selected", on_file_selected)

#Behold, a hotfix for an issue in the engine itself!
func _ready():
	position = Vector2i(0,0)
	var nod:Node = get_vbox().get_children(true)[0].get_children(true)[8].get_children(true)[0]
	var nod2:OptionButton = nod as OptionButton
	nod2.fit_to_longest_item = false
	size = get_tree().get_root().size
	move_to_center()

func on_file_selected(dir: String):
	print(get_vbox().get_children(true))

func on_cancel_pressed():
	queue_free()
