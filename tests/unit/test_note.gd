extends "res://addons/gut/test.gd"


func before_each():
	gut.p("ran setup", 2)

func after_each():
	gut.p("ran teardown", 2)

func before_all():
	gut.p("ran run setup", 2)

func after_all():
	gut.p("ran run teardown", 2)


func test_set_velocity_should_set_velocity_to_given_value():
	assert_true(true)
	
func test_setup_should_change_position_and_size_to_given_values():
	assert_true(true)
	
func test_calculate_color_should_calculate_color_related_to_velocity_value():
	assert_true(true)
	
func test_highlight_should_switch_color_to_magenta_if_enable_is_true():
	assert_true(true)
	
func test_highlight_should_switch_color_to_velocity_based_color_if_enable_is_false():
	assert_true(true)

func test_get_pitch_should_calculate_key_number_based_on_grid_cell_position():
	assert_true(true)
	
func test_get_note_on_should_calculate_relative_distance_from_current_track_position_to_beginning_of_note():
	assert_true(true)
	
func test_get_note_off_should_calculate_relative_distance_from_current_track_position_to_end_of_note():
	assert_true(true)
	
func test_as_rect_should_return_a_rectangle_object_with_dimensions_corresponding_to_note_attributes():
	assert_true(true)
	
func test_serialize_should_serialize_MIDI_related_attributes_to_JSON_format():
	assert_true(true)
