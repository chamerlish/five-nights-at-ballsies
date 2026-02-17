extends Area2D

@export var cam_id: Global.Rooms
@export var direction: Direction
enum Direction {
	DOWN_LEFT,
	UP_LEFT,
	CENTER
}


var collision_vertecies: PackedVector2Array = []


var mouse_inside: bool = false

func _ready() -> void:
	queue_redraw()
	collision_vertecies = $CollisionPolygon2D.polygon.duplicate()
	#texture_normal = texture_normal.duplicate()  
	$CamLabel.set_text("Cam%s" % str(cam_id).pad_zeros(2))
	Global.camera_changed.connect(_on_camera_changed)
	mouse_entered.connect(func(): mouse_inside = true)
	mouse_exited.connect(func(): mouse_inside = false)
	
func _on_camera_changed(new_cam: int) -> void:
	
	queue_redraw()
	#texture_normal.region = Rect2(int(cam_id == new_cam) * 33, 31 * direction, 33, 31)
	pass
	
func _draw():
	if cam_id == Global.currect_cam:
		if collision_vertecies.size() >= 3:
			draw_polygon(collision_vertecies, [Color(1, 1, 1, 0.5)])
	else: 
		draw_polygon(collision_vertecies, [Color(1, 1, 1, 0.25)])
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if mouse_inside:
			Global.currect_cam = cam_id
