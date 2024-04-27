extends CharacterBody2D

var MAX_SPEED = 124
var ACCELERATION = 640
var FRICTION = 400

enum {IDLE, RUN}
var state = IDLE

var facing
var original_frames = {}

func _ready():
	input_event.connect(_targeted)
	store_anims($AnimatedSprite2D.sprite_frames, original_frames)

func store_anims(sprite_frames, dictionary):
	for a in sprite_frames.get_animation_names():
		var texture_array = []
		for b in sprite_frames.get_frame_count(a):
			texture_array.append(sprite_frames.get_frame_texture(a, b))
		dictionary[a] = texture_array

func _physics_process(delta):
	sprint()
	move(delta)
	change_mode()
	animate()

func sprint():
	if Input.is_action_just_released("shift"):
		MAX_SPEED = 124
	if Input.is_action_pressed("shift"):
		MAX_SPEED = 212

func move(delta):
	#if Input.is_action_just_pressed("RMB"):
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	
	#var dir = Vector2.RIGHT.rotated(rotation)
	var movement_dir = Input.get_vector("a", "d", "w", "s")
	var direction_vector = mouse_pos - position
	var dir = movement_dir.rotated(direction_vector.angle() + PI / 2)

	if dir:
			state = RUN
			apply_movement(dir * ACCELERATION * delta)
	else:
		state = IDLE
		apply_friction(FRICTION * delta)
	move_and_slide()

func apply_friction(friction) -> void:
	if velocity.length() > friction:
		velocity -= velocity.normalized() * friction
	else:
		velocity = Vector2.ZERO

func apply_movement(acceleration) -> void:
	velocity += acceleration
	velocity = velocity.limit_length(MAX_SPEED)

func animate() -> void:
	if state == RUN:
		$AnimatedSprite2D.play("run")
	if state == IDLE:
		$AnimatedSprite2D.play("idle")

func change_mode():
	if Input.is_action_just_pressed("q"):
		if Global.current_mode == Game.Modes.NORMAL:
			Global.current_mode = Game.Modes.TRANSFORMAL
		else:
			Global.current_mode = Game.Modes.NORMAL

func _targeted(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if Global.current_mode == Game.Modes.TRANSFORMAL:
			reset_anims()

func import_anims(target):
	for i in target.get_animation_names():
		var count = target.get_frame_count(i)
		var frame2d
		$AnimatedSprite2D.sprite_frames.clear(i)
		for j in count:
			frame2d = target.get_frame_texture(i, j)
			$AnimatedSprite2D.sprite_frames.add_frame(i, frame2d, 1.0, j)

func reset_anims():
	$AnimatedSprite2D.sprite_frames.clear_all() 
	for key in original_frames:
		$AnimatedSprite2D.sprite_frames.add_animation(key)
		for frame in original_frames[key]:
			$AnimatedSprite2D.sprite_frames.add_frame(key, frame)
	Global.current_clone = null
