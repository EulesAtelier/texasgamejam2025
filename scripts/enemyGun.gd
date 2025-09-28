extends Sprite2D
@export var bullet:PackedScene
@onready var player = $/root/Overworld/Player
var rng = RandomNumberGenerator.new()
var canShoot = false;
var hasFired = false;
func _ready():
	var my_random_number = rng.randf_range(-10.0, 10.0)
func _process(delta: float) -> void:
	self.look_at(player.position)
	
	if(canShoot && hasFired==false && get_parent().health >0):
		hasFired = true
		await get_tree().create_timer(1.0).timeout;
		var instance = bullet.instantiate()
		var base_direction = (player.position - global_position).normalized()
		var max_angle_variation = deg_to_rad(10)
		var random_angle = randf_range(-max_angle_variation, max_angle_variation)
		var direction = base_direction.rotated(random_angle)
		instance.rotation = direction.angle() + PI / 2
		instance.direction = direction
		get_tree().root.add_child(instance)
		instance.global_position = global_position 
		hasFired = false


func _on_randge_body_entered(body: Node2D) -> void:
	print("entered")
	if(body.name == "Player"):
		canShoot = true


func _on_randge_body_exited(body: Node2D) -> void:
	if(body.name == "Player"):
		canShoot = false
