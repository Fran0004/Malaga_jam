extends Control

@onready var bubble_label: Label = $BubbleLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bubble_label.text = str(GameManager.oxigen_player)
	
