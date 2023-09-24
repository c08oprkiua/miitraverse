extends Control

var itname 
var information
var commtoggle
@onready var homebutton = $"ButtonBar/Home"

func _ready():
	Network.ThreadManager(0)
	homebutton.set_pressed(true)

#This almost works. Almost.
func SwitchTabs(tabnow, active):
	#Note to self, this will also manage triggering the loading/downloading of 
	#content for a page
	for tabs in DaBa.Tbl.keys():
		get_node(DaBa.Tbl[tabs].get("Node")).hide()
	if active and tabnow != "Home":
		homebutton.set_pressed_no_signal(false)
		get_node(DaBa.Tbl[tabnow].get("Node")).show()
		#Send signal to fetch info here
		print(tabnow)
		match tabnow:
			"Home":
				pass
			"Communities":
				Satellite.emit_signal("NetFetch", "Communities")
	if not active and tabnow != "Home":
		get_node(DaBa.Tbl["Home"].get("Node")).show()
		homebutton.set_pressed(true)

func _on_communities_toggled(button_pressed):
	SwitchTabs("Communities", button_pressed)

func _on_home_toggled(button_pressed):
	SwitchTabs("Home", button_pressed)

func _on_messages_toggled(button_pressed):
	SwitchTabs("DMs", button_pressed)

func _on_notifications_toggled(button_pressed):
	SwitchTabs("Notifications", button_pressed)

func _on_settings_toggled(button_pressed):
	SwitchTabs("Settings", button_pressed)

func _on_search_toggled(button_pressed):
	pass # Replace with function body.

func _on_activity_feed_toggled(button_pressed):
	SwitchTabs("People", button_pressed)
