extends Area2D


var is_openned: bool


var last_opened_cam: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_exited.connect(open_close)

func open_close():
	is_openned = not is_openned
	if not is_openned:
		last_opened_cam = Global.currect_cam
		Global.currect_cam = -1
	else:
		Global.currect_cam = last_opened_cam
	
func _input(event: InputEvent) -> void:
	
	var max_distance := 300.0
	var dist := global_position.distance_to(get_global_mouse_position())

	var alpha :float= 1.0 - clamp(dist / max_distance, 0.0, 1.0)

	$Texture.modulate.a = max(alpha, 0.1)
