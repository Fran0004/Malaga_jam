extends Area2D

## Movement properties
#var speed : float
#var direction : float
#var velocity : Vector2
#@onready var spawn_point = $Pulmones/SpawnPoint
#@onready var pulmones = $Pulmones
#var testing = preload("res://Prefabs/Testing.tscn")
# Circular room properties (radius from center)
#@export var room_radius : float = 400.0    # Circle radius
#@export var room_center : Vector2 = Vector2(200, 100)  # Center of circular area

#func _ready():
	#pass
#func _process(delta):
	#pass
	
#func spawn_bubble():
	#var spawn_point_bubble = preload("res://Prefabs/Testing.tscn").instantiate()
	#add_child(spawn_point_bubble)
	#
	#
#func set_initial_position(pos: Vector2):
	#pos -= Vector2(randi_range(-50, 50), randi_range(-50, 50))


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if GameManager.oxigen_player < GameManager.max_oxigen_player:
			GameManager.oxigen_player += 1
			self.queue_free()
		else:
			pass
	
	
	
