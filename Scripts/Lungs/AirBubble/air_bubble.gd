extends Area2D

# Movement properties
var speed : float
var direction : float
var velocity : Vector2

# Circular room properties (radius from center)
@export var room_radius : float = 400.0    # Circle radius
@export var room_center : Vector2 = Vector2(200, 100)  # Center of circular area

func _ready():
	randomize_velocity()

func _process(delta):
	position += velocity * delta
	check_circular_boundary()

func randomize_velocity():
	# Random speed between 50-200 pixels/second
	speed = randf_range(50, 200)
	
	# Random direction (0-360 degrees)
	direction = randf_range(0, 360)
	
	# Convert to velocity vector
	velocity = Vector2.from_angle(deg_to_rad(direction)) * speed

func check_circular_boundary():
	var to_center = position - room_center
	var distance_from_center = to_center.length()
	
	if distance_from_center > room_radius:
		# Calculate reflection using normal vector pointing out from circle
		var normal = to_center.normalized()
		randomize_velocity()
		
		# Position correction to keep inside circle
		position = room_center + normal * room_radius * 0.95

func set_initial_position(pos: Vector2):
	position = pos
