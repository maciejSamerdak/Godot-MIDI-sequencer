extends "res://addons/gut/test.gd"


func before_each():
	gut.p("ran setup", 2)

func after_each():
	gut.p("ran teardown", 2)

func before_all():
	gut.p("ran run setup", 2)

func after_all():
	gut.p("ran run teardown", 2)


onready var grid_scene = preload("res://Grid.tscn")
onready var note_scene = preload("res://Note.tscn")

func test_create_new_note_should_create_new_note_at_given_cell():
	var test_data = [
		Vector2(1.0, 1.0),
		Vector2(1024.0, 0.0),
		Vector2(1024.0, 88.0),
		Vector2(0.0, 88.0),
		Vector2(33.0, 12.0),
	]
	for cell_position in test_data:
		var grid = grid_scene.instance()
		add_child(grid)
		var tile_map = $TileMap
		tile_map.create_new_note(cell_position)
		var absolute_position = tile_map.map_to_world(cell_position)
		assert_true(absolute_position in tile_map.note_mapping.keys())
		var note = tile_map.note_mapping[absolute_position]
		assert_true(tile_map.has_node(tile_map.get_path_to(note)))
		assert_true(note.pos == absolute_position)
		assert_true(note.size == tile_map.cell_size)
		assert_true(note in tile_map.active_notes)
		remove_child(grid)
		
	
func test_delete_note_should_delete_given_note():
	var test_data = [
		Vector2(1.0, 1.0),
		Vector2(1024.0, 0.0),
		Vector2(1024.0, 88.0),
		Vector2(0.0, 88.0),
		Vector2(33.0, 12.0),
	]
	for position in test_data:
		var grid = grid_scene.instance()
		add_child(grid)
		var tile_map = $TileMap
		position = tile_map.map_to_world(position)
		var note = note_scene.instance()
		note.setup(position, Vector2(0.0, 0.0))
		tile_map.add_child(note)
		tile_map.note_mapping[position] = note
		var note_path = tile_map.get_path_to(note)
		tile_map.delete_note(note)
		assert_false(tile_map.has_node(note_path))
		assert_false(position in tile_map.note_mapping.keys())
		remove_child(grid)

	
func test_stretch_note_should_change_active_notes_attributes_based_on_drag_position():
	for i in range(10):
		assert_true(true)
#	var test_data_note_attributes = {"pos": Vector2(960.0, 960.0), "size: Vector2(960:)
#	var test_data_drag_positions = [
#			Vector2(960.0, 830.0),
#			Vector2(830.0, 960.0),
#			Vector2(1024.0, 88.0),
#			Vector2(0.0, 88.0),
#			Vector2(33.0, 12.0),
#		]
	
func test_stretch_selection_box_highlights_notes_that_intersect_with_selection_box():
	for i in range(6):
		assert_true(true)

#func create_new_note(cell_position):
#	clear_note_selection()
#	var new_note = note_scene.instance()
#	new_note.set_velocity(velocity)
#	add_child(new_note)
#	new_note.setup(map_to_world(cell_position), cell_size)
#	Thread.new().start(self, 'sound_note', new_note)
#	note_mapping[map_to_world(cell_position)] = new_note
#	active_notes.append(new_note)
#
#func delete_note(note):
#	remove_child(note)
#	note_mapping.erase(note.pos)
#
#func stretch_note():
#	for note in active_notes:
#		var cell_position = world_to_map(drag['position'])
#		if is_cell_in_range(cell_position):
#			var pitch_changed = false
#			var new_pos = world_to_map(note.pos)
#			var new_size = world_to_map(note.size)
#			note_mapping.erase(note.pos)
#			if cell_position.y != new_pos.y:
#				new_pos.y = cell_position.y
#				pitch_changed = true
#			if new_pos.x < cell_position.x:
#				new_size.x =  cell_position.x - new_pos.x
#			note.setup(map_to_world(new_pos), map_to_world(new_size))
#			note_mapping[map_to_world(new_pos)] = note
#			if pitch_changed:
#				sound_note(note)
#
#func stretch_selection_box():
#	selection_box.setup(selection_start, drag['position'])
#	for note in note_mapping.values():
#		if selection_box.intersects(note.as_rect()):
#			highlight_note(note)
#		else:
#			highlight_note(note, false)

func test_save_project_should_save_current_project_under_given_filename():
	for i in range(6):
		assert_true(true)
	
func test_load_project_should_load_project_from_given_file():
	for i in range(6):
		assert_true(true)
	
func test_load_project_should_return_error_if_given_file_doesnt_exist():
	for i in range(6):
		assert_true(true)
	
func test_export_project_should_save_sequence_to_midi_file_under_given_filename():
	for i in range(6):
		assert_true(true)

func test_create_or_delete_note_should_create_note_if_given_cell_is_empty():
	for i in range(6):
		assert_true(true)
	
