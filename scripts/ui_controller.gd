extends Control
@onready var playerScript = $"../Sprite2D"
@export var timerLabel: Label

func _process(delta: float) -> void:
	timerLabel.text = str(playerScript.get_script().getTime())
