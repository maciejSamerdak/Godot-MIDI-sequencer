extends TileMap


const rows = 88
const cols = 1024
var width
var height
var bar_interval = 8
onready var note_scene = preload("res://Note.tscn")
onready var selection_box = preload('res://SelectionBox.tscn').instance()

var note_mapping = {}
var instrument = 0
var tempo = 120
var pan = 64
var volume = 100
var file_name

var active_notes = []
var velocity = 80
var drag
var move = Vector2(0, 0)
const camera_speed = 8
var is_manually_dragging = false
var selection_mode = false
var selection_start = Vector2(0, 0)

onready var SMF = preload('res://addons/midi/SMF.gd')
var sound_on_creation = false

signal time_sig_changed

func _ready():
	height = rows * cell_size.y + 0.33 * get_viewport_rect().size.y
	width = cols * cell_size.x
	$Camera2D.limit_bottom = height
	$Camera2D.limit_right = width
	$Camera2D.position.y = 34 * cell_size.y	
	add_child(selection_box)
	file_name = generate_file_name()
	
#	for i in range(7):
#		create_new_note(Vector2(1 + i, 12 - i))
#	for i in range(7):
#		create_new_note(Vector2(9 + i, 12 - i))
#	active_notes.clear()
#	navigate_to_next_measure()
	


func crescendo(beginning: int, end: int) -> void:
	active_notes = order_by_time(active_notes)
	var step = ((end - beginning)/active_notes.size() - 1)
	for i in range(active_notes.size()):
		active_notes[i].set_velocity(beginning + step * i)

func order_by_time(array):
	pass

func save_project(file_name: String) -> void:
	var save_file = File.new()
	save_file.open("user://%s" % file_name, File.WRITE)
	save_file.store_line(to_json(serialize()))
	save_file.close()

func load_project(file_name: String) -> void:
	var save_file = File.new()
	if not save_file.file_exists("user://%s" % file_name):
		return # Error! File does not exist!
	save_file.open("user://%s" % file_name, File.READ)
	var sequence_data = parse_json(save_file.get_line())
	instrument = int(sequence_data['instrument'])
	tempo = int(sequence_data['tempo'])
	pan = int(sequence_data['pan'])
	volume = int(sequence_data['volume'])
	bar_interval = int(sequence_data['bar_interval'])
	for note in note_mapping.values():
		remove_child(note)
	note_mapping.clear()
	for note_data in sequence_data['notes']:
		var new_note = note_scene.instance()
		new_note.set_velocity(int(note_data['velocity']))
		add_child(new_note)
		var pos = Vector2(note_data['pos'][0], note_data['pos'][1])
		var size = Vector2(note_data['size'][0], note_data['size'][1])
		new_note.setup(pos, size)
		note_mapping[pos] = new_note
	save_file.close()
	
func export_project(file_path: String) -> void:
	var smf_data = generate_sequence(0)
	var export_file = File.new()
	export_file.open(file_path, File.WRITE)
	export_file.store_buffer(SMF.write(smf_data))
	export_file.close()

func _process(delta):
	if drag:
		if !selection_mode:
			stretch_note()
	move *= delta * 60
	drag_camera(move)


func _input(event):
	if event is InputEventScreenTouch:
		if is_position_in_range(event.position):
			if event.is_pressed():
				if event.position.x >= get_viewport_rect().size.x * $Camera2D.drag_margin_right:
					is_manually_dragging = true
				else:
					var cell_position = world_to_map(calculate_postion(event.position))
					if !selection_mode:
						create_or_delete_note(cell_position)
					else:
						selection_start = calculate_postion(event.position)
						select_or_deselect_note(cell_position)
			else:
				reset_on_touch_release()
			
	if event is InputEventScreenDrag:
		if is_position_in_range(event.position):
			drag = {'position': calculate_postion(event.position), 'relative': event.relative}
			if is_manually_dragging:
				drag_camera(-drag['relative'])
			else:
				check_for_camera_drag(event.position)
				if selection_mode:
					stretch_selection_box()
		else:
			move = Vector2(0, 0)
			drag = null


func create_or_delete_note(cell_position):
	if is_cell_in_range(cell_position):
		var existing_note = get_note_at_cell(cell_position)
		if !existing_note:
			create_new_note(cell_position)
		else:
			if existing_note in active_notes:
				for note in active_notes:
					delete_note(note)		
			else:
				delete_note(existing_note)
			#clear_note_selection()


func create_new_note(cell_position):
	clear_note_selection()
	var new_note = note_scene.instance()
	new_note.set_velocity(velocity)
	add_child(new_note)
	new_note.setup(map_to_world(cell_position), cell_size)
	Thread.new().start(self, 'sound_note', new_note)
	note_mapping[map_to_world(cell_position)] = new_note
	active_notes.append(new_note)


