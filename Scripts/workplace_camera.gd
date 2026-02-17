extends Camera2D

@onready var hud: CanvasLayer = $HUD
@export var background: TextureRect
@onready var lure_button: TextureButton = $HUD/Minimap/LureButton

func _ready() -> void:
	hud.hide()
	background.hide()
	Global.camera_changed.connect(_on_camera_changed)

func _on_camera_changed(new_cam) -> void:
	if (new_cam > Global.Rooms.OFFICE):
		enabled = true
		hud.show()
		background.show()
	else:
		enabled = false
		hud.hide()
		background.hide()
	
	if new_cam == Global.Rooms.FREEZER_ROOM:
		lure_button.hide()
	else:
		lure_button.show()
	


func _on_lure_button_pressed() -> void:
	Global.audio_lure_played.emit(Global.currect_cam)
