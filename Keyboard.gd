extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var grid
# Called when the node enters the scene tree for the first time.
func _ready():
	grid = get_parent().get_node('ViewportContainer/Viewport/TileMap')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rect_position.y = - grid.get_node('Camera2D').position.y
	