extends Node

# Variables específicas para funcionalidades de órganos
var obstacles: Array   = []  # Lista de obstáculos para riñones

var time_with_all_organs_active: float = 0.0  # Tiempo con todos los órganos activos
var time_accumulator: float = 0.0
var drain_interval: float = 1.0  # Cada cuánto tiempo se drena energía (en segundos)
var mainDoors: Array[Node]
var sideDoors: Array[Node]

enum OrganType{
	NONE,
	HEART,
	BRAIN,
	KIDNEYS,
	LIVER,
	PANCREAS,
	STOMACH
}

@export var victory_time: float = 30.0  # Tiempo necesario para ganar
@export var Type: int = OrganType.NONE
@export var organName: String
@export var drain_amount: float = 0.005  # Cantidad de energía que se pierde por segundo# Called when the node enters the scene tree for the first time.

##TIMERS
@onready var stomach_timer: Timer = $StomachTimer
@onready var organs_sprite: Sprite2D = $"."

var closeMain: Array[Node]
var closeSide: Array[Node]

func _ready() -> void:
	mainDoors = get_tree().get_nodes_in_group("main-doors")  # Lista de rutas cortas para páncreas
	sideDoors = get_tree().get_nodes_in_group("side-doors")  # Lista de rutas cortas para páncreas

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match Type:
		OrganType.NONE:
			pass
		OrganType.HEART:
			update_heart()
		OrganType.BRAIN:
			update_brain()
		OrganType.KIDNEYS:
			update_kidneys()
		OrganType.LIVER:
			update_liver()
		OrganType.PANCREAS:
			update_pancreas()
		OrganType.STOMACH:
			update_stomach()
	
	# Acumula el tiempo transcurrido
	time_accumulator += delta

	# Si el acumulador ha alcanzado o superado el intervalo de drenaje
	if time_accumulator >= drain_interval and not GameManager.organs_health[organName]["protected"]:
		time_accumulator -= drain_interval  # Resta el tiempo que ya ha pasado en este intervalo
		drain_organ_energy(organName)  # Llama a la función para drenar la energía del estómago (o del órgano que desees)
	
	check_victory(delta)
	
func update_kidneys() -> void:
	# Riñones: Limpian la sangre (quitan obstáculos)
	if GameManager.kidneys_percentage > 60:
		GameManager.kidneys_buff = true
		GameManager.kidneys_debuff = false

		for obstacle in obstacles:
			obstacle.queue_free()  # Eliminar obstáculos si los riñones están saludables
	else:
		GameManager.kidneys_buff = false
		GameManager.kidneys_debuff = true


func update_liver() -> void:
	# Hígado: Protege un órgano y detiene su desgaste de energía
	if GameManager.liver_percentage > 75:
		if not GameManager.liver_buff:
			GameManager.liver_buff = true
			GameManager.liver_debuff = false
			var organs: Array[Variant] = ["brain", "stomach", "pancreas", "kidneys", "heart"]
			var organ_name = organs[randi() % organs.size()]
			GameManager.organs_health[organ_name]["protected"] = true
			print("Hígado protege: ", organ_name)

	if GameManager.liver_percentage < 50:
		GameManager.liver_buff = false
		GameManager.liver_debuff = true

		for organ in GameManager.organs_health:
			GameManager.organs_health[organ]["protected"] = false
			print("Hígado desprotege: ", organ)

	elif GameManager.liver_percentage >= 50:
		GameManager.liver_debuff = false

func update_stomach() -> void:
	# Estómago: Genera glóbulos blancos (proteínas) que curan al personaje
	if GameManager.stomach_percentage > 0:		# Verifica si el temporizador está en marcha
		GameManager.stomach_debuff = false
		GameManager.stomach_buff = true
		if not stomach_timer.is_stopped():
			return  # Salimos si el temporizador ya está corriendo

		# Inicia el temporizador para generar proteínas
		stomach_timer.start()
	#if GameManager.stomach_percentage < 10:
		#GameManager.stomach_debuff = true
		#GameManager.stomach_buff = false
	
func update_pancreas() -> void:
	# Páncreas: Bloquea rutas cortas si su salud es baja
	var closeCount: Dictionary = {'main': 4, 'side': 4}

	if GameManager.pancreas_percentage < 30 and not GameManager.pancreas_debuff:

		print("Checking pancreas debuff")
		print("Pancreas debuffing")
		GameManager.pancreas_buff = false
		GameManager.pancreas_debuff = true

		closeMain = getRandArraySelection(mainDoors, closeCount['main'])
		closeSide = getRandArraySelection(sideDoors, closeCount['side'])

		for door in mainDoors:
			door.close()
		for door in sideDoors:
			door.close()

	elif GameManager.pancreas_percentage > 30:
		print('Open doors')
		GameManager.pancreas_buff = true
		GameManager.pancreas_debuff = false

		for door in mainDoors:
			door.open()
		for door in sideDoors:
			door.open()

func getRandArraySelection(array: Array[Node], amount: int) -> Array[Node]:
	var shuffled_array: Array = array.duplicate()
	shuffled_array.shuffle()

	return shuffled_array.slice(0, amount)

func update_heart() -> void:
	# Corazón: Afecta la velocidad del glóbulo
	
	if GameManager.heart_percentage < 30:
		GameManager.heart_buff = false
		GameManager.heart_debuff = true
		print("Velocidad reducida por baja salud del corazón")
func update_brain() -> void:
	# Cerebro: Reduce la interfaz y puede provocar la muerte
	if GameManager.brain_percentage < 70:
		GameManager.person_visible = false
	if GameManager.brain_percentage < 50:
		GameManager.labels_visible = false  # Esconde el contador de oxígeno
	if GameManager.brain_percentage <= 0:
		print("¡Game Over! El cerebro ha fallado")
		

func drain_organ_energy(organ: String) -> void:
	# Verifica si el órgano especificado existe y si su energía actual es mayor que 0
	if organ in GameManager.organs_health and GameManager.organs_health[organ]["current"] > 0:
		# Reduce la energía del órgano
		GameManager.organs_health[organ]["current"] -= drain_amount

		# Asegura que la energía no baje de 0
		GameManager.organs_health[organ]["current"] = max(0.0, GameManager.organs_health[organ]["current"])

		# Debug para mostrar la energía restante del órgano
# Condición de victoria
func check_victory(delta: float) -> void:
	if all_organs_active():
		time_with_all_organs_active += delta
		if time_with_all_organs_active >= victory_time:
			print("¡Victoria! Todos los órganos activos")
	else:
		time_with_all_organs_active = 0.0

func all_organs_active() -> bool:
	for health in [GameManager.brain_percentage, GameManager.stomach_percentage, GameManager.pancreas_percentage, GameManager.kidneys_percentage, GameManager.heart_percentage, GameManager.liver_percentage]:
		if health <= 0:
			return false
	return true

##TIMEOUTS
func _on_stomach_timer_timeout() -> void:
	print("Proteina generada")
