extends TextureRect

const TEXTURE_SIZE := Vector2(1600, 7950)
const NUMBER_OF_ROOMS = 11
const BACKGROUND_SIZE = Vector2(TEXTURE_SIZE.x, TEXTURE_SIZE.y / NUMBER_OF_ROOMS)

func _ready() -> void:
	Global.camera_changed.connect(_on_camera_changed)
	
func _on_camera_changed(new_cam):
	texture.region = Rect2(0, new_cam * BACKGROUND_SIZE.y, BACKGROUND_SIZE.x, BACKGROUND_SIZE.y)
