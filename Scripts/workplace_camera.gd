extends Camera2D

@onready var minimap: Control = $Minimap
@export var background: TextureRect

func _ready() -> void:
	minimap.hide()
	background.hide()
	Global.camera_changed.connect(_on_camera_changed)

func _on_camera_changed(new_cam:int) -> void:
	if (new_cam >= 0):
		enabled = true
		minimap.show()
		background.show()
	else:
		enabled = false
		minimap.hide()
		background.hide()
