extends Actor

export var stomp_impulse = 1000.0
var playerstate = 0
signal player_state(ps)
var attacking = false
var flipped = -1
var hitstun = false
var dashing = false
var dashes_left = 1
var just_attacking = false
var x_speed
var y_speed

func _ready() -> void:
	PlayerData.teleporting = false
	$EnemyDetector/SwordHitbox.disabled = true
	$EnemyDetector/SwordHitbox.visible = false

func _process(_delta):
	#print(Engine.get_frames_per_second())
	pass

func _on_EnemyDetector_area_entered(_area: Area2D) -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)

func _on_EnemyDetector_body_entered(_body: Node) -> void:
	die()

func _on_diebox_area_entered(_area: Area2D) -> void:
	PlayerData.deaths += 1
	queue_free()

func _physics_process(_delta: float) -> void:
	if is_on_floor():
		playerstate = 0
		dashes_left = 1
	else: playerstate = 1
	if dashing == false and Input.is_action_just_pressed("dash") == true and dashes_left > 0:
		$"/root/Level/Player/Dtimer".start(0.2)
		dashing = true
		dashes_left = 0
	if dashing == true:
		playerstate = 2
#Playerstates: 0 = idle/floored, 1 = airborne, 2 = dashing, 3 = hitstun, 4 = tping
	match playerstate:
		0:
			movement()
		1:
			movement()
		2:
			dash_movement()
		3:
			pass
		4:
			pass
	attack()
	if attacking == false: moveanimation()
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

func dash_movement() -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	_velocity = calculate_dash_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	if hitstun == true:
		_velocity.y = -stomp_impulse
		hitstun = false
	x_speed = _velocity.x
	y_speed = _velocity.y

func moveanimation():
	if is_on_floor() and _velocity.x == 0.0:
		$Animation.play("idle")
		$Animation.set_offset (Vector2(-5,0))
	elif _velocity.x != 0.0 and is_on_floor():
		$Animation.play("walk")
	elif _velocity.y < 0.0 and not is_on_floor():
		$Animation.play("jump")
	elif _velocity.y > 0.0 and not is_on_floor():
		$Animation.play("fall")
	if _velocity.x < 0.0:
		flipped = 1
		$Animation.flip_h = false
		$Animation.set_offset (Vector2(-1,0))
	elif _velocity.x > 0.0:
		flipped = -1
		$Animation.flip_h = true
		$Animation.set_offset (Vector2(-6,0))


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)
	
func get_dash_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
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

func calculate_dash_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var out = linear_velocity
	out.x = speed.x * 2 * (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	out.y = speed.x * 2 * (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	return out

func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out: = linear_velocity
	out.y = -impulse
	return out

func die() -> void:
	attacking = false
	PlayerData.life -= 10
	PlayerData.hitstun += 1
	if PlayerData.life < 1:
		PlayerData.deaths += 1
		queue_free()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		attacking = true

func attack() -> void:
	if attacking == true :
		$Animation.play("attack")
		$EnemyDetector/SwordHitbox.disabled = false
		$EnemyDetector/SwordHitbox.visible = true
		if flipped == -1:
			$AnimationTimer.play("Hitbox")
		elif flipped == 1:
			$AnimationTimer.play("Flipped")

func attackend() -> void:
	$EnemyDetector/SwordHitbox.visible = false
	$EnemyDetector/SwordHitbox.disabled = true
	attacking = false

func _enemy_collided(_body: Node) -> void:
	die()

func _on_Dtimer_timeout():
	_velocity = Vector2(0,0)
	dashing = false
