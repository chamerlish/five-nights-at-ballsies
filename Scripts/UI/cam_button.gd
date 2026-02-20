extends Area2D
@export var cam_id: Global.Rooms
@export var direction: Direction
enum Direction {
	DOWN_LEFT,
	UP_LEFT,
	CENTER
}
const PRESSED_COLOR: Color = Color(1, 1, 1, 0.5)
const NONE_PRESSED_COLOR: Color = Color(1, 1, 1, 0.25)
var current_color: Color
var warning_tween: Tween = null

var collision_vertecies: PackedVector2Array = []
var mouse_inside: bool = false

func _ready() -> void:
	current_color = NONE_PRESSED_COLOR
	collision_vertecies = $CollisionPolygon2D.polygon.duplicate()
	$CamLabel.set_text("Cam%s" % str(cam_id).pad_zeros(2))
	Global.camera_changed.connect(_on_camera_changed)
	Global.temperature_changed.connect(_on_temperature_changed)
	Global.audio_lure_played.connect(_on_audio_played)
	
	mouse_entered.connect(func(): mouse_inside = true)
	mouse_exited.connect(func(): mouse_inside = false)
	queue_redraw()

func _start_warning():
	if warning_tween:
		warning_tween.kill()
	warning_tween = get_tree().create_tween()
	
	warning_tween.tween_method(_set_warning_color.bind(Color.RED, Color.WHITE), 0.0, 1.0, 1.0)
	warning_tween.tween_callback(func(): _end_warning())

func _set_warning_color(t: float, from: Color, to: Color) -> void:
	var lerped = from.lerp(to, t)
	current_color = Color(lerped.r, lerped.g, lerped.b, current_color.a)
	queue_redraw()

func _end_warning():
	if warning_tween:
		warning_tween.kill()
		warning_tween = null
	current_color = PRESSED_COLOR if cam_id == Global.currect_cam else NONE_PRESSED_COLOR
	queue_redraw()

func _on_camera_changed(new_cam: Global.Rooms) -> void:
	current_color = PRESSED_COLOR if cam_id == new_cam else NONE_PRESSED_COLOR
	queue_redraw()
	

func _on_temperature_changed(new_temp: int) -> void:
	pass
	print(new_temp)

func _on_audio_played(played_position: Global.Rooms):
	if cam_id == played_position:
		_start_warning()

func _draw():
	draw_polygon(collision_vertecies, [current_color])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if mouse_inside:
			Global.currect_cam = cam_id
			
