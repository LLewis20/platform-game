extends CanvasLayer
var coins = 0

func _ready():
	$Label2.text = String(coins)

func _on_coin_coinCollected():
	coins = coins + 1
	_ready()
	



func _on_FLAG_touchedTheFlag():
	$VICTORY.text = "VICTORY"