func sound_note(note):
	if sound_on_creation:
		$MidiPlayer.stop()
		var events = [{
			"time": 0,
			"channel_number": 0,
			"event": {
				"type": SMF.MIDIEventType.program_change,
				"number": instrument,
			}
		},
		{
			"time": 48,
			"channel_number": 0,
			"event": {
				"type": SMF.MIDIEventType.note_on,
				"note": note.get_pitch(),
				"velocity": note.velocity,
			}
		},
		{
			"time": 96,
			"channel_number": 0,
			"event": {
				"type": SMF.MIDIEventType.note_off,
				"note": note.get_pitch(),
				"velocity": 0,
			}
		}]
		var data = {
			"format_type": 0,   # SMF format 0
			"track_count": 1,   # always 1 in format 0.
			"timebase": 48,
			"tracks": [{
				"track_number": 0,
				"events": events
			}],
    	}
		$MidiPlayer.smf_data = data
		$MidiPlayer.play( )


func delete_note(note):
	remove_child(note)
	note_mapping.erase(note.pos)


func stretch_note():
	for note in active_notes:
		var cell_position = world_to_map(drag['position'])
		if is_cell_in_range(cell_position):
			var pitch_changed = false
			var new_pos = world_to_map(note.pos)
			var new_size = world_to_map(note.size)
			note_mapping.erase(note.pos)
			if cell_position.y != new_pos.y:
				new_pos.y = cell_position.y
				pitch_changed = true
			if new_pos.x < cell_position.x:
				new_size.x =  cell_position.x - new_pos.x
			note.setup(map_to_world(new_pos), map_to_world(new_size))
			note_mapping[map_to_world(new_pos)] = note
			if pitch_changed:
				sound_note(note)


func stretch_selection_box():
	selection_box.setup(selection_start, drag['position'])
	for note in note_mapping.values():
		if selection_box.intersects(note.as_rect()):
			highlight_note(note)
		else:
			highlight_note(note, false)


func select_or_deselect_note(cell_position):
	if is_cell_in_range(cell_position):
		var existing_note = get_note_at_cell(cell_position)
		if !existing_note:
			clear_note_selection()
		else:
			var enable = true
			if existing_note in active_notes:
				enable = false
			highlight_note(existing_note, enable)


func highlight_note(note, enable=true):
	note.highlight(enable)
	if enable:
		if not note in active_notes:
			active_notes.append(note)
	elif note in active_notes:
		active_notes.erase(note)


func clear_note_selection():
	for note in active_notes:
		note.highlight(false)
	active_notes.clear()


func reset_on_touch_release():
	if !selection_mode:
		clear_note_selection()
	else:
		selection_box.reset_selection()
	drag = null
	move = Vector2(0, 0)
	is_manually_dragging = false


func get_note_at_cell(cell_position):
	if note_mapping.has(map_to_world(cell_position)):
		return note_mapping[map_to_world(cell_position)]
	else:
		for key in note_mapping.keys():
			if key.y == map_to_world(cell_position).y:
				if key.x <= map_to_world(cell_position).x:
					var note = note_mapping[key]
					var note_length = world_to_map(note.size).x
					if world_to_map(key).x + note_length - 1 >= cell_position.x:
						return note
	return null


func is_cell_in_range(cell_position):
	return cell_position.y < rows and cell_position.y >= 0 and cell_position.x < cols and cell_position.x >= 0


func is_position_in_range(pos):
	var size = get_viewport_rect().size
	return Rect2(Vector2(0, 0), size).has_point(pos)


func check_for_camera_drag(pos):
	var viewport_dimensions = get_viewport_rect()
	if pos.x > viewport_dimensions.size.x * $Camera2D.drag_margin_right:
		move.x = camera_speed
	elif pos.x < viewport_dimensions.size.x * (1.0 - $Camera2D.drag_margin_left):
		move.x = -camera_speed
	else:
		move.x = 0
	if pos.y > viewport_dimensions.size.y * $Camera2D.drag_margin_bottom:
		move.y = camera_speed
	elif pos.y < viewport_dimensions.size.y * (1.0 - $Camera2D.drag_margin_top):
		move.y = -camera_speed
	else:
		move.y = 0


func calculate_postion(pos):
	return $Camera2D.position + pos

	
func drag_camera(vector):
	$Camera2D.position += vector
	reset_camera_position_on_collision()


func reset_camera_position_on_collision():
	if $Camera2D.position.y + get_viewport_rect().size.y > $Camera2D.limit_bottom:
		move.y = 0
		$Camera2D.position.y = $Camera2D.limit_bottom - get_viewport_rect().size.y
	elif $Camera2D.position.y < $Camera2D.limit_top:
		move.y = 0
		$Camera2D.position.y = $Camera2D.limit_top
	if $Camera2D.position.x + get_viewport_rect().size.x > $Camera2D.limit_right:
		move.x = 0
		$Camera2D.position.x = $Camera2D.limit_right - get_viewport_rect().size.x
	elif $Camera2D.position.x < $Camera2D.limit_left:
		move.x = 0
		$Camera2D.position.x = $Camera2D.limit_left


