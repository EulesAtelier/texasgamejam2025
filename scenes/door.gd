extends Area2D

# Coordinates you want to teleport the player to
@export var target_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Connect the body_entered signal
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		# Make sure it's a Node2D so it has a position property
		if body is Node2D:
			body.position = target_position
