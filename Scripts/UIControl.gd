extends Control

var itname 
var information
var commtoggle
var currenttab
@onready var homebutton = $"ButtonBar/Home"
@onready var homecontent = $"UIMargin/MainUI/SpacedContent/HomeList"

func _ready():
	Satellite.connect("SwitchTabs", SwitchTabs)
	Network.ConnectionManager(0)
	homebutton.set_pressed(true)

func SwitchTabs(tabnow, active):
	if active: 
		currenttab = tabnow
		if tabnow != "Home":
			homebutton.set_pressed_no_signal(false)
	if not active:
		if tabnow == currenttab:
			homecontent.show()
			homebutton.set_pressed_no_signal(true)

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
