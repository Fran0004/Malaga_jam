extends Panel

@onready var win_lose_label: Label = $WinLoseLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager.winning:
		win_lose_label.text = "VICTORIA"
	else:
		win_lose_label.text = "DERROTA"
	


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
