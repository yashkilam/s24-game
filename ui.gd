extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	reparent.call_deferred(%Player)
	global_position = %Player.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_rotation = 0
	if Global.current_mode == Game.Modes.TRANSFORMAL:
		if $Transformal.visible == false:
			$Transformal.visible = true
	else:
		if $Transformal.visible == true:
			$Transformal.visible = false
