extends Actor

export var stomp_impulse = 1000.0
var playerstate = 0
signal player_state(ps)
signal start_scroll
signal died
var attacking = false
var flipped = -1
var hitstun = false
var dashing = false
var dashes_left = 1
var just_attacking = false
var x_speed
var y_speed

func _ready() -> void:
	$"/root/Level".connect("die", self, "reset")
	PlayerData.teleporting = false

func _process(_delta):
	pass

func _physics_process(_delta: float) -> void:
	if is_on_floor():
		playerstate = 0
	else: playerstate = 1
#Playerstates: 0 = idle/floored, 1 = airborne, 2 = dashing, 3 = hitstun, 4 = tping
	match playerstate:
		0:
			movement()
		1:
			movement()
		2:
			pass
		3:
			pass
		4:
			pass
	emit_signal("player_state",playerstate)

func movement() -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	if hitstun == true:
		_velocity.y = -stomp_impulse
		hitstun = false
	x_speed = _velocity.x
	y_speed = _velocity.y

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var out = linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y = 0.0
	return out


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		attacking = true

func reset():
	position.y = position.y - $"/root/Level/camera".pos_before_reset
