extends RayCast3D

var current_collider

@onready var interaction_lable = get_node("/root/World/UI/InteractionLable")

func _ready():
	set_interaction_text("")
	
func _process(delta):
	var collider = get_collider()
	
	if is_colliding() and collider is Interactable:
		if current_collider != collider:
			set_interaction_text(collider.get_interaction_text())
			current_collider = collider
		
		if Input.is_action_just_pressed("interact"):
			collider.interact()
			set_interaction_text(collider.get_interaction_text())
	elif current_collider:
		current_collider = null
		set_interaction_text("")

func set_interaction_text(text):
	if text == "":
		interaction_lable.set_text("")
		interaction_lable.set_visible(false)
	else:
		var interact_key = OS.get_keycode_string(InputMap.action_get_events("interact")[0].keycode)
		
		interaction_lable.set_text("Press %s to %s" % [interact_key,text])
		interaction_lable.set_visible(true)
