extends RigidBody2D

var indicator
var seeing_player = false
var fov = deg_to_rad(60)

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

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)
	var colors = PackedColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = angle_from + i * (angle_to-angle_from) / nb_points - PI / 2
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	draw_polygon(points_arc, colors)

func _draw():
	var center = Vector2(0, 0)
	var radius = 200
	var angle_from = PI / 2 - fov / 2
	var angle_to = PI / 2 + fov / 2
	var color = Color(1.0, 1.0, 0.0)
	draw_circle_arc(center, radius, angle_from, angle_to, color)

func watchdogging():
	$RayCast2D.look_at(%Player.position)
	$RayCast2D.rotation = clamp($RayCast2D.rotation, -fov / 2, fov / 2)

	#print($RayCast2D.rotation - deg_to_rad(-fov / 2))
	var collider
	if $RayCast2D.is_colliding():
		collider = $RayCast2D.get_collider()
		if collider.name == "Player":
			var packed_indicator = load("res://scenes/dlabel.tscn")
			seeing_player = true

		else:
			$"%Player/Camera2D/dLabel".visible = false
			seeing_player = false

	else:
		$"%Player/Camera2D/dLabel".visible = false