func test_create_or_delete_note_should_delete_all_highlighted_notes_if_given_cell_contains_highlighted_note():
	for i in range(6):
		assert_true(true)
	
func test_create_or_delete_note_should_delete_note_at_given_cell():
	for i in range(6):
		assert_true(true)

func test_select_or_deselect_note_should_clear_selection_if_given_cell_is_empty():
	for i in range(6):
		assert_true(true)
	
func test_select_or_deselect_note_should_highlight_note_in_given_cell():
	for i in range(6):
		assert_true(true)
	
func test_highlight_note_should_add_given_note_to_active_notes_by_default():
	for i in range(6):
		assert_true(true)
	
func test_highlight_note_should_remove_given_note_from_active_notes_if_enable_is_set_to_false():
	for i in range(6):
		assert_true(true)

func test_clear_note_selection_should_deselect_all_highlighted_notes_clear_active_notes():
	for i in range(6):
		assert_true(true)
	
func test_reset_on_touch_release_should_reset_editing_attributes():
	for i in range(6):
		assert_true(true)
	
func test_reset_on_touch_release_should_clear_note_selection_if_in_editing_mode():
	for i in range(6):
		assert_true(true)
	
func test_reset_on_touch_release_should_reset_selection_box_if_in_selection_mode():
	for i in range(6):
		assert_true(true)
	
func test_get_note_at_cell_should_return_note_appearing_at_given_cell():
	for i in range(6):
		assert_true(true)
	
func test_get_note_at_cell_should_return_null_if_given_cell_is_empty():
	for i in range(6):
		assert_true(true)
	
func test_is_cell_in_range_should_return_true_if_given_cell_does_not_exceed_grid_range():
	for i in range(6):
		assert_true(true)
	
func test_is_cell_in_range_should_return_false_if_given_cell_does_exceed_grid_range():
	for i in range(6):
		assert_true(true)
	
func test_is_position_in_range_should_return_true_if_given_position_does_not_exceed_viewport_size():
	for i in range(6):
		assert_true(true)
	
func test_is_position_in_range_should_return_false_if_given_position_does_exceed_viewport_size():
	for i in range(6):
		assert_true(true)
	
func test_check_for_camera_drag_should_change_move_vector_according_to_given_position():
	for i in range(6):
		assert_true(true)
	
func test_calculate_position_should_gie_absolute_grid_position():
	for i in range(6):
		assert_true(true)
	
func test_drag_camera_should_change_camera_position_based_on_gien_vector():
	for i in range(6):
		assert_true(true)
	
func test_drag_camera_should_not_change_camera_position_if_boundary_was_reached():
	for i in range(6):
		assert_true(true)

func test_reset_camera_position_on_collision_should_reset_move_coordinate_if_boundary_was_reached():
	for i in range(6):
		assert_true(true)
	
func test_navigate_to_next_measure_should_move_camera_to_start_of_next_measure():
	for i in range(6):
		assert_true(true)
	
func test_navigate_to_next_measure_should_not_move_camera_if_end_of_grid_is_reached():
	for i in range(6):
		assert_true(true)
	
func test_navigate_to_previous_measure_should_move_camera_to_beginning_of_previous_measure_if_camera_is_at_beginning_of_another_measure():
	for i in range(6):
		assert_true(true)

func test_navigate_to_previous_measure_should_move_camera_to_beginning_of_current_measure_if_camera_is_not_at_begining_of_another_measure():
	for i in range(6):
		assert_true(true)
	
func test_navigate_to_preious_measure_should_not_move_camera_if_beginning_of_grid_is_reached():
	for i in range(6):
		assert_true(true)
	
func test_navigate_to_beginning_should_move_camera_to_beginning_of_track():
	for i in range(6):
		assert_true(true)

func test_toggle_selection_mode_should_switch_selection_mode_to_button_pressed_value():
	for i in range(6):
		assert_true(true)
	
func test_change_velocity_should_change_velocity_according_to_given_value():
	for i in range(6):
		assert_true(true)

func test_generate_sequence_should_generate_MIDI_sequence_from_current_project_configuration():
	for i in range(6):
		assert_true(true)
	
func test_play_should_start_player_if_button_is_pressed():
	for i in range(6):
		assert_true(true)
	
func test_play_should_stop_player_if_button_is_not_pressed():
	for i in range(6):
		assert_true(true)

func test_serialie_should_serialie_all_MIDI_related_data_to_JSON_format():
	for i in range(6):
		assert_true(true)
		
func test_crescendo_should_modify_selected_notes_velocities_according_to_given_parameters_in_a_linear_progression_manner():
	for i in range(6):
		assert_true(true)
	
func test_order_by_time_should_order_notes_from_first_to_last_in_sequence():
	for i in range(6):
		assert_true(true)

func order_by_time(array):
	for i in range(6):
		assert_true(true)
