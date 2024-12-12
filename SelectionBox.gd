extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var box = Rect2(0, 0, 0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _draw():
	draw_rect(box, Color(1.0, 0.0, 0.0), false)


func setup(start, end):
	box = calculate_rect(start, end)
	# print(box)
	update()


func calculate_rect(start, end):
	var pos = Vector2(min(start.x, end.x), min(start.y, end.y))
	var size = Vector2(abs(start.x - end.x), abs(start.y - end.y))
	return Rect2(pos, size)


func reset_selection():
	box = Rect2(0, 0, 0, 0)
	update()


func intersects(rect):
	return box.intersects(rect)
