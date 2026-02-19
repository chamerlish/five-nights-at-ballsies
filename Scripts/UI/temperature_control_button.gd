extends VBoxContainer

var current_temperature: int:
	set(value):
		current_temperature = max(MIN_TEMP, value)
		set_label_temp(current_temperature)

@export var ai_value: int = 20
const MIN_TEMP: int = -28
@onready var temp_label: RichTextLabel = $TempLabel

func _ready() -> void:
	hide()
	current_temperature = MIN_TEMP
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
		current_temperature += 5


func _process(delta: float) -> void:
	if $DownTempButton.button_pressed:
		current_temperature -= 1
