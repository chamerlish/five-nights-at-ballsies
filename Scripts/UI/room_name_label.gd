extends RichTextLabel

func _ready() -> void:
	Global.camera_changed.connect(func(new_cam): text = get_room_name_by_id(new_cam))

func get_room_name_by_id(id) -> String:
	if id > Global.Rooms.OFFICE:
		return Global.get_room_by_id(id).room_name
	
	return ""
