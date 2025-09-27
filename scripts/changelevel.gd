extends Button
@export var level: String 
func _pressed() -> void:
	get_tree().change_scene_to_file(level)
