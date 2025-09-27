extends Sprite2D

@export var time: int = 10

func _process(delta: float)->void:
	setTime(delta+time)
func setTime(newTime: int)->void:
	time = newTime
func getTime()-> int:
	return time;