func navigate_to_next_measure():
	var measure_length = bar_interval * cell_size.x
	var current_bar = int($Camera2D.position.x/measure_length)
	if current_bar < cols/bar_interval:
		var next_bar = (current_bar + 1) * measure_length
		$Camera2D.position.x = next_bar


func navigate_to_previous_measure():
	var measure_length = bar_interval * cell_size.x
	var current_bar = int($Camera2D.position.x/measure_length)
	if int($Camera2D.position.x) % int(measure_length) == 0:
		if current_bar > 0:
			var previous_bar = (current_bar - 1) * measure_length
			$Camera2D.position.x = previous_bar
	else:
		$Camera2D.position.x = current_bar * measure_length


func navigate_to_beginning():
	$Camera2D.position.x = 0


func toggle_selection_mode(button_pressed):
	selection_mode = button_pressed


func change_velocity(value):
	velocity = int(value) - 1
	
	
func generate_sequence(track_position: float) -> Dictionary:
	var track_events = {}
	for note in note_mapping.values():
		if note.get_note_on(track_position) >= 0:
			var note_on = note.get_note_on(track_position)
			var note_off = note.get_note_off(track_position)
			if !track_events.has(note_on):
				track_events[note_on] = []
			if !track_events.has(note_off):
				track_events[note_off] = []
			track_events[note_on].append(
				{
					'pitch': note.get_pitch(), 
					'velocity': note.velocity, 
					'note_on': true
				}
			)
			track_events[note_off].append(
				{
					'pitch': note.get_pitch(), 
					'velocity': 0, 
					'note_on': false
				}
			)
	var sorted_event_positions = track_events.keys()
	sorted_event_positions.sort()
	var player_events = [
		{
			"time": 0,
			"channel_number": 0,
			"event": {
				"type": SMF.MIDIEventType.program_change,
				"number": instrument,
			}
		},
		{
			"time": 0,
			"channel_number": 0,
			"event": {
				"type": SMF.MIDIEventType.control_change,
				"number": 7,
				"value": volume,
			}
		},
		{
			"time": 0,
			"channel_number": 0,
			"event": {
				"type": SMF.MIDIEventType.control_change,
				"number": 10,
				"value": pan,
			}
		}
	]
	var end_position = 0
	for pos in sorted_event_positions:
		var position_events = track_events[pos]
		for event in position_events:
			var event_type = SMF.MIDIEventType.note_off
			if event['note_on']:
				event_type = SMF.MIDIEventType.note_on
			player_events.append({
				"time": pos,
				"channel_number": 0,
				"event": {
					"type": event_type,
					"note": event['pitch'],
					"velocity": event['velocity'],
				}
			})
		end_position = pos
	player_events.append({
		"time": end_position,
		"channel_number": 0,
		"event": {
			"type": SMF.MIDIEventType.system_event,
			"args": {
				"type": SMF.MIDISystemEventType.end_of_track
			}
		}
	})
	var sequence = {
			"format_type": 0,   # SMF format 0
			"track_count": 1,   # always 1 in format 0.
			"timebase": 48,
			"tracks": [{
				"track_number": 0,
				"events": player_events
			}],
    	}
	return sequence


func play(button_pressed):
	if button_pressed:
		var sequence = generate_sequence(int($Camera2D.position.x))
		$MidiPlayer.smf_data = sequence
		$MidiPlayer.tempo = tempo
		$MidiPlayer.play()
	else:
		$MidiPlayer.stop()
		
func serialize() -> Dictionary:
	var serialized_notes = []
	for note in note_mapping.values():
		serialized_notes.append(note.serialize())
	var data = {
		"bar_interval": bar_interval,
		"tempo": tempo,
		"pan": pan,
		"volume": volume,
		"notes": serialized_notes,
		"instrument": instrument
	}
	return data

func change_track_settings(instrument, tempo, time_sig):
	self.instrument = instrument
	self.tempo = tempo
	bar_interval = int(time_sig) * 2
	$GridDrawer.update()
	emit_signal("time_sig_changed")


func generate_file_name():
	var current_time = OS.get_datetime()
	# day, dst, hour, minute, month, second, weekday, year
	return  "%s_%s_%s_%s_%s_%s" % [current_time.year, current_time.month, current_time.day, current_time.hour, current_time.minute, current_time.second ]


func reset_project():
	for note in note_mapping.values():
		remove_child(note)
	bar_interval = 8
	note_mapping = {}
	instrument = 0
	tempo = 120
	pan = 64
	volume = 111
	file_name
	active_notes = []
	velocity = 80
	$Camera2D.position = Vector2(0, 34 * cell_size.y)

func change_mixer_settings(volume, pan):
	self.volume = volume - 1
	self.pan = pan - 1
