extends CharacterBody2D

# Variables del glóbulo rojo
@export var max_oxygen: int = 3  # Capacidad máxima de oxígeno
var oxygen_carried: int = 0  # Oxígeno que lleva actualmente

@export var base_speed: float = 300.0  # Velocidad base
var current_speed: float = base_speed  # Velocidad actual (modificable por buffs)


func _physics_process(delta: float):
	# Movimiento básico con WASD
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y -= current_speed
	if Input.is_action_pressed("move_down"):
		velocity.y += current_speed
	if Input.is_action_pressed("move_left"):
		velocity.x -= current_speed
	if Input.is_action_pressed("move_right"):
		velocity.x += current_speed

	# Normalizamos para evitar movimiento más rápido en diagonal
	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * current_speed

	move_and_slide()

# Recoger oxígeno
func collect_oxygen(amount: int) -> void:
	oxygen_carried += amount
	oxygen_carried = clamp(oxygen_carried, 0, max_oxygen)
	print("Oxígeno transportado: ", oxygen_carried)

# Entregar oxígeno a un órgano
func deliver_oxygen(organ) -> void:
	if oxygen_carried > 0:
		organ.receive_oxygen(oxygen_carried)
		oxygen_carried = 0
