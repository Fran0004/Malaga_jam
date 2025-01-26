extends Node

# Variables específicas para funcionalidades de órganos
var obstacles: Array = []  # Lista de obstáculos para riñones
var short_routes: Array = []  # Lista de rutas cortas para el páncreas
var protected_organ: String = ""  # Organismo protegido por el hígado
var time_with_all_organs_active: float = 0.0  # Tiempo con todos los órganos activos
@export var victory_time: float = 30.0  # Tiempo necesario para ganar
@export var Type = OrganType.NONE
@export var organName: String
var time_accumulator: float = 0.0
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
var drain_interval: float = 1.0  # Cada cuánto tiempo se drena energía (en segundos)
@export var drain_amount: float = 0.005  # Cantidad de energía que se pierde por segundo# Called when the node enters the scene tree for the first time.
enum OrganType{
	NONE,
	HEART,
	BRAIN,
	KIDNEYS,
	LIVER,
	PANCREAS,
	STOMACH
}

##TIMERS
@onready var stomach_timer: Timer = $StomachTimer
@onready var organs_sprite: Sprite2D = $"."
func _ready() -> void:
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
	if time_accumulator >= drain_interval and protected_organ != organName:
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
		GameManager.liver_buff = true
		GameManager.liver_debuff = false
		var organs = ["brain", "stomach", "pancreas", "kidneys", "heart"]
		protected_organ = organs[randi() % organs.size()]
		print("Hígado protege: ", protected_organ)
	if GameManager.liver_percentage < 50:
		GameManager.liver_buff = false
		GameManager.liver_debuff = true
	elif GameManager.liver_percentage >= 50:
		GameManager.liver_debuff = false
		


func update_stomach() -> void:
	# Estómago: Genera glóbulos blancos (proteínas) que curan al personaje
	if GameManager.stomach_percentage > 0:	# Verifica si el temporizador está en marcha
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
	if GameManager.pancreas_percentage < 30:
		GameManager.pancreas_buff = false
		GameManager.pancreas_debuff = true
		
		for route in short_routes:
			route.block()
			print("Ruta corta bloqueada debido al páncreas")

func update_heart() -> void:
	# Corazón: Afecta la velocidad del glóbulo
	
	if GameManager.heart_percentage < 30:
		GameManager.heart_buff = false
		GameManager.heart_debuff = true
		print("Velocidad reducida por baja salud del corazón")
func update_brain() -> void:
	# Cerebro: Reduce la interfaz y puede provocar la muerte
	if GameManager.brain_percentage < 50:
		GameManager.person_visible = false
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
		print("%s energía restante: %.2f" % [organ, GameManager.organs_health[organ]["current"]])

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
