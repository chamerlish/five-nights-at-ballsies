extends Sprite2D

class_name Animatronic

@export var starting_room: Global.Rooms

var current_room: Global.Rooms:
	set(new_room):
		
		Global.animatronic_moved.emit(current_room, new_room, id)
		current_room = new_room
		update_sprite(Global.currect_cam)

@export var ai_difficulty: int
@export var mov_opp_delay: int = 3

@export var path_order: Array[Global.Rooms]
@export var phase_order: Array[int]
@export var delay_order: Array[int]

@export var is_free_roam: bool
@export var allowed_rooms: Array[Global.Rooms]

@export var id: int

@onready var movement_opportunity_timer: Timer = Timer.new()

var target_room: Global.Rooms

var current_room_animatronic: Array[Animatronic]
var next_room_animatronic: Array[Animatronic]

func _init() -> void:
	Global.animatronic_list.insert(id, self)

func _ready() -> void:
	current_room = starting_room
	
	movement_opportunity_timer.autostart = false
	add_child(movement_opportunity_timer)
	
	if is_free_roam:
		reset_timer(mov_opp_delay)
	else: reset_timer(delay_order[0])
	
	Global.camera_changed.connect(_on_camera_changed)
	Global.animatronic_moved.connect(_on_animatronic_moved)
	movement_opportunity_timer.timeout.connect(_on_try_movement)

func reset_timer(wait_time: int) -> void:
	movement_opportunity_timer.wait_time = wait_time
	movement_opportunity_timer.start()

func _on_camera_changed(new_cam: int) -> void:
	update_sprite(new_cam)

var target_locked: bool = false

func _on_try_movement():
	if is_free_roam:
		
		if target_locked == false:
			target_room = pick_random_room()
			target_locked = true
		
		free_roam_move_forward(target_room)
	else:
		move_forward_path()

var is_in_office: bool
var is_in_right_door: bool
var is_in_left_door: bool

@warning_ignore("shadowed_variable")
func _on_animatronic_moved(_old_room, _new_room, id):
	# Only update next_room_animatronic if THIS animatronic moved
	if id == self.id:
		var next_room: Global.Rooms = _new_room
		if is_free_roam:
			next_room = _new_room
		else: 
			if path_pos + 1 < path_order.size():
				next_room = path_order[path_pos + 1]
			else: next_room_animatronic = []
		
		current_room_animatronic = Global.get_animatronic_by_room(_new_room)
		next_room_animatronic = Global.get_animatronic_by_room(next_room)
		
		is_in_office = _new_room == Global.Rooms.OFFICE
		is_in_right_door = _new_room == Global.Rooms.RIGHT_DOOR
		is_in_left_door = _new_room == Global.Rooms.LEFT_DOOR

var phase: int = 0
var path_pos: int = 0

func move_forward_path() -> void:
	if path_pos > path_order.size() - 1: return
	var max_phase = phase_order[path_pos]
	
	
	#print(max_phase)
	
	#print("Phase: %s Current room: %s" % [phase, current_room])
	
	if phase < max_phase - 1: # advance phase
		phase += 1
		
	else: # move to the next room
		phase = 0
		path_pos += 1
		
		
		
		if path_pos > path_order.size() - 1:
			finish_path()
			return
		reset_timer(delay_order[path_pos])
		print(movement_opportunity_timer.wait_time)
		current_room = path_order[path_pos]


func finish_path():
	pass

func can_move() -> bool:
	return true 
	# by default no condition is needed for an animatronic to be able to move if he wins a movement opportunity

func free_roam_move_forward(target: Global.Rooms) -> void:
	var path = get_free_roam_path(current_room, target)

	if path.size() <= 1:
		target_locked = false
		finish_path()
		return

	var next_room: Global.Rooms = path[1] # index 0 is current room
	if can_move():
		current_room = next_room

func get_free_roam_path(start: Global.Rooms, target: Global.Rooms) -> Array[Global.Rooms]:
	if start == target:
		return [start]

	var queue: Array[Global.Rooms] = []
	var came_from := {}

	queue.append(start)
	came_from[start] = null 

	while queue.size() > 0:
		var current: Global.Rooms = queue.pop_front()

		if current == target:
			break

		var room_data: RoomData = null
		for room in Global.rooms_data:
			if room.room_id == current:
				room_data = room
				break

		if room_data == null:
			continue

		for neighbor: Global.Rooms in room_data.adjacent_roome:
			if not came_from.has(neighbor):
				queue.append(neighbor)
				came_from[neighbor] = current

	# If no path
	if not came_from.has(target):
		return []

	# Reconstruct path
	var path: Array[Global.Rooms] = []
	var step: Global.Rooms = target

	while step != start:
		path.insert(0, step)
		step = came_from[step]

	path.insert(0, start)
	return path

func pick_random_room() -> Global.Rooms:
	var rooms_copy = allowed_rooms.duplicate()
	rooms_copy.shuffle()
	return rooms_copy[0]

func update_sprite(camera_index: Global.Rooms) -> void:
	if current_room == camera_index:
		show()
	else: hide()
