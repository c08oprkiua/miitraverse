extends PanelContainer


@onready var ContentRoot = $"ContentMargins"

func _ready():
	Satellite.connect("NewBubble", NewBubble)

func NewBubble():
	add_theme_stylebox_override("NewBubble", DaBa.MountedBubble)
