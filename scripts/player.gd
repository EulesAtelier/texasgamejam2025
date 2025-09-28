extends CharacterBody2D

# Movement speed in pixels per second
@export var speed: float = 200.0

const INIT_HEALTH = 100

# Internal state
var health
var immobilized = false

func _ready() -> void:
	health = INIT_HEALTH
	
func _physics_process(delta: float) -> void:
	$LabelHP.text = "hp"+str(health)
	if health <= 0:
		$Clockworth.visible = false
		$LabelDeath.visible = true
	else:
		var input_vector = Input.get_vector("left","right","up","down")
		input_vector = input_vector.normalized()
		velocity = input_vector * speed
		if not immobilized: move_and_slide()
		
