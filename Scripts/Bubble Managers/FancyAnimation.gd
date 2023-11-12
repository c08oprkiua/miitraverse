extends AnimationPlayer

func _on_bubble_shell_delete_request():
	play("fade_out")

func _on_bubble_shell_tree_entered():
	play("fade_in")
