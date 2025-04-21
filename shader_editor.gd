class_name ShaderEditor
extends Control

signal changed

var linked_pass: ShaderPass

@export var color_data_type: Color
@export var color_special_variable: Color
@export var color_thing: Color

func _ready() -> void:
	var highlighter: CodeHighlighter = $CodeEdit.syntax_highlighter
	highlighter.add_keyword_color("void", color_data_type)
	highlighter.add_keyword_color("int", color_data_type)
	highlighter.add_keyword_color("float", color_data_type)
	highlighter.add_keyword_color("vec2", color_data_type)
	highlighter.add_keyword_color("vec3", color_data_type)
	highlighter.add_keyword_color("vec4", color_data_type)
	
	highlighter.add_keyword_color("COLOR", color_special_variable)
	highlighter.add_keyword_color("UV", color_special_variable)
	highlighter.add_keyword_color("uniform", color_thing)
	highlighter.add_keyword_color("shader_type", color_thing)

func link_to_pass(shader_pass: ShaderPass):
	linked_pass = shader_pass
	$CodeEdit.text = shader_pass.shader.code
	$CodeEdit.connect("text_changed",_on_code_change)

func _on_code_change():
	if linked_pass:
		linked_pass.shader.code = $CodeEdit.text
		$CodeEdit.syntax_highlighter.update_cache()
		changed.emit()
