extends Area2D

signal coinCollected


func _ready():
	$AnimationPlayer.play("bounce")

func _on_coin_body_entered(body):
	body.addCoin()
	emit_signal("coinCollected")
	queue_free()
