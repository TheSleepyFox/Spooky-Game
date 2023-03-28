extends CharacterBody3D

@export var speed = 3
@export var acceleration = 2.5
@export var deceleration = 7
@export var gravity = 0.98
@export var jump_power = 20
@export var mouse_sensitivity = 0.3

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var torchMarker = get_node("Head/Camera3D/TorchMarker3D")
@onready var torchLowMarker = get_node("Head/Camera3D/TorchLowMarker3D")
@onready var torchLight = $Head/Camera3D/TorchSpotLight3D
@onready var body_collision = get_node("CollisionShape3D")

#var velocity = Vector3()
#var bodies_in_TorchCollision = 0
@onready var torch_light_node = get_node("Head/Camera3D/TorchSpotLight3D")
var crouch_position = Vector3(0,0.7,0)
var camera_x_rotation = 0
var menu_open = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion and menu_open:
		head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		var x_delta = event.relative.y * mouse_sensitivity
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90:
			camera.rotate_x(deg_to_rad(-x_delta))
			camera_x_rotation += x_delta

func _process(delta):
	if Input.is_action_just_pressed("alternate_fire"):
		torchLight.position = torchMarker.position
		torchLight.rotation = torchMarker.rotation
	if Input.is_action_just_released("alternate_fire"):
		torchLight.position = torchLowMarker.position
		torchLight.rotation = torchLowMarker.rotation
		
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		menu_open = false
		
	if Input.is_action_pressed("sprint"):
		speed = 10
		acceleration = 5
		deceleration = 7
		jump_power = 25
		
	if Input.is_action_just_released("sprint"):
		speed = 3
		acceleration = 2.5
		deceleration = 7
		jump_power = 15
		
	if Input.is_action_just_pressed("interact"):
		print("test",torch_light_node.light_energy)
		if (torch_light_node.light_energy > 0):
			torch_light_node.set_param(Light3D.PARAM_ENERGY, 0)
		elif (torch_light_node.light_energy == 0):
			torch_light_node.set_param(Light3D.PARAM_ENERGY, 1)
	
	if Input.is_action_just_pressed("crouch"):
		body_collision.position = body_collision.position + crouch_position
	if Input.is_action_just_released("crouch"):
		body_collision.position = body_collision.position - crouch_position

func _physics_process(delta):
	var head_basis = head.get_global_transform().basis
	
	var direction = Vector3()
	if Input.is_action_pressed("move_forward"):
		direction -= head_basis.z 
	elif Input.is_action_pressed("move_backward"):
		direction += head_basis.z 
		
	if Input.is_action_pressed("move_left"):
		direction -= head_basis.x
	elif Input.is_action_pressed("move_right"):
		direction += head_basis.x
		
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed, deceleration * delta)
	velocity.y -= gravity
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y += jump_power
	
	move_and_slide()


#func _on_torch_area_3d_body_entered(body):
#	torchLight.position = torchMarker
#	bodies_in_TorchCollision +=1
#	print("volume entered", bodies_in_TorchCollision)


#func _on_torch_area_3d_body_exited(body):
#	bodies_in_TorchCollision -=1
#	print("volume exited", bodies_in_TorchCollision)
#	if(bodies_in_TorchCollision <= 0):
#		torchLight.position = torchLowMarker
