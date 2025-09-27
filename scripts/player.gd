extends CharacterBody2D

# Movement speed in pixels per second
@export var speed: float = 200.0

const INIT_HEALTH = 100

# Internal state
var health

func _ready() -> void:
	health = INIT_HEALTH
	
func _physics_process(delta: float) -> void:
	if health <= 0:
		self.visible = false
	else:
		var input_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
		input_vector = input_vector.normalized()
		velocity = input_vector * speed
		move_and_slide()
