extends Sprite2D

class_name Animatronic

@export var starting_room: int

var current_room: int

@export var ai_difficulty: int
@export var mov_opp_delay: int = 3

@export var path_phase_index: Dictionary[int, int] = {} # Cam, AmiuntOfPhases
@export var path_order: Array[int]

@export var is_free_roam: bool


@onready var movement_opportunity_timer: Timer = $MoveOpportunityTimer


func _ready() -> void:
	movement_opportunity_timer.wait_time = mov_opp_delay
	hide()
	current_room = starting_room
	Global.camera_changed.connect(_on_camera_changed)
	movement_opportunity_timer.timeout.connect(_on_try_movement)

func _on_camera_changed(new_cam: int):
	if current_room == new_cam:
		show()
	else: hide()

func _on_try_movement():
	if is_free_roam:
		free_roam_move()
	else:
		move_forward_path()

func is_in_office():
	print("booua")

var phase: int = 0
var path_pos: int = 0

func move_forward_path() -> void:
	var max_phase = path_phase_index.get(current_room, 1)
	
	print("Phase:", phase, "Current room:", current_room)
	
	if phase < max_phase - 1:
		phase += 1
	else:
		phase = 0
		path_pos += 1
		if path_pos >= path_order.size():
			is_in_office()
			return
		current_room = path_order[path_pos]

	update_sprite()

func free_roam_move() -> void:
	update_sprite()

func update_sprite() -> void:
	pass
