extends Node

var pancreas_health = 100
var short_routes: Array = []
@export var Type = OrganType.NONE
enum OrganType{
	NONE,
	HEART,
	BRAIN,
	KIDNEYS,
	LIVER,
	PANCREAS,
	STOMACH
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match Type:
		OrganType.STOMACH:
			update_pancreas()
			shortcut_open()

func update_pancreas() -> void:
	# Páncreas: Bloquea rutas cortas si su salud es baja
	if pancreas_health < 30:
		for route in short_routes:
			short_routes[route] = "Closed"
			print("Ruta corta bloqueada debido al páncreas")
			
func shortcut_open():
	for route in short_routes:
		if not short_routes[route] == "Closed":
			get_node("ClosedDoorCollision").visible = false
			get_node("ClosedDoorCollision").disabled = false
		else:
			get_node("ClosedDoorCollision").visible = true
			get_node("ClosedDoorCollision").disabled = true
			
			
			
