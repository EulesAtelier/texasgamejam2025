extends Sprite2D
@export var timer: Timer
@export var bullet:PackedScene
func _process(delta: float) -> void:
	self.look_at(get_viewport().get_mouse_position())
	if(Input.is_action_just_pressed("shoot") && timer.time_left != 0 && timer.time_left-5 >= 0):
		print("shoot")
		var instance = bullet.instantiate()
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - global_position).normalized()
		instance.rotation = direction.angle() + PI / 2
		instance.direction = direction
		get_tree().root.add_child(instance)
		instance.global_position = global_position  # Or wherever you want the bullet to appear
		timer.stop()
		timer.wait_time -= 5  # New time in seconds
		timer.start()
