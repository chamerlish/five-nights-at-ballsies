@abstract
extends Sprite2D

class_name Animatronic

@export var sprite_room_index: Array[int] = []
@export var starting_room: int

var current_room: int

func _ready() -> void:
	hide()
	current_room = starting_room
	Global.camera_changed.connect(_on_camera_changed)

func _on_camera_changed(new_cam: int):
	if current_room == new_cam:
		show()
	else: hide()
