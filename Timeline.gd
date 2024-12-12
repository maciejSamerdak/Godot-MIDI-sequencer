extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var grid

# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = 40
	grid = get_parent().get_parent().get_node('HBoxContainer2/ViewportContainer/Viewport/TileMap')


func _process(delta):
	position.x = 40 - grid.get_node('Camera2D').position.x


func _draw():
	var rulers = grid.cols/grid.bar_interval
	#for x in range(rulers):
		#var ruler_position = 40 + x * grid.bar_interval * grid.cell_size.x
	draw_ruler_component(0, 0, grid.cols * grid.cell_size.x, 40)

func update_timeline():
	update()

func draw_ruler_component(x, y, width, height):
	var line_color = Color(1.0, 1.0, 1.0)
	var line_width = 1
	var bar_width = 2
	var regular_length = 0.5
	var bar_length = 0.75
	var label_left_margin = 5
	var label_bottom_margin = 5
	
	draw_rect(Rect2(x, y, width, height), Color(0.0, 0.0, 0.0))
	
	for x in range(grid.cols + 1):
		var col_position = x * grid.cell_size.x
		if x % grid.bar_interval == 0:
			draw_line(Vector2(col_position, height), Vector2(col_position, height * (1 - bar_length)), line_color, bar_width)
			draw_string(get_parent().get_font("font"), Vector2(col_position + label_left_margin, height - label_bottom_margin), String(x/grid.bar_interval + 1))
		else:
			draw_line(Vector2(col_position, height), Vector2(col_position, height * (1 - regular_length)), line_color, line_width)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
