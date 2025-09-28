extends Node2D

@export var speed: int
var direction := Vector2.ZERO
@export var isEnemyBullet = false;

func _physics_process(delta):
	position += direction * speed * delta


func _on_area_2d_area_entered(area: Area2D) -> void:
	if isEnemyBullet:
		if area.get_parent().name == "Player":
			area.get_parent().damage(10)
			queue_free()
	else:
		if area.get_parent().name == "EnemyA":
			print("hit")
			area.get_parent().damage(10)
			queue_free()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if isEnemyBullet:
		if body.name == "Player":
			body.damage(10, Vector2(0,0))
			queue_free()
	else:
		if body.name == "EnemyA":
			body.damage(10)
			queue_free()
