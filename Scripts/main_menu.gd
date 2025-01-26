extends Control


@onready var menu_animator: AnimationPlayer = $MenuAnimator
@onready var splash_animator: AnimationPlayer = $SplashAnimator

@onready var button_play: Button = $PlayButton
@onready var button_option: Button = $OptionsButton

func _ready() -> void:
	splash_animator.play("splashAnimation")
	button_play.disabled=true
	button_option.disabled=true
	button_play.visible=false
	button_option.visible=false

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_scene.tscn")



func _on_splash_animator_animation_finished(anim_name: StringName) -> void:
	if anim_name == "splashAnimation":
		menu_animator.play("Logo")
		button_option.disabled=false
		button_play.disabled=false
		button_play.visible=true
	button_option.visible=true
	pass # Replace with function body.




func _on_options_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
