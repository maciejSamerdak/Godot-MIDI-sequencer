extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var grid = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _draw():
	var line_color = Color(0.5, 0.5, 0.5)
	var line_width = 1
	var bar_color = Color(0, 0, 0)
	var bar_width = 2
	var window_size = OS.get_window_size()
	
	draw_rect(Rect2(0, 0, grid.cols * grid.cell_size.x, grid.rows * grid.cell_size.y), Color(225, 225, 225))

	for y in range(grid.rows + 1):
		var row_position = y * grid.cell_size.y
		var limit = grid.cols * grid.cell_size.x
		draw_line(Vector2(0, row_position), Vector2(limit, row_position), line_color, line_width)

	for x in range(grid.cols + 1):
		var col_position = x * grid.cell_size.x
		var limit = grid.rows * grid.cell_size.y
		if x % grid.bar_interval == 0:
			draw_line(Vector2(col_position, 0), Vector2(col_position, limit), bar_color, bar_width)
		else:
			draw_line(Vector2(col_position, 0), Vector2(col_position, limit), line_color, line_width)
