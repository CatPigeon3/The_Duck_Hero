extends CharacterBody2D

@export var speed = 300

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

const JUMP_VELOCITY = -500.0
var timer = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(_delta):

	var horizontal_direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = speed * horizontal_direction

	# makes the player be affected by gravity when not on the floor
	if not is_on_floor():
		velocity.y += gravity * _delta

	# makes the player jump with a certain velocity when pressing the space bar
	if Input.is_action_just_pressed("ui_accept") && is_on_floor():
		velocity.y = JUMP_VELOCITY

	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == -1)

	if Input.is_action_pressed("Dash"):
		velocity.x += 250*horizontal_direction

	if is_on_wall() and (position.x >= 2445) and (horizontal_direction == 1):
		reset_pos(1)
	elif is_on_wall() and (position.x <= 50) and (horizontal_direction == -1):
		reset_pos(0)

	if is_on_ceiling():
		position.y = 600

	move_and_slide()

	update_animations(horizontal_direction)

func reset_pos(reset):
	if reset == 1:
		position.x = 10
	elif reset == 0:
		position.x = 2445

func update_animations(horizontal_direction):
	if is_on_floor() && not (Input.is_action_pressed("Attack") or Input.is_action_just_released("Attack") or Input.is_action_pressed("Dash")):
		if horizontal_direction == 0:
			ap.play("Idle")
		elif horizontal_direction != 0 and not (Input.is_action_pressed("Dash") or Input.is_action_just_pressed("Dash")):
			ap.play("walk")
	elif Input.is_action_pressed("Dash"): 
		ap.play("DuckDash")
	elif Input.is_action_just_pressed("Attack"):
		if Input.is_action_just_pressed("Attack") && not Input.is_action_pressed("ui_down"):
			ap.play("lvariantslash")
		elif Input.is_action_pressed("Attack"):
			ap.play("downslash")
