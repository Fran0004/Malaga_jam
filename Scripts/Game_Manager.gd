extends Node

#Variables del player
var oxigen_player: int = 0
var max_oxigen_player: int = 10
var key_sprite_show: bool = false

# Variables de salud de los órganos
var organs_health: Dictionary = {
	"brain": {"current": 0.0, "max": 10.0},
	"stomach": {"current": 0.0, "max": 10.0},
	"pancreas": {"current": 0.0, "max": 10.0},
	"kidneys": {"current": 0.0, "max": 10.0},
	"heart": {"current": 0.0, "max": 10.0}
}

# Variables relacionadas con oxígeno y buffs
@export var oxygen_spawn_rate: float = 2.0  # Tiempo entre generación de oxígeno
@export var organ_energy_drain_rate: float = 5.0  # Energía que los órganos pierden por segundo

#Buff activables
var brain_buff: bool = false
var stomach_buff: bool = false
var pancreas_buff: bool = false
var kidneys_buff: bool = false
var liver_buff: bool = false
var heart_buff: bool = false

func trade_oxigen(organ):
	var oxigen_feed_percentage = 0.15
	#organ_health += oxigen_player * oxigen_feed_percentage
	oxigen_player = 0
	
