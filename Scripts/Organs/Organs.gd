extends Node

# Variables específicas para funcionalidades de órganos
var obstacles: Array = []  # Lista de obstáculos para riñones
var short_routes: Array = []  # Lista de rutas cortas para el páncreas
var protected_organ: String = ""  # Organismo protegido por el hígado
var time_with_all_organs_active: float = 0.0  # Tiempo con todos los órganos activos
@export var victory_time: float = 30.0  # Tiempo necesario para ganar
@export var Type = OrganType.NONE
@export var energy_drain_rate: float = 1.0  # Energía que pierden los órganos cada segundo
# Called when the node enters the scene tree for the first time.
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
	drain_organ_energy(delta)
	check_victory(delta)
	

func update_kidneys() -> void:
	# Riñones: Limpian la sangre (quitan obstáculos)
	if GameManager.kidneys_health > 50:
		for obstacle in obstacles:
			obstacle.queue_free()  # Eliminar obstáculos si los riñones están saludables

func update_liver() -> void:
	# Hígado: Protege un órgano y detiene su desgaste de energía
	if GameManager.liver_health > 0 and protected_organ == "":
		var organs = ["brain", "stomach", "pancreas", "kidneys", "heart"]
		protected_organ = organs[randi() % organs.size()]
		print("Hígado protege: ", protected_organ)

func drain_organ_energy(delta: float) -> void:
	for organ in GameManager.organs_health.keys():
		# Si el órgano no está protegido
		if organ != protected_organ:
			# Reduce la energía actual basándose en el tiempo transcurrido (delta)
			GameManager.organs_health[organ]["current"] -= energy_drain_rate * delta
			
			# Asegúrate de que la energía no baje de cero
			if GameManager.organs_health[organ]["current"] < 0.0:
				GameManager.organs_health[organ]["current"] = 0.0
			
			# Debug para mostrar la energía restante del órgano
			print(organ, " energía restante: ", GameManager.organs_health[organ]["current"])

func update_stomach() -> void:
	# Estómago: Genera glóbulos blancos (proteínas) que curan al personaje
	if GameManager.stomach_health > 0:
		# Verifica si el temporizador está en marcha
		if not stomach_timer.is_stopped():
			return  # Salimos si el temporizador ya está corriendo

		# Inicia el temporizador para generar proteínas
		stomach_timer.start()


func update_pancreas() -> void:
	# Páncreas: Bloquea rutas cortas si su salud es baja
	if GameManager.pancreas_health < 30:
		for route in short_routes:
			route.block()
			print("Ruta corta bloqueada debido al páncreas")

func update_heart() -> void:
	# Corazón: Afecta la velocidad del glóbulo
	
	if GameManager.heart_health < 30:
		
		print("Velocidad reducida por baja salud del corazón")
	else:
		print("Velocidad normal")

func update_brain(delta: float) -> void:
	# Cerebro: Reduce la interfaz y puede provocar la muerte
	if GameManager.brain_health < 70:
		$HUD/Map.visible = false  # Esconde el mapa
	if GameManager.brain_health < 50:
		$HUD/OxygenCounter.visible = false  # Esconde el contador de oxígeno
	if GameManager.brain_health <= 0:
		print("¡Game Over! El cerebro ha fallado")
		get_tree().change_scene("res://scenes/GameOver.tscn")



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
	for health in [GameManager.brain_health, GameManager.stomach_health, GameManager.pancreas_health, GameManager.kidneys_health, GameManager.liver_health, GameManager.heart_health]:
		if health <= 0:
			return false
	return true

##TIMEOUTS
func _on_stomach_timer_timeout() -> void:
	print("Proteina generada")
