extends TextureButton

@export var cam_id: Global.Rooms
@export var direction: Direction
enum Direction {
	DOWN_LEFT,
	UP_LEFT,
	CENTER
}

func _ready() -> void:
	texture_normal = texture_normal.duplicate()  
	$CamLabel.set_text("Cam%s" % str(cam_id).pad_zeros(2))
	Global.camera_changed.connect(_on_camera_changed)
	
func _on_camera_changed(new_cam: int) -> void:
	texture_normal.region = Rect2(int(cam_id == new_cam) * 33, 31 * direction, 33, 31)

func _on_pressed() -> void:
	Global.currect_cam = cam_id
