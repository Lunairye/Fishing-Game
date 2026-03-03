extends RigidBody2D

var hook_state = ""
var reeled = "reeled"
var thrown = "thrown"
var sinking = "sinking"
var reeling = "reeling"

var reel_force

var launch_angle = PI/6
var launch_vector = Vector2.ZERO
var travel_vector = Vector2.ZERO

var line_length = 100

@onready var fishing_rod = self.find_parent("Fishing Rod")
@onready var reeled_marker = fishing_rod.find_child("Fishing Hook Reeled Marker")
var hook_to_centre = Vector2.ZERO

@onready var hook_sprite = $"Hook Sprite"
@onready var hook_current_marker = $"Hook Sprite/Fishing Hook Current Mark"
@onready var test_line = $Line2D

func _ready() -> void:
	hook_state = reeled


func _physics_process(delta: float) -> void:
	### Testing Stuff
	
	if fishing_rod.reeling:
		freeze = true
		global_position += -hook_to_centre.normalized() * fishing_rod.reel_force 
		hook_sprite.rotation = to_local(hook_current_marker.global_position + linear_velocity).angle() - PI/2
		
		if hook_current_marker.global_position.distance_to(reeled_marker.global_position) <= 5:
			hook_state = reeled
			global_position = reeled_marker.global_position
			freeze = false
	else:
		freeze = false 
	
	### State Machine
	if hook_state == reeled:
		gravity_scale = 0
	else:
		gravity_scale = 1
	
	if hook_state == sinking:
		print("sinking")
	
	if hook_state == thrown or hook_state == sinking:
		hook_sprite.rotation = to_local(hook_current_marker.global_position + linear_velocity).angle() - PI/2 
	else:
		hook_sprite.rotation = 0

func _launch(power: int) -> void:
	launch_vector.x = cos(launch_angle)
	launch_vector.y = -sin(launch_angle)
	launch_vector = launch_vector.normalized()
	
	apply_impulse(launch_vector * power)
	hook_state = thrown

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	hook_to_centre = hook_current_marker.global_position - reeled_marker.global_position
	
	if hook_to_centre.length() >= line_length:
		global_position = reeled_marker.global_position + hook_to_centre.limit_length(line_length)
