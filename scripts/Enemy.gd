# script for an npc which patrols randomly around a patrol area

extends Node2D

# Parameters

# detection_distance - 
# detection_chance - 
# follow_distance
# combat_distance
@export var patrol_area : Area2D
@export var orthogonal_patrol : bool
@export var walk_speed: float = 10.0
@export var chase_speed: float = 10.0
@export var invul_time = 1
@export var height : float 
@export var min_idle_time: float = 1.0
@export var max_idle_time: float = 5.0
@export var debug: bool = false
@export var notice_player: bool
@export var notice_distance: float
@export var notice_chance: float

enum ENEMY_STATE { 
	PATROL_WALK, 
	PATROL_IDLE,
	CHASING,
	RETURNING
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
var health : float = 100

var invul = 0

func damage(damage : float):
	if invul > 0: return
	health = max(0,health-damage)
	invul = invul_time

func _ready():
	if debug:
		$LabelField1.visible = true
		$LabelField2.visible = true
		$LabelState.visible = true
		$Target.visible = true

func _physics_process(delta: float) -> void:
	# blinking invincibility frames/death anim
	if $/root/Overworld/SandMap.height >= height:
		health = 0
	if invul > 0:
		invul = max(0,invul-delta)
		visible = int((invul*10))%2 == 0
		if invul == 0 and health == 0:
			visible = false
			$CollisionShape2D.disabled = true
			$Hitbox/CollisionShape2D.disabled = true
	elif health == 0: 
		return
	
	# damage and knock the player back
	var player = $/root/Overworld/Player
	if $Hitbox.overlaps_body(player):
		player.damage(1,Vector2.ZERO)	
	
	if notice_player:
		if position.distance_to(player.position) <= notice_distance:
			if randf_range(0,1/(notice_chance*delta)) == 0:
				state = ENEMY_STATE.CHASING
	
	
	match state:
		ENEMY_STATE.PATROL_WALK:
			if debug: 
				$LabelState.text = "WALK"
				$Target.position = -position+target_position
			var walk_dir : Vector2 = target_position - global_position
			if walk_dir.length() < 0.1:
				idle_timer = randf_range(min_idle_time, max_idle_time)
				state = ENEMY_STATE.PATROL_IDLE
			else:
				walk_dir = walk_dir.normalized()
				translate(walk_dir * walk_speed * delta)
		ENEMY_STATE.PATROL_IDLE:
			if debug: 
				$LabelState.text = "IDLE"
				$LabelField1.text = "%.1f" % idle_timer
			if idle_timer <= 0:
				# choose new target coord
				var patrol_size : Vector2 = patrol_area.get_child(0).shape.size
				var patrol_center : Vector2 = patrol_area.position
				var target_x = randf_range(-patrol_size.x/2, patrol_size.x/2) + patrol_center.x
				var target_y = randf_range(-patrol_size.y/2, patrol_size.y/2) + patrol_center.y
				if orthogonal_patrol:
					if randi_range(0,1) == 0:
						target_position = Vector2(target_x, position.y)
					else:
						target_position = Vector2(position.x, target_y)
				else:
					target_position = Vector2(target_x, target_y)
				
				state = ENEMY_STATE.PATROL_WALK
				$LabelField1.text = ""
			else:
				idle_timer -= delta
