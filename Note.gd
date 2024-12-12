extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var pos = Vector2(0, 0)
var size = Vector2(0, 0)
var color = Color(0, 0, 0)
var velocity = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _draw():
	draw_rect(Rect2(pos, size), color)
	draw_rect(Rect2(pos, size), Color(0.0, 0.0, 0.0), false)


func set_velocity(velocity):
	self.velocity = velocity
	color = calculate_color()
	update()


func setup(pos, size):
	self.pos = pos
	self.size = size
	update()


func calculate_color() -> Color:
	var red = 0.0
	var green = 0.0
	var blue = 0.0
	var percentage = float(velocity)/127.0
	if percentage > 0.75:
		red = 1.0
		green = 1.0 - (percentage - 0.75)/0.25
	elif percentage > 0.5:
		red = (percentage - 0.5)/0.25
		green = 1.0
	elif percentage > 0.25:
		green = 1.0
		blue = 1.0 - (percentage - 0.25)/0.25
	else:
		green = percentage/0.25
		blue = 1.0
	return Color(red, green, blue)


func highlight(enable):
	if enable:
		color = Color(1.0, 0.0, 1.0)
	else:
		color = calculate_color()
	update()


func get_pitch():
	var grid = get_parent()
	return 108 - grid.world_to_map(pos).y


func get_note_on(track_position):
	return int(pos.x - track_position)


func get_note_off(track_position):
	return int(pos.x + size.x - track_position)


func as_rect():
	return Rect2(pos, size)

func serialize() -> Dictionary:
	var data = {
		"pos": [pos.x, pos.y],
		"size": [size.x, size.y],
		"velocity": velocity
	}
	return data 
