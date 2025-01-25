extends Node
var kidneys_health = 100
var obstacles = []

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
			update_kidneys()
			

func update_kidneys() -> void:
	# Riñones: Limpian la sangre (quitan obstáculos)
	if kidneys_health > 50:
		for obstacle in obstacles:
			obstacle.queue_free()  # Eliminar obstáculos si los riñones están saludables
