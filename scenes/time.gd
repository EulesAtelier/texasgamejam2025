extends Sprite2D



func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.name=="Player" && body.get_child(0).name == "Timer"):
		body.get_child(0).stop()
		body.get_child(0).wait_time += 20  # New time in seconds
		body.get_child(0).start()
		$AudioStreamPlayer2D.play()
