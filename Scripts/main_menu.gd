extends Control


@onready var menu_animator: AnimationPlayer = $MenuAnimator

func _ready() -> void:
	menu_animator.play("Logo")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_scene.tscn")
