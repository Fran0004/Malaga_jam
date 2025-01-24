extends Node2D


var activo = false
var porcentaje = 100
var ruta_corta_bloqueada = false

@onready var porcentaje_timer_estomago = $porcentaje_timer_estomago
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	porcentaje_timer_estomago.start()
	
func aplicar_debuff():
	if porcentaje <= 50:
		ruta_corta_bloqueada = true

func decrece_porcentaje():
	if activo == true and porcentaje_timer_estomago.time_left <= 0:
		porcentaje -= 1
		
		
func desactivar_organo():
	if porcentaje <= 0 and activo == true:
		activo = false
		
		
		
		
