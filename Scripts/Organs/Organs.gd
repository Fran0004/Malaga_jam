extends Node

# Variables específicas para funcionalidades de órganos
var obstacles: Array   = []  # Lista de obstáculos para riñones

var time_with_all_organs_active: float = 0.0  # Tiempo con todos los órganos activos
var drain_multiplier: float 
@export var victory_time: float = 30.0  # Tiempo necesario para ganar
@export var Type = OrganType.NONE
@export var organName: String
var time_accumulator: float = 0.0
#var time_with_all_organs_above_0: float = 0.0
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
var drain_interval: float = 1.0  # Cada cuánto tiempo se drena energía (en segundos)
var mainDoors: Array[Node]
var sideDoors: Array[Node]
var closeMain: Array[Node]
var closeSide: Array[Node]
var closeCount: Dictionary = {'main': 4, 'side': 4}

enum OrganType{
	NONE,
	HEART,
	BRAIN,
	KIDNEYS,
	LIVER,
	PANCREAS,
	STOMACH
}

@export var drain_amount: float = 0.005  # Cantidad de energía que se pierde por segundo# Called when the node enters the scene tree for the first time.

##TIMERS
@onready var stomach_timer: Timer = $StomachTimer
@onready var organs_sprite: Sprite2D = $"."



func _ready() -> void:
	mainDoors = get_tree().get_nodes_in_group("main-doors")  # Lista de rutas cortas para páncreas
	sideDoors = get_tree().get_nodes_in_group("side-doors")
	closeMain = getRandArraySelection(mainDoors, closeCount['main'])
	closeSide = getRandArraySelection(sideDoors, closeCount['side'])  # Lista de rutas cortas para páncreas
	if Type == OrganType.NONE:
		collision_shape_2d.disabled
		
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
	if GameManager.kidneys_percentage == 0:
		GameManager.kidneys_buff = true
		GameManager.kidneys_debuff = false

		for obstacle in obstacles:
			obstacle.queue_free()  # Eliminar obstáculos si los riñones están saludables
	else:
		$"../Node/aviso".play()
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

	if GameManager.liver_percentage < 50:
		GameManager.liver_buff = false
		GameManager.liver_debuff = true

		for organ in GameManager.organs_health:
			GameManager.organs_health[organ]["protected"] = false

	elif GameManager.liver_percentage >= 50:
		GameManager.liver_buff = true
		GameManager.liver_debuff = false
		var organs = ["brain", "stomach", "pancreas", "kidneys", "heart"]
		var protected_organ = organs[randi() % organs.size()]
	if GameManager.liver_percentage == 0:
		$"../Node/aviso".play()
		GameManager.liver_buff = false
		GameManager.liver_debuff = true
	elif GameManager.liver_percentage > 0:
		GameManager.liver_debuff = false

func update_stomach() -> void:
	# Estómago: Genera glóbulos blancos (proteínas) que curan al personaje
	if GameManager.stomach_percentage == 0:	# Verifica si el temporizador está en marcha
		GameManager.stomach_debuff = false
		GameManager.stomach_buff = true
	else:
		GameManager.stomach_debuff = true
		GameManager.stomach_buff = false
		
	
		#if not stomach_timer.is_stopped():
			#return  # Salimos si el temporizador ya está corriendo

		# Inicia el temporizador para generar proteínas
		stomach_timer.start()
	if GameManager.stomach_percentage == 0:
		$"../Node/aviso".play()
		GameManager.stomach_debuff = true
		GameManager.stomach_buff = false
	
#func delete_obstacles():
#	if GameManager.pancreas_buff == true and stomach_timer.time_left <= 0.0 and not stomach_timer.is_stopped():
#		obstacles[randi() % obstacles.size()].queue_free()
#		stomach_timer.start()

func update_pancreas() -> void:
	# Páncreas: Bloquea rutas cortas si su salud es baja

	if GameManager.pancreas_percentage < 30 and not GameManager.pancreas_debuff:

		print("Checking pancreas debuff")
		print("Pancreas debuffing")
		GameManager.pancreas_buff = false
		GameManager.pancreas_debuff = true

		closeMain = getRandArraySelection(mainDoors, closeCount['main'])
		closeSide = getRandArraySelection(sideDoors, closeCount['side'])

		for door in closeMain:
			door.close()
		for door in closeSide:
			door.close()
	
	elif GameManager.pancreas_percentage < 30:
		for door in closeMain:
			door.close()
		for door in closeSide:
			door.close()

	elif GameManager.pancreas_percentage > 50:
		if GameManager.pancreas_percentage == 0:
			$"../Node/aviso".play()
			GameManager.pancreas_buff = false
			GameManager.pancreas_debuff = true
		if GameManager.pancreas_percentage > 0:
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
	
	if GameManager.heart_percentage < 0:
		$"../Node/aviso".play()
		GameManager.heart_buff = false
		GameManager.heart_debuff = true
	if GameManager.heart_percentage >= 0:
		GameManager.heart_buff = true
		GameManager.heart_debuff = false
	if GameManager.heart_debuff == true and GameManager.SPEED > 175:
		GameManager.SPEED = GameManager.SPEED * 0.95

	 

func update_brain() -> void:
	# Cerebro: Reduce la interfaz y puede provocar la muerte
	if GameManager.brain_percentage < 15:
		$"../Node/aviso".play()
		GameManager.person_visible = false
		GameManager.labels_visible = false
	if GameManager.brain_percentage > 15:
		GameManager.person_visible = true
		GameManager.labels_visible = true
	if GameManager.brain_percentage <= 0:
		GameManager.losing = true
		get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")
		GameManager.losing = false
		

func drain_organ_energy(organ: String) -> void:
	# Verifica si el órgano especificado existe y si su energía actual es mayor que 0
	if organ in GameManager.organs_health and GameManager.organs_health[organ]["current"] > 0 and not GameManager.organs_health[organ]["protected"]:
		# Reduce la energía del órgano
		if GameManager.kidneys_debuff == true:
			drain_multiplier = 2
		else: drain_multiplier = 1
		GameManager.organs_health[organ]["current"] -= drain_amount * drain_multiplier
		# Asegura que la energía no baje de 0
		GameManager.organs_health[organ]["current"] = max(0.0, GameManager.organs_health[organ]["current"])


func check_victory(delta: float) -> void:
	if all_organs_active():
		time_with_all_organs_active += delta
		if time_with_all_organs_active >= victory_time:
			GameManager.winning = true
			get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")
			GameManager.winning = false
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


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.key_sprite_show = true
		GameManager.organ_name = organName
		GameManager.can_heal = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.key_sprite_show = false
		GameManager.organ_name = ""
		GameManager.can_heal = false
