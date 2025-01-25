extends Node

var brain_health = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_brain(delta)
	
func update_brain(delta: float) -> void:
	# Cerebro: Reduce la interfaz y puede provocar la muerte
	if brain_health < 70:
		$HUD/Map.visible = false  # Esconde el mapa
	if brain_health < 50:
		$HUD/OxygenCounter.visible = false  # Esconde el contador de oxígeno
	if brain_health <= 0:
		print("¡Game Over! El cerebro ha fallado")
		get_tree().change_scene("res://scenes/GameOver.tscn")
