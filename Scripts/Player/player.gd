extends CharacterBody2D

@export var SPEED = 400.0  # Velocidad del personaje
@onready var action_key: Sprite2D = $ActionKey
func _physics_process(delta: float) -> void:
	# Reiniciamos la velocidad en cada frame
	
	
	velocity = Vector2.ZERO
	
	if GameManager.key_sprite_show:
		action_key.visible = true
	else:
		action_key.visible = false
	# Detectar las teclas presionadas y ajustar la velocidad
	if Input.is_action_pressed("move_down"):
		velocity.y = SPEED
	if Input.is_action_pressed("move_up"):
		velocity.y = -SPEED
	if Input.is_action_pressed("move_right"):
		velocity.x = SPEED
	if Input.is_action_pressed("move_left"):
		velocity.x = -SPEED


	#Interacciones personaje
	if Input.is_action_just_pressed("trade") and GameManager.can_heal:
		heal_organ(GameManager.organ_name)
	 #Movemos el personaje
	move_and_slide()

func heal_organ(organName: String):
	if GameManager.organs_health[organName]["current"] < GameManager.organs_health[organName]["max"] and GameManager.oxigen_player > 0:
		GameManager.organs_health[organName]["current"] += GameManager.heal_organ_amount
		GameManager.oxigen_player -= 1	


func _on_area_2d_body_entered(body: Node2D) -> void:
	GameManager.key_sprite_show = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	GameManager.key_sprite_show = false
