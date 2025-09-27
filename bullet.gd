extends Node2D

var speed = 600
var direction := Vector2.ZERO

func _physics_process(delta):
	position += direction * speed * delta
