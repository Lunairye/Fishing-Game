extends Node2D

var starting_power = 10
var power = starting_power
var power_max = 25
var power_scale_amount = 5
var power_scale_speed = 1

var charging = true
var charge_timer = 0.0
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
			power = starting_power
		
		if event.is_action_released("Fish") && charging:
			charging = false
			fishing_hook._launch(power)
			power = starting_power
			charge_timer = 0.0
	
	
	
func _physics_process(delta: float) -> void:
	_charging(delta)
	_reeling(delta)
	_update_fishing_line()
	
	

func _charging(delta: float) -> void:
	if !charging:
		return
	
	charge_timer += delta
	
	if charge_timer >= power_scale_speed:
		charge_timer = 0.0
		power = min(power + power_scale_amount, power_max)
		print("Power: ", power)

func _reeling(delta: float) -> void:
	if fishing_hook.hook_state == "thrown" or fishing_hook.hook_state == "sinking":
		if Input.is_action_just_pressed("Fish"):
			reeling = true
		if Input.is_action_just_released("Fish"):
			reeling = false
	
	if reeling and fishing_hook.hook_state != "reeled":
		var direction = (fishing_hook_reeled_marker.global_position - fishing_hook.global_position)
		var distance = direction.length()

		if distance < 5.0:
			reeling = false
			fishing_hook.hook_state = "reeled"
			fishing_hook.global_position = fishing_hook_reeled_marker.global_position
		else:
			# Reel faster when further away, for a natural feel
			var reel_velocity = direction.normalized() * reel_speed * delta
			fishing_hook.global_position += reel_velocity

func _update_fishing_line() -> void:
	fishing_line.set_point_position(0, to_local(fishing_hook_reeled_marker.global_position))
	fishing_line.set_point_position(1, to_local(fishing_hook_current_marker.global_position))
