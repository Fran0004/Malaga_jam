extends Sprite2D

@onready var spawnpoint: Node2D = $Spawnpoint
@onready var bubble_timer: Timer = $bubbleTimer

const AIR_BUBBLE = preload("res://Prefabs/air_bubble.tscn")
var max_bubbles = 10
var current_bubbles = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func create_bubble():
	if bubble_timer.time_left <= 0 and current_bubbles < max_bubbles:
		var newBubble = AIR_BUBBLE.instantiate()
		get_node(".").add_child(newBubble)
		newBubble.position = spawnpoint.position + Vector2(randi_range(-200, 200), randi_range(-200, 200))
		current_bubbles += 1
		bubble_timer.start()

func _process(delta: float) -> void:
	create_bubble()
