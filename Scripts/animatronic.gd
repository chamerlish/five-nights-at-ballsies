extends Sprite2D

class_name Animatronic

@export var starting_room: Global.Rooms

var current_room: Global.Rooms

@export var ai_difficulty: int
@export var mov_opp_delay: int = 3

@export var path_order: Array[Global.Rooms]
@export var phase_order: Array[int]

@export var is_free_roam: bool
@export var allowed_rooms: Array[Global.Rooms]

@export var id: int

@onready var movement_opportunity_timer: Timer = Timer.new()


func _ready() -> void:
	
	current_room = starting_room
	update_sprite(Global.currect_cam)
	
	add_child(movement_opportunity_timer)
	movement_opportunity_timer.wait_time = mov_opp_delay
	movement_opportunity_timer.start()
	
	Global.camera_changed.connect(_on_camera_changed)
	Global.animatronic_moved.connect(_on_animatronic_moved)
	movement_opportunity_timer.timeout.connect(_on_try_movement)

func _on_camera_changed(new_cam: int):
	update_sprite(new_cam)

func _on_try_movement():
	if is_free_roam:
		free_roam_move()
	else:
		move_forward_path()

var is_in_office: bool
var is_in_right_door: bool
var is_in_left_door: bool

func _on_animatronic_moved(_old_room, _new_room, id):
	if id == self.id:
		is_in_office = _new_room == Global.Rooms.OFFICE
		is_in_right_door = _new_room == Global.Rooms.RIGHT_DOOR
		is_in_left_door = _new_room == Global.Rooms.LEFT_DOOR

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
			
		Global.animatronic_moved.emit(current_room, path_order[path_pos], id)
		current_room = path_order[path_pos]

	update_sprite(Global.currect_cam)

func finish_path():
	pass

func free_roam_move() -> void:
	
	update_sprite(Global.currect_cam)

func pick_random_room() -> int:
	var rooms_copy = allowed_rooms.duplicate()
	rooms_copy.shuffle()
	return rooms_copy[0]

func update_sprite(camera_index: int) -> void:
	if current_room == camera_index:
		show()
	else: hide()
