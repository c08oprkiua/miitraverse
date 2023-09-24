extends NinePatchRect





func _ready():
	self_modulate = DaBa.GlobalColorTint
	Satellite.connect("ColorTint", ChangeColor)


func ChangeColor(newtint):
	set_self_modulate(newtint)
