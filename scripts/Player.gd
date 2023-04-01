extends KinematicBody2D
class_name Player
export (Resource) var moveData
onready var anim = $AnimatedSprite
onready var ladderCheck = $LadderCheck
var velocity = Vector2.ZERO
var state = MOVE
var maxJumps = 2
var jumpCount = 0
var coins = 0
var flagTouched = false
enum {
	MOVE,
	CLIMB,
}

# locked normally to 60 fps
func _physics_process(delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left","ui_right") # returns -1 if left or 1 if right
	input.y = Input.get_axis("ui_up","ui_down") # returns -1 if up or 1 if down
	
	# godots version of switch statements
	match state:
		MOVE: move_state(input)
		CLIMB: climb_state(input)
	
	if coins == 8:
		get_tree().change_scene("res://World.tscn")
	
	#if flagTouched:
	#	get_tree().change_scene("res://World.tscn")
	

func move_state(input):
	anim.position.x = 0
	if is_on_ladder() and Input.is_action_pressed("ui_up"):
		state = CLIMB
	apply_gravity()
	if input.x == 0:
		apply_friction()
		anim.play("idle")
	else:
		apply_accel(input.x)
		anim.play("run")
		if input.x > 0:
			anim.flip_h = false
		elif input.x < 0:
			anim.flip_h = true
			
	
	
	if is_on_floor() and jumpCount < maxJumps:
		if Input.is_action_pressed("ui_up") :
			velocity.y = moveData.JUMP_FORCE
			jumpCount+=1
			
	else:
		anim.animation = 'jump'
		if Input.is_action_just_released("ui_up") and velocity.y < moveData.JUMP_RELEASE_FORCE:
			velocity.y = moveData.JUMP_RELEASE_FORCE
		if velocity.y > 0:
			velocity.y += moveData.INCREASED_GRAVITY
	
	var was_in_air = !is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	var just_landed = is_on_floor() and was_in_air
	if just_landed:
		anim.play("run")
		jumpCount = 0

func climb_state(input):
	$CollisionShape2D.position.x = 0
	if ! is_on_ladder():
		state = MOVE
		
	if input.length() != 0:
		anim.play("climb")
		$CollisionShape2D.position.x = -2
	velocity = input * 50
	velocity = move_and_slide(velocity,Vector2.UP)

func is_on_ladder():
	if not ladderCheck.is_colliding():
		return false
	var collider = ladderCheck.get_collider()
	if !collider is Ladder:
		return false
	return true

func apply_accel(amount):
	velocity.x = move_toward(velocity.x, moveData.MAX_SPEED * amount ,moveData.ACCELERATION)

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, moveData.FRICTION)
	anim.play("idle")

func apply_gravity():
	
	velocity.y += moveData.GRAVITY

func addCoin():
	coins += 1

func flagTouch():
	flagTouched = true
