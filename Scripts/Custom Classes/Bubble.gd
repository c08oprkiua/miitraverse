extends PanelContainer
class_name ContentBubble

signal DeleteRequest

@export var Content: PackedScene



func _ready():
	Satellite.connect("NewBubble", NewBubble)
	add_child(Content.instantiate(), false, Node.INTERNAL_MODE_BACK)

func NewBubble():
	add_theme_stylebox_override("NewBubble", DaBa.MountedBubble)

func selfdelete():
	self.queue_free()
