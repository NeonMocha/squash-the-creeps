extends Node

@export var mob_scene: PackedScene

@onready var mob_spawn_location = $SpawnPath/SpawnLocation
@onready var player = $Player
@onready var mob_timer: Timer = $MobTimer
@onready var score_label: Label = $UserInterface/ScoreLabel
@onready var retry: ColorRect = $UserInterface/Retry


func _ready():
	retry.hide()
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and retry.visible:
		get_tree().reload_current_scene()


func _on_mob_timer_timeout() -> void:
	var mob: Mob = mob_scene.instantiate()
	
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	add_child(mob)
	mob.squashed.connect(score_label._on_mob_squashed.bind())


func _on_player_hit() -> void:
	mob_timer.stop()
	retry.show()
