extends Node

var stomach_health = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_stomach()


func update_stomach() -> void:
	# Estómago: Genera glóbulos blancos que curan al personaje
	if stomach_health > 0:
		spawn_white_cells()

func spawn_white_cells() -> void:
	#var white_cell = preload("res://path_to_white_cell_scene.tscn").instantiate()
	#white_cell.global_position = get_node("Globulo").global_position
	#add_child(white_cell)
	print("Glóbulo blanco generado para curar")
