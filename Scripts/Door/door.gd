extends Area2D  # or Node2D


var is_open: bool = true

@export var door_id: int
@export_enum("main-doors", "side-doors") var door_type: String

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready():
	# Initial closed state
	collision.disabled = true
	add_to_group(door_type)  # Auto-add to the specified group
	body_entered.connect(_on_body_entered)

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
		collision.disabled = true  # Disable collision when open

func close():
	if is_open:
		print('Closing door', door_id)
		is_open = false
		animated_sprite.play("close")
		collision.disabled = false  # Enable collision when closed
		
func _on_body_entered():
	print('Collision detected')

# Choose ONE interaction method below
