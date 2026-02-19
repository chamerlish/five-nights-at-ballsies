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

var warning_mode: bool = false:
	set(value):
		warning_mode = value
		if value:
			_start_warning()
		else:
			_end_warning()

var collision_vertecies: PackedVector2Array = []
var mouse_inside: bool = false

func _ready() -> void:
	current_color = NONE_PRESSED_COLOR
	collision_vertecies = $CollisionPolygon2D.polygon.duplicate()
	$CamLabel.set_text("Cam%s" % str(cam_id).pad_zeros(2))
	Global.camera_changed.connect(_on_camera_changed)
	mouse_entered.connect(func(): mouse_inside = true)
	mouse_exited.connect(func(): mouse_inside = false)
	queue_redraw()

func _start_warning():
	if warning_tween:
		warning_tween.kill()
	warning_tween = get_tree().create_tween().set_loops()
	
	warning_tween.tween_property(self, "current_color", Color.RED, 1.0)
	warning_tween.tween_property(self, "current_color", Color.WHITE, 1.0)
	warning_tween.tween_callback(queue_redraw)

func _end_warning():
	if warning_tween:
		warning_tween.kill()
		warning_tween = null
	current_color = PRESSED_COLOR if cam_id == Global.currect_cam else NONE_PRESSED_COLOR
	queue_redraw()

func _on_camera_changed(new_cam: int) -> void:
	queue_redraw()

func _draw():
	if not warning_mode:
		current_color = PRESSED_COLOR if cam_id == Global.currect_cam else NONE_PRESSED_COLOR
	draw_polygon(collision_vertecies, [current_color])

func _process(_delta: float) -> void:
	if warning_mode:
		queue_redraw()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if mouse_inside:
			Global.currect_cam = cam_id
	if event.is_action_pressed("ui_accept"):
		warning_mode = true
