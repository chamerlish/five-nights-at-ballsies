extends VBoxContainer


		

@export var ai_value: int = 20

@onready var temp_label: RichTextLabel = $TempLabel

func _ready() -> void:
	hide()
	Global.temperature_changed.connect(func(new_temp: int): set_label_temp(new_temp))
	Global.camera_changed.connect(_on_cam_changed)
	
func _on_cam_changed(new_cam: Global.Rooms):
	if new_cam == Global.Rooms.FREEZER_ROOM:
		show()
	else:
		hide()
	


func set_label_temp(value: int):
	temp_label.text = "%s°C" % value


func _on_temp_delay_timeout() -> void:
	var chance = randi_range(1, 20)
	print(chance)
	if chance <= ai_value:
		Global.current_temperature += 5


func _input(event: InputEvent) -> void:
	if $DownTempButton.button_pressed:
		Global.current_temperature -= 1
