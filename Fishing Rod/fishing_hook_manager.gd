extends RigidBody2D

var state = ""
var reeled = "reeled"
var thrown = "thrown"

var launch_angle = PI/6
var launch_vector = Vector2.ZERO
var travel_vector = Vector2.ZERO

var line_length = 100

func _ready() -> void:
	state = reeled


func _physics_process(delta: float) -> void:
	if state == reeled:
		self.gravity_scale = 0
	else:
		self.gravity_scale = 1
	
	travel_vector = self.linear_velocity.normalized()
	
	print(travel_vector)
	

func _launch(power: int) -> void:
	launch_vector.x = cos(launch_angle)
	launch_vector.y = -sin(launch_angle)
	launch_vector.normalized()
	
	self.apply_impulse(launch_vector * power)
	state = thrown
	
