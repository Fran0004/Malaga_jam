extends Node2D


var activo = false
var porcentaje = 100
var vista_nublada = false
var vista_oxigeno_oculto = false
var vista_mapa_oculto = false

@onready var porcentaje_timer_cerebro = $porcentaje_timer_cerebro
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	porcentaje_timer_cerebro.start()
	
func aplicar_primer_debuff():
	if 50 <= porcentaje <= 75:
		vista_nublada = true
func aplicar_segundo_debuff():
	if porcentaje <= 25 and activo == true:
		vista_oxigeno_oculto = true
func aplicar_tercer_debuff():
	if porcentaje <= 25 and activo == true:
		vista_mapa_oculto = true

func decrece_porcentaje():
	if activo == true and porcentaje_timer_cerebro.time_left <= 0:
		porcentaje -= 1
		
func desactivar_organo():
	if porcentaje <= 0 and activo == true:
		activo = false
		#Esto implica game over
		
