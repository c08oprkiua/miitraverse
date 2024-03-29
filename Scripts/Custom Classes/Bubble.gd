extends PanelContainer
class_name ContentBubble

signal DeleteRequest

static var UniversalBubble:StyleBox = preload("res://TRESfiles/Bubbles/bubble.stylebox")
@export var content: PackedScene
var anims:AnimationPlayer = AnimationPlayer.new()

static var lib:AnimationLibrary = preload("res://TRESfiles/Bubbles/Anims/BubbleAnims.tres")

func _init(cont:PackedScene = null):
	mouse_filter = Control.MOUSE_FILTER_PASS
	if cont != null:
		content = cont
	add_theme_stylebox_override("panel", UniversalBubble)

func _ready():
	focus_mode = Control.FOCUS_ALL
	grab_focus()
	focus_mode = Control.FOCUS_NONE
	add_child(content.instantiate(), false, Node.INTERNAL_MODE_BACK)
	Satellite.connect("NewBubble", add_theme_stylebox_override.bind("panel", UniversalBubble))
	connect("DeleteRequest", _on_bubble_shell_delete_request)

func _on_bubble_shell_delete_request():
	lib.get_animation("fade_in")
	anims.play("fade_out")

func _enter_tree():
	#anims.play("fade_in")
	pass
