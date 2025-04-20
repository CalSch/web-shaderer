class_name Project
extends Node

@export var project_name: String
@export var passes: Array[ShaderPass]

func _init() -> void:
	project_name = "default"
	passes = []

func get_pass_by_name(name: String) -> ShaderPass:
	for sp in passes:
		if sp.pass_name==name:
			return sp
	return null

static func proj_name_to_file_name(proj_name:String) -> String:
	return proj_name.replace(" ","_")

func save_to_file():
	var file = FileAccess.open("user://%s.project" % proj_name_to_file_name(project_name),FileAccess.WRITE)
	print("saving to %s" % file.get_path())
	file.store_pascal_string(project_name)
	file.store_16(len(passes))
	for sp in passes:
		sp.save_to_file(file)
	file.close()
	print("saved!")
static func load_from_file(path:String) -> Project:
	print("Loading file '%s'" % path)
	var proj = Project.new()
	var file = FileAccess.open(path,FileAccess.READ)
	#file.store_pascal_string(project_name)
	proj.project_name = file.get_pascal_string()
	#file.store_16(len(passes))
	var passes = file.get_16()
	for i in passes:
		var sp = ShaderPass.load_from_file(file)
		proj.passes.append(sp)
	return proj
	#for sp in passes:
		#sp.save_to_file(file)
