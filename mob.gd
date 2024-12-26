class_name Mob
extends CharacterBody3D

signal squashed

@export var min_speed: int = 10
@export var max_speed: int = 18


func _physics_process(_delta: float) -> void:
	move_and_slide()


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
	
	
func initialize(start_position, player_position):
	look_at_from_position(start_position, player_position, Vector3.UP)
	rotate_y(randf_range(-PI/4, PI/4))
	
	var random_speed = randi_range(min_speed, max_speed)
	
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	$AnimationPlayer.speed_scale = random_speed / min_speed
	

func squash():
	squashed.emit()
	queue_free()
	
