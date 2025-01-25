extends Node

var pancreas_health = 100
var short_routes: Array = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_pancreas()

func update_pancreas():
	# Páncreas: Bloquea rutas cortas si su salud es baja
	if pancreas_health < 30:
		for route in short_routes:
			route.block()
			print("Ruta corta bloqueada debido al páncreas")
