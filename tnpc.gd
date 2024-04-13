extends RigidBody2D

var indicator

# Called when the node enters the scene tree for the first time.
func _ready():
	input_event.connect(_targeted)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	update_clone_status()
	watchdogging()

func update_clone_status():
	if indicator:
		if Global.current_clone != self:
			if is_instance_valid(indicator):
				indicator.queue_free()

func _targeted(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if Global.current_mode == Game.Modes.TRANSFORMAL:
			get_node("%Player").import_anims($AnimatedSprite2D.sprite_frames)
			indicate()

func indicate():
	if Global.current_clone != self:
		var packed_indicator = load("res://scenes/clone_indicator.tscn")
		indicator = packed_indicator.instantiate()
		self.add_child(indicator)
		indicator.position = Vector2(65, 0)
		indicator.rotation = PI/2
		indicator.play("default")
		Global.current_clone = self

func watchdogging():
	$RayCast2D.look_at(%Player.position)
	$RayCast2D.rotation = clamp($RayCast2D.rotation,deg_to_rad(-90), deg_to_rad(90))
	var collider
	if $RayCast2D.is_colliding():
		collider = $RayCast2D.get_collider()
		if collider.name == "Player":
			$"%Player/Camera2D/Label".visible = true
		else:
			$"%Player/Camera2D/Label".visible = false
	else:
		$"%Player/Camera2D/Label".visible = false
