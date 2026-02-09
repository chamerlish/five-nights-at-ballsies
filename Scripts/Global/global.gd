extends Node

signal camera_changed(new_cam)

var _currect_cam: int = 0

var currect_cam: int:
	get:
		return _currect_cam
	set(new_cam):
		if _currect_cam == new_cam:
			return 
		print("Changed camera from %d to %d" % [_currect_cam, new_cam])
		_currect_cam = new_cam
		emit_signal("camera_changed", new_cam)
