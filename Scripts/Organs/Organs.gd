extends Node

var brain_health: float = 100.0
var stomach_health: float = 100.0
var pancreas_health: float = 100.0
var kidneys_health: float = 100.0
var liver_health: float = 100.0
var heart_health: float = 100.0

# Variables relacionadas con oxígeno y buffs
@export var oxygen_spawn_rate: float = 2.0  # Tiempo entre generación de oxígeno
@export var organ_energy_drain_rate: float = 5.0  # Energía que los órganos pierden por segundo
@export var buff_durations: Dictionary = {
	"speed": 5.0,  # Duración de un buff de velocidad en segundos
	"slow_energy_drain": 5.0,  # Duración del buff que reduce el consumo de energía
}

# Buffs activos
var active_buffs: Dictionary = {
	"speed": false,
	"slow_energy_drain": false,
}

# Variables específicas para funcionalidades de órganos
var obstacles: Array = []  # Lista de obstáculos para riñones
var short_routes: Array = []  # Lista de rutas cortas para el páncreas
var buffed_organ: String = ""  # Organismo protegido por el hígado
var time_with_all_organs_active: float = 0.0  # Tiempo con todos los órganos activos
@export var victory_time: float = 30.0  # Tiempo necesario para ganar
@export var Type = OrganType.NONE

# Enum de todos los órganos
enum OrganType{
	NONE,
	HEART,
	BRAIN,
	KIDNEYS,
	LIVER,
	PANCREAS,
	STOMACH
}

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match Type:
		OrganType.NONE:
			pass
		OrganType.HEART:
			update_heart()
		OrganType.BRAIN:
			update_brain(delta)
		OrganType.KIDNEYS:
			update_kidneys()
		OrganType.LIVER:
			update_liver()
		OrganType.PANCREAS:
			update_pancreas()
		OrganType.STOMACH:
			update_stomach()
			spawn_white_cells()
	drain_organ_energy(delta)
	check_victory(delta)
	

func update_kidneys() -> void:
	# Riñones: Limpian la sangre (quitan obstáculos)
	if kidneys_health > 50:
		for obstacle in obstacles:
			obstacle.queue_free()  # Eliminar obstáculos si los riñones están saludables

func update_liver() -> void:
	# Hígado: Protege un órgano y detiene su desgaste de energía
	if liver_health > 0 and buffed_organ == "":
		var organs = ["brain", "stomach", "pancreas", "kidneys", "heart"]
		buffed_organ = organs[randi() % organs.size()]
		print("Hígado protege: ", buffed_organ)

func drain_organ_energy(delta: float) -> void:
	# Reduce la energía de cada órgano, excepto el protegido
	for organ in ["brain", "stomach", "pancreas", "kidneys", "heart"]:
		if organ != buffed_organ:
			self[organ + "_health"] -= organ_energy_drain_rate * delta

func update_stomach() -> void:
	# Estómago: Genera glóbulos blancos que curan al personaje
	if stomach_health > 0:
		spawn_white_cells()

func spawn_white_cells() -> void:
	#var white_cell = preload("res://path_to_white_cell_scene.tscn").instantiate()
	#white_cell.global_position = get_node("Globulo").global_position
	#add_child(white_cell)
	print("Glóbulo blanco generado para curar")

func update_pancreas() -> void:
	# Páncreas: Bloquea rutas cortas si su salud es baja
	if pancreas_health < 30:
		for route in short_routes:
			route.block()
			print("Ruta corta bloqueada debido al páncreas")

func update_heart() -> void:
	# Corazón: Afecta la velocidad del glóbulo
	var globulo = get_node("Globulo")
	if heart_health < 30:
		globulo.current_speed = globulo.base_speed * 0.5
		print("Velocidad reducida por baja salud del corazón")
	else:
		globulo.current_speed = globulo.base_speed

func update_brain(delta: float) -> void:
	# Cerebro: Reduce la interfaz y puede provocar la muerte
	if brain_health < 70:
		$HUD/Map.visible = false  # Esconde el mapa
	if brain_health < 50:
		$HUD/OxygenCounter.visible = false  # Esconde el contador de oxígeno
	if brain_health <= 0:
		print("¡Game Over! El cerebro ha fallado")
		get_tree().change_scene("res://scenes/GameOver.tscn")

# Aplicar buff global
func apply_buff(buff_name: String) -> void:
	if buff_name in active_buffs and not active_buffs[buff_name]:
		active_buffs[buff_name] = true
		print("Buff activado: ", buff_name)
		match buff_name:
			"speed":
				get_node("Globulo").current_speed *= 1.5  # Aumenta velocidad del glóbulo
			"slow_energy_drain":
				organ_energy_drain_rate *= 0.5  # Reduce el consumo de energía en los órganos

		# Desactiva el buff después de su duración
		_deactivate_buff_later(buff_name)

func _deactivate_buff_later(buff_name: String) -> void:
	await get_tree().create_timer(buff_durations[buff_name]).timeout
	remove_buff(buff_name)

func remove_buff(buff_name: String) -> void:
	if buff_name in active_buffs and active_buffs[buff_name]:
		active_buffs[buff_name] = false
		print("Buff desactivado: ", buff_name)
		match buff_name:
			"speed":
				get_node("Globulo").current_speed = get_node("Globulo").base_speed  # Restaura velocidad
			"slow_energy_drain":
				organ_energy_drain_rate *= 2  # Restaura consumo normal

# Condición de victoria
func check_victory(delta: float) -> void:
	if all_organs_active():
		time_with_all_organs_active += delta
		if time_with_all_organs_active >= victory_time:
			print("¡Victoria! Todos los órganos activos")
			get_tree().change_scene("res://scenes/Victory.tscn")
	else:
		time_with_all_organs_active = 0.0

func all_organs_active() -> bool:
	for health in [brain_health, stomach_health, pancreas_health, kidneys_health, liver_health, heart_health]:
		if health <= 0:
			return false
	return true
