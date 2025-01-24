extends Node2D


var activo = false
var porcentaje = 100
var ruta_corta_bloqueada = false
var parar_contador = false

@onready var porcentaje_timer_pranceas = $porcentaje_timer_prancreas
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	porcentaje_timer_pranceas.start()
	aplicar_debuff()
	decrece_porcentaje()
	desactivar_organo()
	
func aplicar_debuff():
	if porcentaje <= 50:
		ruta_corta_bloqueada = true

func decrece_porcentaje():
	if activo == true and porcentaje_timer_pranceas.time_left <= 0 and not parar_contador == true:
		porcentaje -= 1
		
		
func desactivar_organo():
	if porcentaje <= 0 and activo == true:
		activo = false
		
		
		
		
