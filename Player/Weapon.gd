class_name Weapon
extends Node

@export var fire_rate = 0.5
@export var clip_size = 6
@export var reload_rate = 2

@onready var ammo_lable = $"/root/World/UI/Label"
@onready var raycast = $"../Head/Camera3D/RayCast3D"

var current_ammo = 0
var can_fire = true
var reloading = false

func _ready():
	current_ammo = clip_size
	
func _process(delta):
	if reloading:
		ammo_lable.set_text("Reloading..")
	else:	
		ammo_lable.set_text("%d / %d" % [current_ammo, clip_size])
		
	if Input.is_action_just_pressed("primary_fire") and can_fire:
		if current_ammo > 0 and not reloading:
			fire()
		elif not reloading:
			reload()
			
	if Input.is_action_just_pressed("Reload") and not reloading:
		reload()
		
func check_collision():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.is_in_group("Enemies"):
			collider.queue_free()
			print("you murdered an innocent")

func fire():
	can_fire = false
	current_ammo -= 1
	check_collision()
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true

func reload():
	reloading = true
	await get_tree().create_timer(reload_rate).timeout
	current_ammo = clip_size
	reloading = false
