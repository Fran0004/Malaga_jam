extends Node

#Variables del player
@export var oxigen_player: int = 0
@export var max_oxigen_player: int = 30
var can_heal: bool = false
var key_sprite_show: bool = can_heal
var organ_name: String = ""
@export var SPEED = 300.0 

# Variables de salud de los órganos
@export var organs_health: Dictionary = {
	"brain": {"current": 10.0, "max": 10.0},
	"stomach": {"current": 5.0, "max": 10.0},
	"pancreas": {"current": 3.0, "max": 10.0},
	"kidneys": {"current": 5.0, "max": 10.0},
	"liver": {"current": 2.0, "max": 10.0},
	"heart": {"current": 3.0, "max": 10.0}
}

var heal_organ_amount: float = 0.3

var brain_percentage: float 
var stomach_percentage: float 
var pancreas_percentage: float 
var kidneys_percentage: float 
var liver_percentage: float 
var heart_percentage: float 



#Buff activables
var brain_buff: bool = false
var stomach_buff: bool = false
var pancreas_buff: bool = false
var kidneys_buff: bool = false
var liver_buff: bool = false
var heart_buff: bool = false

#DeBuff activables
var brain_debuff: bool = false
var stomach_debuff: bool = false
var pancreas_debuff: bool = false
var kidneys_debuff: bool = false
var liver_debuff: bool = false
var heart_debuff: bool = false
# HUD

var person_visible: bool = true
var labels_visible: bool = true


func _process(delta: float) -> void:
	brain_percentage = (organs_health["brain"]["current"]/organs_health["brain"]["max"]) * 100
	kidneys_percentage = (organs_health["kidneys"]["current"]/organs_health["kidneys"]["max"]) * 100
	stomach_percentage = (organs_health["stomach"]["current"]/organs_health["stomach"]["max"]) * 100
	heart_percentage = (organs_health["heart"]["current"]/organs_health["heart"]["max"]) * 100
	liver_percentage = (organs_health["liver"]["current"]/organs_health["liver"]["max"]) * 100
	pancreas_percentage = (organs_health["pancreas"]["current"]/organs_health["brain"]["max"]) * 100
	
	
