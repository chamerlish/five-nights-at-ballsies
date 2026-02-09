extends Camera2D

var is_openned: bool
var last_opened_cam: int

@onready var open_close_area: Area2D = $OpenCloseArea
@onready var minimap: Control = $Minimap

func _ready() -> void:
	minimap.hide()
	# open_close_area.mouse_entered.connect(open_close)
	open_close_area.mouse_exited.connect(open_close)

func open_close():
	is_openned = not is_openned
	if not is_openned:
		last_opened_cam = Global.currect_cam
		Global.currect_cam = -1
		minimap.hide()
	else:
		Global.currect_cam = last_opened_cam
		minimap.show()
	
	
