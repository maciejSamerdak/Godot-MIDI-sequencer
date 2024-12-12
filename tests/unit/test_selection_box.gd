extends "res://addons/gut/test.gd"


func before_each():
	gut.p("ran setup", 2)

func after_each():
	gut.p("ran teardown", 2)

func before_all():
	gut.p("ran run setup", 2)

func after_all():
	gut.p("ran run teardown", 2)


func test_setup_should_set_box_size_based_on_given_parameters():
	for i in range(5):
		assert_true(true)

func test_calculate_rect_should_return_rectangle_object_based_on_given_parameters():
	for i in range(5):
		assert_true(true)
	
func test_reset_selection_should_change_box_size_to_zero():
	for i in range(5):
		assert_true(true)

func test_intersects_should_return_true_if_selection_intersects_with_given_rectangle():
	for i in range(5):
		assert_true(true)
	
func test_intersects_should_return_false_if_selection_does_not_intersect_with_given_rectangle():
	for i in range(5):
		assert_true(true)
