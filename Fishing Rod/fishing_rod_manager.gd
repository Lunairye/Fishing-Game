extends Node2D

var starting_power = 10
var power = starting_power
var power_max = 50
var power_scale_amount = 10
var power_scale_speed = 1

var charging = true
var reeling = false

var reel_force = 1
var reel_speed = 0.2
@onready var fishing_hook = $"Fishing Hook"
@onready var fishing_line = $"Fishing Line"
@onready var fishing_hook_reeled_marker = $"Fishing Hook Reeled Marker"
@onready var fishing_hook_current_marker = $"Fishing Hook/Hook Sprite/Fishing Hook Current Mark"

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if fishing_hook.hook_state == "reeled":
		if event.is_action_pressed("Fish"):
			charging = true
			while charging:
				print(power)
				await get_tree().create_timer(power_scale_speed).timeout
				power += power_scale_amount
				
				if power >= power_max:
					power = power_max
		
		if event.is_action_released("Fish") && charging:
			charging = false
			fishing_hook._launch(power)
			power = starting_power
	
	
	
func _physics_process(delta: float) -> void:
	
	if fishing_hook.hook_state == "thrown" or fishing_hook.hook_state == "sinking":
		if Input.is_action_just_pressed("Fish"):
			reeling = true
		
		if Input.is_action_just_released("Fish"):
			reeling = false
	
	fishing_line.set_point_position(0, to_local(fishing_hook_reeled_marker.global_position))
	fishing_line.set_point_position(1, to_local(fishing_hook_current_marker.global_position))
