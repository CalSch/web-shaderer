extends BaseUniform

func get_value():
	return $SpinBox.value

func set_value(val:int):
	$SpinBox.value = val

func _on_spin_box_value_changed(value: float) -> void:
	changed.emit(uniform_name)
