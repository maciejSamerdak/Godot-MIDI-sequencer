extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var grid = $ViewportContainer/Viewport/Editor/HBoxContainer2/ViewportContainer/Viewport/TileMap
onready var track_setings_menu = get_parent().get_node('TrackSettingsMenu')
onready var main_menu = get_parent().get_node('Menu')
onready var mixer = get_parent().get_node('Mixer')

# Called when the node enters the scene tree for the first time.
func _ready():
	$EditingButtons/BeginningButton.connect("pressed", grid, 'navigate_to_beginning')
	$EditingButtons/PrevButton.connect('pressed', grid, 'navigate_to_previous_measure')
	$EditingButtons/NextButton.connect('pressed', grid, 'navigate_to_next_measure')
	$EditingButtons/PlayButton.connect("toggled", grid, 'play')
	$Parameters/SelectButton.connect('toggled', grid, 'toggle_selection_mode')
	$Parameters/HSlider.connect('value_changed', grid, 'change_velocity')
	track_setings_menu.connect('track_settings_changed', grid, 'change_track_settings')
	grid.connect('time_sig_changed', $ViewportContainer/Viewport/Editor/HBoxContainer/Timeline, 'update_timeline')
	main_menu.connect('save_project', grid, 'save_project')
	main_menu.connect('load_project', grid, 'load_project')
	main_menu.connect('export_project', grid, 'export_project')
	main_menu.connect('new_project', grid, 'reset_project')
	mixer.connect('mixer_settings_changed', grid, 'change_mixer_settings')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TrackSettingsButton_pressed():
	get_tree().paused = true
	track_setings_menu.popup()


func _on_TrackSettingsMenu_popup_hide():
	get_tree().paused = false


func _on_MixerButton_pressed():
	get_tree().paused = true
	mixer.popup()


func _on_MenuButton_pressed():
	get_tree().paused = true
	main_menu.current_file_name = grid.file_name
	main_menu.popup()


func _on_Menu_popup_hide():
	get_tree().paused = false


func _on_Mixer_popup_hide():
	get_tree().paused = false
