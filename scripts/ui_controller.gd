extends Control
@onready var playerScript = $"../Sprite2D"
@export var timerLabel: Label

func _process(delta: float) -> void:
	pass
	#timerLabel.text = str(playerScript.get_script().getTime())
