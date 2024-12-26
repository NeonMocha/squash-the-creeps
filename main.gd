extends Node

@export var mob_scene: PackedScene

@onready var mob_spawn_location = $SpawnPath/SpawnLocation
@onready var player = $Player
@onready var mob_timer: Timer = $MobTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mob_timer_timeout() -> void:
	var mob: Mob = mob_scene.instantiate()
	
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	add_child(mob)


func _on_player_hit() -> void:
	mob_timer.stop()
