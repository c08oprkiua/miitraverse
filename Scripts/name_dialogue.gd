extends ContentBubble

#This is a string first so that character checks go faster
var ProfileName: String

const banned: Array[String] = ["/", ".", ",", "#", 
"%", "&", "{", "}", "<", ">", "*", "?", "/", " ", "$",
"!", "'", ":", "@", "+", "`", "|", "=", "\\", "\"" ]
@onready var error:RichTextLabel = $"VBoxContainer/ErrorText"
@onready var enter:LineEdit = $"VBoxContainer/LineEdit"

const usederror: String = "That name is already used. 
If you would like to use it, delete whichever profile is using it."
const nonameerror: String = "No name entered."
const badcharerror: String = "The name you entered conains an unusable symbol. 
Please only use letters A-Z and letters 0-9."

func _on_cancel_pressed():
	if ProfileName != "":
		error.hide()
		enter.clear()
	else:
		selfdelete()

func _on_accept_pressed():
		#Make sure it's not empty
	if ProfileName == "":
		error.text = nonameerror
		error.show()
		return
	#Make sure it isn't using characters that the filesystem won't like
	if not ProfileName.is_valid_filename():
		error.text = badcharerror
		error.show()
		return
	var strname: StringName = StringName(ProfileName)
	#Make sure the profile name isn't already taken
	for registered in API.APIArray:
		if strname == registered:
			error.text = usederror
			error.show()
			return
	#Yay, checks have passed, add that profile!
	Satellite.emit_signal("NewProfile", strname)
	selfdelete()

func _on_line_edit_text_changed(new_text):
	ProfileName = new_text
	error.hide()

func _on_line_edit_text_submitted(new_text):
	ProfileName = new_text
	_on_accept_pressed()

