extends Node

signal camera_changed(new_cam)
signal animatronic_moved(old_room, new_room, id)

var _currect_cam: int = 0

enum Rooms {
	LEFT_DOOR = -3,
	RIGHT_DOOR = -2,
	BACKSTAGE = -1,
	OFFICE,
	RESTROOM,
	KITCHEN,
}

var currect_cam: int:
	get:
		return _currect_cam
	set(new_cam):
		if _currect_cam == new_cam:
			return 
		print("Changed camera from %d to %d" % [_currect_cam, new_cam])
		_currect_cam = new_cam
		emit_signal("camera_changed", new_cam)
