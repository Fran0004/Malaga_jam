extends Node

var liver_health = 100
var buffed_organ: String = ""  # Organismo protegido por el hígado
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
		OrganType.LIVER:
			update_liver()

func update_liver() -> void:
	# Hígado: Protege un órgano y detiene su desgaste de energía
	if liver_health > 0 and buffed_organ == "":
		var organs = ["brain", "stomach", "pancreas", "kidneys", "heart"]
		buffed_organ = organs[randi() % organs.size()]
		print("Hígado protege: ", buffed_organ)
