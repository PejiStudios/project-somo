extends Actor

export var stomp_impulse = 1000.0
var attacking = false
var flipped = false
var hitted = false
var dashing = false
var just_attacking = false

func _ready() -> void:
	PlayerData.teleporting = false
	$EnemyDetector/SwordHitbox.disabled = true
	$EnemyDetector/SwordHitbox.visible = false

func _process(delta):
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
	if is_on_floor(): PlayerData.floored = true
	else: PlayerData.floored = false
	if PlayerData.teleporting == false: movement()
	attack()
	if attacking == false: moveanimation()

func movement() -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	if hitted == true:
		_velocity.y = -stomp_impulse
		hitted = false

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
	if _velocity.x > 0.0:
		flipped = true
		$Animation.flip_h = true
		$Animation.set_offset (Vector2(-1,0))
	elif _velocity.x < 0.0:
		flipped = false
		$Animation.flip_h = false
		$Animation.set_offset (Vector2(-6,0))


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
	if event.is_action_pressed("dash"):
		dashing = true

func attack() -> void:
	if attacking == true :
		$Animation.play("attack")
		$EnemyDetector/SwordHitbox.disabled = false
		$EnemyDetector/SwordHitbox.visible = true
		if flipped == false:
			$AnimationTimer.play("Hitbox")
		elif flipped == true:
			$AnimationTimer.play("Flipped")

func dash() -> void:
	if dashing == true:
		return
		

func attackend() -> void:
	$EnemyDetector/SwordHitbox.visible = false
	$EnemyDetector/SwordHitbox.disabled = true
	attacking = false

func _enemy_collided(_body: Node) -> void:
	die()
