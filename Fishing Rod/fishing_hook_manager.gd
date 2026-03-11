extends RigidBody2D

var hook_state = ""
var reeled = "reeled"
var thrown = "thrown"
var sinking = "sinking"
var reeling = "reeling"

var in_water = false
var off_hook = false
var reeling_hook = false

var launch_angle = PI/6
var line_length = 100

var water_slowdown = 0.1

var launch_vector = Vector2.ZERO
var travel_vector = Vector2.ZERO
var hook_to_centre = Vector2.ZERO

@onready var fishing_rod = self.find_parent("Fishing Rod")
@onready var reeled_marker = fishing_rod.find_child("Fishing Hook Reeled Marker")
@onready var hook_sprite = $"Hook Sprite"
@onready var hook_current_marker = $"Hook Sprite/Fishing Hook Current Mark"
@onready var test_line = $Line2D

func _ready() -> void:
	off_hook = false


func _physics_process(delta: float) -> void:
	_reel()
	_state_machine()


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	hook_to_centre = hook_current_marker.global_position - reeled_marker.global_position
	
	if hook_to_centre.length() >= line_length:
		global_position = reeled_marker.global_position + hook_to_centre.limit_length(line_length)


func _reel():
	if fishing_rod.reeling:
		freeze = true
		global_position += -hook_to_centre.normalized() * fishing_rod.reel_force 
		hook_sprite.rotation = to_local(hook_current_marker.global_position + linear_velocity).angle() - PI/2
		
		if hook_current_marker.global_position.distance_to(reeled_marker.global_position) <= 5:
			off_hook = false
			global_position = reeled_marker.global_position
			freeze = false
	else:
		freeze = false

func _state_machine():
	if reeling_hook:
		hook_state = reeling
	elif !in_water:
		if !off_hook:
			hook_state = reeled
		else:
			hook_state = thrown
	else:
		if !off_hook:
			print("MAJOR ERROR HELP PLEASE OH GOD HELP")
		else:
			hook_state = sinking
	
	match hook_state:
		reeled:
			gravity_scale = 0
			hook_sprite.rotation = 0
		thrown:
			gravity_scale = 1
			hook_sprite.rotation = to_local(hook_current_marker.global_position + linear_velocity).angle() - PI/2 
		sinking:
			gravity_scale = 0.1
			hook_sprite.rotation = to_local(hook_current_marker.global_position + linear_velocity).angle() - PI/2 


func _launch(power: int) -> void:
	launch_vector.x = cos(launch_angle)
	launch_vector.y = -sin(launch_angle)
	launch_vector = launch_vector.normalized()
	
	off_hook = true
	
	apply_impulse(launch_vector * power)


func _on_collection_zone_body_entered(body: Node2D) -> void:
	_sinking(body)
	_catch(body)

func _sinking(body):
	var body_is_water = body.is_in_group("Water")
	if body_is_water:
		in_water = true
		linear_velocity *= water_slowdown

func _catch(body):
	var body_is_catchable = body.is_in_group("Catchable")

func _on_collection_zone_body_exited(body: Node2D) -> void:
	_unsinking(body)

func _unsinking(body):
	var body_is_water = body.is_in_group("Water")
	if body_is_water:
		in_water = false
