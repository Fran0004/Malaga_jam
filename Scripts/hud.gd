extends Control
@onready var body_hud: Sprite2D = $BodyHud

##Alerts
@onready var alert_brain: Sprite2D = $BodyHud/AlertBrain
@onready var alert_heart: Sprite2D = $BodyHud/AlertHeart
@onready var alert_kidneys: Sprite2D = $BodyHud/AlertKidney
@onready var alert_liver: Sprite2D = $BodyHud/AlertLiver
@onready var alert_pancreas: Sprite2D = $BodyHud/AlertPancreas
@onready var alert_stomach: Sprite2D = $BodyHud/AlertStomach

## UpperLabel
@onready var labels: Control = $Labels

##Labels
@onready var stomach_label: Label = $Labels/StomachLabel
@onready var brain_label: Label = $Labels/BrainLabel
@onready var pancreas_label: Label = $Labels/PancreasLabel
@onready var kidneys_label: Label = $Labels/KidneysLabel
@onready var heart_label: Label = $Labels/HeartLabel
@onready var liver_label: Label = $Labels/LiverLabel
@onready var counter: Label = $Counter
@onready var bubble_label: Label = $BubbleHud/BubbleLabel

func _process(delta: float) -> void:
	body_hud.visible = GameManager.person_visible
	labels.visible = GameManager.labels_visible

	alert_brain.visible = GameManager.brain_debuff
	alert_stomach.visible = GameManager.stomach_debuff
	alert_liver.visible = GameManager.liver_debuff
	alert_heart.visible = GameManager.heart_debuff
	alert_kidneys.visible = GameManager.kidneys_debuff
	alert_brain.visible = GameManager.brain_debuff
	
	brain_label.text = "%.2f" % GameManager.brain_percentage +"%"
	heart_label.text = "%.2f" % GameManager.heart_percentage +"%"
	stomach_label.text = "%.2f" % GameManager.stomach_percentage +"%"
	liver_label.text = "%.2f" % GameManager.liver_percentage +"%"
	pancreas_label.text = "%.2f" % GameManager.pancreas_percentage +"%"
	kidneys_label.text = "%.2f" % GameManager.kidneys_percentage +"%"
	
