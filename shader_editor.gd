class_name ShaderEditor
extends Control

signal changed

var linked_pass: ShaderPass

func link_to_pass(shader_pass: ShaderPass):
	linked_pass = shader_pass
	$CodeEdit.text = shader_pass.shader.code
	$CodeEdit.connect("text_changed",_on_code_change)

func _on_code_change():
	if linked_pass:
		linked_pass.shader.code = $CodeEdit.text
		changed.emit()
