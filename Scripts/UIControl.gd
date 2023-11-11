extends Control
 
var currenttab: StringName
@onready var homebutton = $"ButtonBar/Home"
@onready var homecontent = $"UIMargin/MainUI/SpacedContent/HomeList"

func _ready():
	Satellite.connect("SwitchTabs", SwitchTabs)
	Satellite.connect("NewPopUp", MakePopupWindow)
	API.ConnectionManager(0)
	homebutton.set_pressed(true)

#This is a special function that sets the tab back to Home if a tab is unselected 
func SwitchTabs(tabnow: StringName, active: bool):
	if active: 
		currenttab = tabnow
		if tabnow != "Home":
			homebutton.set_pressed_no_signal(false)
	if not active:
		if tabnow == currenttab:
			homecontent.show()
			homebutton.set_pressed_no_signal(true)

func MakePopupWindow(window: PackedScene):
	add_child(window.instantiate())

func _on_communities_toggled(button_pressed):
	Satellite.emit_signal("SwitchTabs", "Communities", button_pressed)

func _on_home_toggled(button_pressed):
	Satellite.emit_signal("SwitchTabs", "Home", button_pressed)

func _on_posts_toggled(button_pressed):
	Satellite.emit_signal("SwitchTabs", "Posts", button_pressed)

func _on_messages_toggled(button_pressed):
	Satellite.emit_signal("SwitchTabs", "DMs", button_pressed)

func _on_notifications_toggled(button_pressed):
	Satellite.emit_signal("SwitchTabs", "Notifications", button_pressed)

func _on_settings_toggled(button_pressed):
	Satellite.emit_signal("SwitchTabs", "Settings", button_pressed)

func _on_search_toggled(button_pressed):
	print("Search: ", button_pressed)

func _on_activity_feed_toggled(button_pressed):
	Satellite.emit_signal("SwitchTabs", "People", button_pressed)
