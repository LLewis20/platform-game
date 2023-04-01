extends Node2D

func _ready():
	VisualServer.set_default_clear_color(Color.cadetblue)


func _on_killplane_body_entered(body):
	$PlayerChar.position.x = 27
	$PlayerChar.position.y = 81

