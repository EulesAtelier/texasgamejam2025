extends CharacterBody2D

# Movement speed in pixels per second
@export var speed: float = 200.0
@export var invul_time : float = 1.0
@export var INIT_HEALTH = 100.0
@export var MAX_HEALTH = 100.0

# Internal state
var health
var immobilized = false
var invul: float

func _ready() -> void:
	health = INIT_HEALTH
	
func damage(damage, knockback):
	if invul > 0: return
	health = max(0,health-damage)
	invul = invul_time
	
func _physics_process(delta: float) -> void:
	if invul > 0:
		invul = max(0,invul-delta)
		visible = int((invul*10))%2 == 0
	
	display_hearts()
	
	if health <= 0:
		$Clockworth.visible = false
		$LabelDeath.visible = true
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://scenes/overworld.tscn")
	else:
		var input_vector = Input.get_vector("move_left","move_right","move_up","move_down")
		input_vector = input_vector.normalized()
		velocity = input_vector * speed
		if not immobilized: move_and_slide()

func display_hearts():
	if health >= 80:
		$Heart5.visible = true
	else:
		$Heart5.visible = false
		
	if health >= 60:
		$Heart4.visible = true
	else:
		$Heart4.visible = false
		
	if health >= 40:
		$Heart3.visible = true
	else:
		$Heart3.visible = false
		
	if health >= 20:
		$Heart2.visible = true
	else:
		$Heart2.visible = false
		
	if health > 0:
		$Heart1.visible = true
	else:
		$Heart1.visible = false
