extends Node2D

var collected = false
var oxigen_space = 50
@onready var idle_timer = $idle_timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	idle_timer.start
	if idle_timer.time_left <= 0:
		idle_movement()
	
func idle_movement():
	position.x += randi_range(-10, 10)
	position.y += randi_range(-10, 10)
func collect():
	
	oxigen_space += 1
	self.queue_free()
	
	
	
