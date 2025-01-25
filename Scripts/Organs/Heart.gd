extends Node

var heart_health = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_heart()

func update_heart() -> void:
	# Corazón: Afecta la velocidad del glóbulo
	var globulo = get_node("Globulo")
	if heart_health < 30:
		globulo.current_speed = globulo.base_speed * 0.5
		print("Velocidad reducida por baja salud del corazón")
	else:
		globulo.current_speed = globulo.base_speed
