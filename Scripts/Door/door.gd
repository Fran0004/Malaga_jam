extends CharacterBody2D  # or Node2D


var is_open: bool = true

@export var door_id: int
@export_enum("main-doors", "side-doors") var door_type: String

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready():
	# Initial closed state
	collision.set_deferred("disabled", true)
	add_to_group(door_type)  # Auto-add to the specified group
	open()
	animated_sprite.play("open")


func toggle_door():
	if is_open:
		close()
	else:
		open()
		
func open():
	if not is_open:
		print("was closed now opening door", door_id)
		is_open = true
		print("is_open: ", is_open)
		animated_sprite.play("open")
		collision.set_deferred("disabled", true)

func close():
	if is_open:
		print('Closing door', door_id)
		is_open = false
		animated_sprite.play("close")
		collision.set_deferred("disabled", false)
		
func _on_body_entered(body: Node2D):
	print("Collision detected with:", body.name)
	if body.name == "Player":  # Ensure player is in the "player" group
		print("Player entered door area")

# Choose ONE interaction method below
