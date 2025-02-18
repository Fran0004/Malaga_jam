extends Sprite2D

@onready var spawn_point: Node2D = $SpawnPoint
@onready var bubble_timer: Timer = $bubbleTimer


const AIR_BUBBLE = preload("res://Prefabs/air_bubble.tscn")
var max_bubbles = 100
var current_bubbles = 0
var player_oxygen = GameManager.oxigen_player
@onready var air_bubble: Area2D = $AirBubble

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _process(delta: float):
	if GameManager.oxigen_player > player_oxygen:
		print("Current loose bubble count ", current_bubbles)
		current_bubbles -= GameManager.oxigen_player - player_oxygen
		player_oxygen = GameManager.oxigen_player
	create_bubble()

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func create_bubble():
	if bubble_timer.time_left <= 0 and current_bubbles < max_bubbles:
		var newBubble = AIR_BUBBLE.instantiate()
		get_node(".").add_child(newBubble)
		newBubble.position = spawn_point.position + Vector2(randi_range(-35, 35), randi_range(-35, 35))
		current_bubbles += 1
		bubble_timer.start()

func _on_bubble_timer_timeout() -> void:
	pass # Replace with function body.
	

func _on_area_2d_area_entered(air_bubble: Area2D) -> void:
	current_bubbles -= 1


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
