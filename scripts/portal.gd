class_name Portal

extends Area2D

@export var height: int
@export var exit: Portal 
@export var warmup_time: = 0.5
@export var cooldown_time: = 0.25

func _ready() -> void:
	# Connect the body_entered signal
	connect("body_entered", Callable(self, "_on_body_entered"))

var cooldown = 0
var warmup = 0
var label_timer = 0
var entered_body : Node

func _physics_process(delta):
	if label_timer > 0:
		label_timer = max(0,label_timer-delta)
		if label_timer == 0: $Label.visible = false
	if warmup > 0:
		warmup = max(0,warmup-delta)
		if warmup == 0: 
			exit.cooldown = cooldown_time
			entered_body.position = exit.position
			entered_body.immobilized = false
	if cooldown > 0:
		cooldown = max(0,cooldown-delta)

func _on_body_entered(body: Node) -> void:
	if body.name != "Player": return
	if cooldown > 0: return
	if $"../SandMap".height > height: return
	if $"../SandMap".height+1 >= exit.height: 
		$Label.visible = true
		label_timer = 2
		return
	entered_body = body
	entered_body.immobilized = true
	warmup = warmup_time
	
