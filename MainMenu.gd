extends Popup

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal new_project
signal save_project(file_name)
var current_file_name
signal load_project(file_name)
signal export_project(file_name)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_OpenDialog_confirmed():
	var file_name = $OpenDialog.current_file
	emit_signal("load_project", file_name)
	hide()


func _on_SaveDialog_confirmed():
	var file_name = $SaveDialog.current_file
	emit_signal("save_project", file_name)
	hide()


func _on_ExportDialog_confirmed():
	var file_name = $ExportDialog.current_file
	emit_signal("export_project", file_name)
	hide()


func _on_Button_pressed():
	emit_signal("new_project")
	hide()


func _on_Button2_pressed():
	$SaveDialog.current_file = current_file_name + ".myseq"
	$SaveDialog.popup()


func _on_Button3_pressed():
	$OpenDialog.popup()


func _on_Button4_pressed():
	$ExportDialog.current_file = current_file_name + ".mid"
	$ExportDialog.popup()
