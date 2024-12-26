extends CharacterBody3D

signal hit

@export var speed: float = 14.0
@export var fall_acceleration: float = 75.0
@export var jump_impulse: float = 20.0
@export var bounce_impulse: float = 16.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pivot: Node3D = $Pivot

var target_velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		pivot.basis = Basis.looking_at(direction)
		animation_player.speed_scale = 4 if is_on_floor() else 0
	else:
		animation_player.speed_scale = 1 if is_on_floor() else 0
		
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
		
	velocity = target_velocity
	move_and_slide()
	
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision.get_collider() == null:
			continue
		if collision.get_collider().is_in_group("mob"):
			var mob: Mob = collision.get_collider()
			
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				target_velocity.y = bounce_impulse
				break
	
	pivot.rotation.x = PI / 6 * velocity.y / jump_impulse
	


func _on_mob_detector_body_entered(_body: Node3D) -> void:
	die()
	
func die():
	hit.emit()
	queue_free()
