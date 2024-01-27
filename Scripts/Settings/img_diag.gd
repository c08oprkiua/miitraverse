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
#This is a hacky solution, I will return to it later
func _ready():
	position = Vector2i(0,0)
	var nod:Node = get_vbox().get_children(true)[0].get_children(true)[8].get_children(true)[0]
	var nod2:OptionButton = nod as OptionButton
	nod2.fit_to_longest_item = false
	nod2.hide()
	extend_to_title = false
	move_to_center()
	size.x = get_tree().get_root().size.x - 500
	#get_line_edit().text = (size.x as String)
	size.y = get_tree().get_root().size.y - 1000
	move_to_center()
	var scn:Rect2i = DisplayServer.screen_get_usable_rect()
	var helpme:Label = Label.new()
	helpme.text = ("Screen usable rect: "+String.num(scn.size.x) + " is x, and " + String.num(scn.size.y)+ "is y")
	get_vbox().add_child(helpme)
	var helpmore:Label = Label.new()
	helpmore.text = ("The window size is " + String.num(size.x)+","+String.num(size.x))
	get_vbox().add_child(helpmore)
	move_to_center()


func on_file_selected(dir: String):
	print(get_vbox().get_children(true))

func on_cancel_pressed():
	queue_free()
