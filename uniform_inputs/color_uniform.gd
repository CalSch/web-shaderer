extends BaseUniform

func get_value():
	var c: Color = $ColorPickerButton.color
	return Vector4(c.r,c.g,c.b,c.a)

func set_value(val:Vector4):
	$ColorPickerButton.color.r = val.x
	$ColorPickerButton.color.g = val.y
	$ColorPickerButton.color.b = val.z
	$ColorPickerButton.color.a = val.w


func _on_color_picker_button_color_changed(color: Color) -> void:
	changed.emit(uniform_name)
