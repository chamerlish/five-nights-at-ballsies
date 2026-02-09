extends Node

signal camera_changed(new_cam)

var currect_cam: int:
	set(new_cam):
		currect_cam = new_cam
		camera_changed.emit(new_cam)
