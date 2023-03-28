extends Interactable
#extends "res://Interactable/Interactable.gd"

@export var light : NodePath
@export var on_by_default = true
@export var energy_when_on = 1
@export var energy_when_off = 0

@onready var light_node = get_node(light)
@onready var on = on_by_default

func _ready():
	set_light_energy()

func get_interaction_text():
	return "Extinguish Candle" if on else "Light the Candle"

func interact():
	on = !on
	set_light_energy()
	
func set_light_energy():
	light_node.set_param(Light3D.PARAM_ENERGY, energy_when_on if on else energy_when_off)
