# script for an npc which patrols randomly around a patrol area

extends Sprite2D

# Parameters

# detection_distance - 
# detection_chance - 
# follow_distance
# combat_distance

@export var walk_speed: float = 10.0
@export var min_idle_time: float = 1.0
@export var max_idle_time: float = 1.0
@export var debug: bool = true
enum ENEMY_STATE { 
	PATROL_WALK, 
	PATROL_IDLE
}
# TODO
# RETURNING
# CHASING
# RANGED ATTACK
# 


# Internal state variables
var state: ENEMY_STATE = ENEMY_STATE.PATROL_IDLE
var idle_timer = 5
var target_position : Vector2

func _physics_process(delta: float) -> void:
	
	if get_child(0).overlaps_body($/root/Overworld/Player):
		$/root/Overworld/Player.health -= 1
		$/root/Overworld/Player.health = clamp($/root/Overworld/Player.health, 0, 100)
		print($/root/Overworld/Player.health)
	
	match state:
		ENEMY_STATE.PATROL_WALK:
			if debug: 
				$/root/Overworld/LabelEnemyState.text = "WALK"
				$/root/Overworld/DebugEnemyTarget.position = target_position
			var walk_dir : Vector2 = target_position - global_position
			if walk_dir.length() < 0.1:
				idle_timer = randf_range(min_idle_time, max_idle_time)
				state = ENEMY_STATE.PATROL_IDLE
			else:
				walk_dir = walk_dir.normalized()
				self.translate(walk_dir * walk_speed * delta)
		ENEMY_STATE.PATROL_IDLE:
			if debug: 
				$/root/Overworld/LabelEnemyState.text = "IDLE"
				$/root/Overworld/LabelEnemyIdleTimer.text = str(idle_timer)
			if idle_timer <= 0:
				# choose new target coord
				var rect : RectangleShape2D = $"../CollisionShape2D".shape
				var pos : Vector2 = self.get_parent().position
				var target_x = randf_range(-rect.size.x/2, rect.size.x/2) + pos.x
				var target_y = randf_range(-rect.size.y/2, rect.size.y/2) + pos.y
				target_position = Vector2(target_x, target_y)
				state = ENEMY_STATE.PATROL_WALK
			else:
				idle_timer -= delta
