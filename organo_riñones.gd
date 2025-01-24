extends Node2D

var activo = false
var porcentaje = 100
var quitar_obstaculos = true
var parar_contador = false

@onready var porcentaje_timer_riñones = $porcentaje_timer_riñones
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	porcentaje_timer_riñones.start()
	aplicar_debuff()
	decrece_porcentaje()
	desactivar_organo()
	
func aplicar_debuff():
	if porcentaje <= 50:
		quitar_obstaculos = false

func decrece_porcentaje():
	if activo == true and porcentaje_timer_riñones.time_left <= 0 and not parar_contador == true:
		porcentaje -= 1
		
func desactivar_organo():
	if porcentaje <= 0 and activo == true:
		activo = false
