extends Label
@onready var timer: Timer = $Timer

@onready var counter: Label = $"."
var current_time_left: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	counter.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if all_organs_active() == false or (current_time_left >= 30 and timer.time_left <= 0):
		counter.visible = false
	elif all_organs_active() and timer.time_left <= 0 and current_time_left < 30:
		counter.visible = true
		current_time_left += 1
		counter.text = str(current_time_left)
		timer.start()
		

func all_organs_active() -> bool:
	for health in [GameManager.brain_percentage, GameManager.stomach_percentage, GameManager.pancreas_percentage, GameManager.kidneys_percentage, GameManager.heart_percentage, GameManager.liver_percentage]:
		if health <= 50.0:
			return false
	return true
