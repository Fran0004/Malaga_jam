extends Node2D

@export var max_bubbles: int = 20
@export var bubble_scene: PackedScene
var current_bubbles: int = 0

# Use get_node() for non-direct children
@onready var spawn_timer: Timer = $Timer

func _ready() -> void:
	if spawn_timer:
		spawn_timer.timeout.connect(_on_spawn_timer_timeout)
		spawn_timer.start()
	else:
		push_error("Timer node not found. Check scene tree!")

func _on_spawn_timer_timeout() -> void:
	if current_bubbles < max_bubbles:
		spawn_bubble()

func spawn_bubble() -> void:
	if bubble_scene:
		var bubble = bubble_scene.instantiate()
		add_child(bubble)
		current_bubbles += 1
		bubble.position = Vector2(200, 100)
		
		if bubble.has_method("set_speed"):
			bubble.set_speed(randf_range(50, 150), randf_range(0, 360))
	else:
		push_error("Bubble scene not assigned!")

func remove_bubble() -> void:
	current_bubbles = max(0, current_bubbles - 1)
