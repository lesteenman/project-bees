extends VBoxContainer

signal navigate_back

func _on_lab_back_button_pressed() -> void:
	navigate_back.emit()
