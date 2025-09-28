extends Node2D

var speed = 600
var direction := Vector2.ZERO

func _physics_process(delta):
	position += direction * speed * delta


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "NPC":
		area.get_parent().damage(10)
		queue_free()
