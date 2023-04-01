extends Area2D

signal touchedTheFlag

func _on_FLAG_body_entered(body):
	body.flagTouch()
	emit_signal("touchedTheFlag")
