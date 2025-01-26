extends Panel

@onready var win_lose_label: Label = $WinLoseLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager.winning:
		win_lose_label.text = "VICTORIA"
	else:
		win_lose_label.text = "DERROTA"
	
