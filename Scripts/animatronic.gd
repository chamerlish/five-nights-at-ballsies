extends Sprite2D

class_name Animatronic

@export var starting_room: int

var current_room: int

@export var ai_difficulty: int
@export var mov_opp_delay: int = 3

@export var path_order: Array[int]
@export var phase_order: Array[int]

@export var is_free_roam: bool


@onready var movement_opportunity_timer: Timer = $MoveOpportunityTimer


func _ready() -> void:
	update_sprite(Global.currect_cam)
	movement_opportunity_timer.wait_time = mov_opp_delay
	hide()
	current_room = starting_room
	Global.camera_changed.connect(_on_camera_changed)
	movement_opportunity_timer.timeout.connect(_on_try_movement)

func _on_camera_changed(new_cam: int):
	update_sprite(new_cam)

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
	if path_pos > path_order.size() - 1: return
	var max_phase = phase_order[path_pos]
	
	
	#print(max_phase)
	
	print("Phase: %s Current room: %s" % [phase, current_room])
	
	if phase < max_phase - 1: # advance phase
		phase += 1
		#print(phase)
	else: # move to the next room
		phase = 0
		path_pos += 1
		if path_pos > path_order.size() - 1:
			finish_path()
			return
		
		current_room = path_order[path_pos]

	update_sprite(Global.currect_cam)

func finish_path():
	pass

func free_roam_move() -> void:
	update_sprite(Global.currect_cam)

func update_sprite(camera_index: int) -> void:
	if current_room == camera_index:
		show()
	else: hide()
