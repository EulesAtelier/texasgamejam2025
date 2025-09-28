extends Node2D

@export var size : float = 16.0

func _input(event):
	if event.is_action_pressed("interact"):
		if ($/root/Overworld/Player.position - position).length() <= size:
			$/root/Overworld/Player/Dialog.attach_tree(get_child(0))
