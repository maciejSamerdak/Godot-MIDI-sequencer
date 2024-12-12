extends Popup

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal mixer_settings_changed(volume, pan)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Pan_value_changed(value):
	$PanelContainer/VBoxContainer/VBoxContainer2/HBoxContainer3/Label.text = String(int(value))


func _on_Volume_value_changed(value):
	$PanelContainer/VBoxContainer/VBoxContainer2/HBoxContainer4/Label.text = String(int(value))


func _on_Button_pressed():
	var volume = int($PanelContainer/VBoxContainer/VBoxContainer2/HBoxContainer4/Volume.value)
	var pan = int($PanelContainer/VBoxContainer/VBoxContainer2/HBoxContainer3/Pan.value)
	emit_signal('mixer_settings_changed', volume, pan)
	hide()


func _on_Button2_pressed():
	hide()
