extends Node2D


var activo = true
var porcentaje = 100
var mandar_globulos_blancos = true
var parar_contador = false

@onready var porcentaje_timer_estomago = $porcentaje_timer_estomago
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	porcentaje_timer_estomago.start()
	aplicar_debuff()
	decrece_porcentaje()
	desactivar_organo()
	
func aplicar_debuff():
	if porcentaje <= 50:
		mandar_globulos_blancos = false

func decrece_porcentaje():
	if activo == true and porcentaje_timer_estomago.time_left <= 0 and not parar_contador == true:
		porcentaje -= 1
		
		
func desactivar_organo():
	if porcentaje <= 0 and activo == true:
		activo = false
		
		
		
