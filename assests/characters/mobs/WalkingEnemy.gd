extends KinematicBody2D

var direction = Vector2.RIGHT
var velocity = Vector2.ZERO

onready var edgeCheckRight = $EdgeCheckRight
onready var edgeCheckLeft = $EdgeCheckLeft
onready var anim = $AnimatedSprite

func _physics_process(delta):
	var onWall = is_on_wall()
	var foundEdge = not edgeCheckRight.is_colliding() or not edgeCheckLeft.is_colliding()
	
	if onWall or foundEdge:
		direction*=-1
	anim.play("walkingNecro")
	anim.flip_h = direction.x < 0
	velocity = direction*25
	move_and_slide(velocity,Vector2.UP)
	
