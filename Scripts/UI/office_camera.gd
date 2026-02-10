extends CharacterBody2D

# Movement settings
@export var move_speed: float = 600.0  # How fast the camera moves
@export var mouse_sensitivity: float = 1.5

@onready var pov_cam: Camera2D = $Camera2D

var screen_size: Vector2

func _ready():
	screen_size = get_viewport_rect().size
	Global.camera_changed.connect(_on_camera_changed)

func _on_camera_changed(new_cam:int) -> void:
	if (new_cam >= 0):
		pov_cam.enabled = false
	else:
		pov_cam.enabled = true
		

func _physics_process(delta):
	var mouse_pos = get_viewport().get_mouse_position()

	var mouse_offset = (mouse_pos.x - screen_size.x / 2) / (screen_size.x / 2)
	mouse_offset = clamp(mouse_offset * mouse_sensitivity, -1.0, 1.0)
	
	if !is_on_wall() or mouse_offset * position.x < 0:
		velocity.x = mouse_offset * move_speed
	
	move_and_slide()
	
