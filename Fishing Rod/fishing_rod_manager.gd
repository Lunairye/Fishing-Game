extends Node2D

var starting_power = 10
var power = starting_power
var power_max = 50
var power_scale_amount = 10
var power_scale_speed = 1

@onready var fishing_hook = $"Fishing Hook"
@onready var fishing_line = $"Fishing Line"
@onready var fishing_hook_reeled_marker = $"Fishing Hook Reeled Marker"
@onready var fishing_hook_current_marker = $"Fishing Hook/Hook Sprite/Fishing Hook Current Mark"

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if fishing_hook.hook_state == "reeled":
		while event.is_action_pressed("Fish"):
			await get_tree().create_timer(power_scale_speed).timeout
			power += power_scale_amount
		
		if event.is_action_released("Fish"):
			fishing_hook._launch(power)
			power = starting_power
	
	if fishing_hook.hook_state == "thrown" or fishing_hook.hook_state == "sinking":
		pass
	
func _physics_process(delta: float) -> void:
	fishing_line.set_point_position(0, to_local(fishing_hook_reeled_marker.global_position))
	fishing_line.set_point_position(1, to_local(fishing_hook_current_marker.global_position))
