extends Node2D


var activo = false
var velocidad = 1
var porcentaje = 100

@onready var porcentaje_timer_corazon = $porcentaje_timer_corazon
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	porcentaje_timer_corazon.start()
	
func aplicar_primer_debuff():
	if 25 <= porcentaje <= 50:
		velocidad = velocidad * 0.75
func aplicar_segundo_debuff():
	if porcentaje <= 25 and activo == true:
		velocidad = velocidad * 0.5

func decrece_porcentaje():
	if activo == true and porcentaje_timer_corazon.time_left <= 0:
		porcentaje -= 1
		
		
func desactivar_organo():
	if porcentaje <= 0 and activo == true:
		activo = false
		
		
		
		
