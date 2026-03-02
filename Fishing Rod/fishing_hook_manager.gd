extends RigidBody2D

var hook_state = ""
var reeled = "reeled"
var thrown = "thrown"
var sinking = "sinking"
var reeling = "reeling"

var launch_angle = PI/6
var launch_vector = Vector2.ZERO
var travel_vector = Vector2.ZERO

var line_length = 100

@onready var reeled_marker = self.find_parent("Fishing Rod").find_child("Fishing Hook Reeled Marker")
var centre_to_edge_vector = Vector2.ZERO
var tangent_vector = Vector2.ZERO
var override_velocity_max_length = false

@onready var hook_sprite = $"Hook Sprite"
@onready var hook_current_marker = $"Hook Sprite/Fishing Hook Current Mark"

func _ready() -> void:
	hook_state = reeled
	
	


func _physics_process(delta: float) -> void:
	if hook_state == reeled:
		gravity_scale = 0
	else:
		gravity_scale = 1
	
	if hook_state == sinking:
		print("sinking")
	
	if hook_state == thrown or hook_state == sinking:
		hook_sprite.rotation = to_local(hook_current_marker.global_position + linear_velocity).angle() + PI/2
	else:
		hook_sprite.rotation = 0

func _launch(power: int) -> void:
	launch_vector.x = cos(launch_angle)
	launch_vector.y = -sin(launch_angle)
	launch_vector = launch_vector.normalized()
	
	apply_impulse(launch_vector * power)
	hook_state = thrown

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	pass
