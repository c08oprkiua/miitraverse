extends AnimationPlayer

static var lib:AnimationLibrary = preload("res://TRESfiles/Bubbles/Anims/BubbleAnims.tres")

func _on_bubble_shell_delete_request():
	lib.get_animation("fade_in")
	play("fade_out")

func _on_bubble_shell_tree_entered():
	play("fade_in")
