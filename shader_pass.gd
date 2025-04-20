extends Node
class_name ShaderPass

@export var pass_name: String
@export var shader: Shader
@export var params: Dictionary

func _init() -> void:
	pass_name = "Shader Pass"
	shader = Shader.new()

func save_to_file(file: FileAccess):
	file.store_pascal_string(pass_name)
	file.store_pascal_string(shader.code)
	#file.store_16(len(params.keys()))
	#for param in params.keys():
		#file.store_pascal_string(param)
		#file.store_16(typeof(params[param]))
		# TODO: AAAAAAAAAAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHHHH!!!!!!!!!!!!!!!!!!!!!!!
		# TODO: AAAAAAAAAAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHHHH!!!!!!!!!!!!!!!!!!!!!!!
		# TODO: AAAAAAAAAAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHHHH!!!!!!!!!!!!!!!!!!!!!!!
		# TODO: AAAAAAAAAAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHHHH!!!!!!!!!!!!!!!!!!!!!!!
		# TODO: AAAAAAAAAAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHHHH!!!!!!!!!!!!!!!!!!!!!!!
static func load_from_file(file: FileAccess) -> ShaderPass:
	var sp = ShaderPass.new()
	sp.pass_name = file.get_pascal_string()
	sp.shader.code = file.get_pascal_string()
	return sp
