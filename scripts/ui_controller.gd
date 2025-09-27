extends Control
@export var timer: Timer
@export var timerLabel: Label
@export var OutOfTimePanel: Panel
func _process(delta: float) -> void:
	timerLabel.set_text(str(timer.time_left))
	if(timer.time_left==0):
		OutOfTimePanel.visible = true


func _on_timer_timeout() -> void:
	OutOfTimePanel.visible = true
	await get_tree().create_timer(1.0).timeout
	OutOfTimePanel.visible = false
