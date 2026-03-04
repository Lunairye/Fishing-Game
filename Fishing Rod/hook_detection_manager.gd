extends Area2D

func _on_body_entered(body: Node2D) -> void:
	_sinking(body)
	_catch(body)

func _sinking(body):
	var body_is_water = body.is_in_group("Water")
	
	print(body_is_water)

func _catch(body):
	var body_is_catchable = body.is_in_group("Catchable")
	
	print(body_is_catchable)
