extends Control

#@export var shaders: Array[ShaderPass] = []
@export var project: Project = Project.new()
var viewports: Array[ShaderPassViewport] = []
var editors: Array[ShaderEditor] = []
var uniforms: Array[BaseUniform] = []
@onready var shader_editor := preload("res://shader_editor.tscn")
@onready var shader_pass_viewport := preload("res://shader_pass_viewport.tscn")
@onready var shader_pass_display := preload("res://shader_pass_display.tscn")
@onready var passes_node = $VBoxContainer/HSplitContainer/PanelContainer2/VSplitContainer/VBoxContainer2/ScrollContainer/Passes
@onready var editors_node = $VBoxContainer/HSplitContainer/PanelContainer/VBoxContainer/Editors
@onready var uniforms_node = $VBoxContainer/HSplitContainer/PanelContainer2/VSplitContainer/VBoxContainer/Uniforms

@export var base_image: Image

enum RenameType {
	None,
	PassName,
	ProjectName
}

var thing_to_rename: RenameType = RenameType.None

func update_pass_viewports():
	print("updating viewports")
	for ch in $Viewports.get_children():
		$Viewports.remove_child(ch)
	viewports = []
	var base: ShaderPassViewport = shader_pass_viewport.instantiate()
	base.set_texture(ImageTexture.create_from_image(base_image))
	base.name = "BaseVP"
	viewports.append(base)
	$Viewports.add_child(base)
	var last_vp: ShaderPassViewport = base
	for sh in project.passes:
		var vp: ShaderPassViewport = shader_pass_viewport.instantiate()
		vp.set_texture(last_vp.get_texture())
		vp.set_shader(sh)
		#vp.shader_pass = sh
		vp.name = sh.pass_name
		viewports.append(vp)
		$Viewports.add_child(vp)
		last_vp = vp
	#viewports[2].set_texture(viewports[1].)
		
func update_pass_displays():
	print("updating displays")
	for child in passes_node.get_children():
		passes_node.remove_child(child)
	for vp in viewports:
		var disp: ShaderPassDisplay = shader_pass_display.instantiate()
		disp.set_source(vp)
		disp.name = vp.name
		passes_node.add_child(disp)
	

func update_code_editors():
	print("updating editors")
	editors = []
	for ch in editors_node.get_children():
		editors_node.remove_child(ch)
	for sh in project.passes:
		var editor: ShaderEditor = shader_editor.instantiate()
		editor.name = sh.pass_name
		editor.link_to_pass(sh)
		editor.changed.connect(_on_editor_change)
		editor.changed.emit()
		editors_node.add_child(editor)
	var add_button = Control.new()
	add_button.name = "+"
	editors_node.add_child(add_button)

func _on_editor_change():
	update_uniforms()

func get_uniform_node(path:String) -> BaseUniform:
	for node in uniforms:
		if node.uniform_name == path:
			return node
	return null

func create_uniform_node(type: int, name: String, value = null) -> BaseUniform:
	var node: BaseUniform = preload("res://uniform_inputs/empty_uniform.tscn").instantiate()
	if type == TYPE_INT:
		node = preload("res://uniform_inputs/int_uniform.tscn").instantiate()
	elif type == TYPE_FLOAT:
		node = preload("res://uniform_inputs/float_uniform.tscn").instantiate()
	elif type == TYPE_VECTOR4:
		node = preload("res://uniform_inputs/color_uniform.tscn").instantiate()
	node.set_label(name)
	node.uniform_name = name
	node.changed.connect(_on_uniform_change)
	if value != null:
		node.set_value(value)
	return node

func _on_uniform_change(path: String):
	var value = get_uniform_node(path).get_value()
	print("this uniform changed! %s -> %s" % [path, value])
	var pass_name = path.split("/")[0]
	var uniform_name = path.split("/")[1]
	project.get_pass_by_name(pass_name).params[uniform_name] = value
	for vp in viewports:
		if vp.shader_pass and vp.shader_pass.pass_name == pass_name:
			vp.set_param(uniform_name,value)

func update_uniforms():
	for ch in uniforms_node.get_children():
		uniforms_node.remove_child(ch)
	uniforms = []
	for sp in project.passes:
		print("Pass "+sp.pass_name)
		print("  uniforms: "+str(sp.shader.get_shader_uniform_list()))
		var unis := sp.shader.get_shader_uniform_list()
		for uni in unis:
			var path = "%s/%s" % [sp.pass_name, uni["name"]]
			print("    uniform(%s,'%s')" % [type_string(uni["type"]), path])
			var node = create_uniform_node(uni["type"],path, sp.params[uni["name"]] if sp.params.has(uni["name"]) else null )
			uniforms_node.add_child(node)
			uniforms.append(node)
			

func update_project_menu():
	print('updating proect menu')
	$VBoxContainer/MenuBar/Project.set_item_text(0,"Project: '%s'" % project.project_name)

func _ready() -> void:
	#project = Project.load_from_file("user://default.project")
	project.passes.append(ShaderPass.new())
	project.passes.append(ShaderPass.new())
	project.passes[0].pass_name = "Default"
	project.passes[0].shader.code = """
shader_type canvas_item;

uniform float fThing;
uniform vec4 cThing;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.r += 0.1;
}
"""
	project.passes[1].pass_name = "Green"
	project.passes[1].shader.code = """
shader_type canvas_item;

uniform float fThing;
uniform int iThing;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.g += 0.1;
}
"""
	update_pass_viewports()
	update_pass_displays()
	update_code_editors()
	update_uniforms()
	update_project_menu()
	

func _on_project_menu_id_pressed(id: int) -> void:
	if id == 0: # Save
		project.save_to_file()
	elif id == 1: # Open
		$OpenFileDialog.show()
	elif id == 2: # Clicked on the project name (rename it)
		thing_to_rename = RenameType.ProjectName
		$RenameDialog/HBoxContainer/LineEdit.text = project.project_name
		$RenameDialog.show()
		
func _on_pass_menu_id_pressed(id: int) -> void:
	if id == 0: # Rename
		thing_to_rename = RenameType.PassName
		$RenameDialog/HBoxContainer/LineEdit.text = get_selected_pass().pass_name
		$RenameDialog.show()
	elif id == 1: # Duplicate
		var current = get_selected_pass()
		var new = ShaderPass.new()
		new.pass_name = current.pass_name + " (copy)"
		new.shader.code = current.shader.code
		new.params = current.params
		project.passes.insert(editors_node.current_tab + 1, new)
		update_pass_viewports()
		update_pass_displays()
		update_code_editors()
		update_uniforms()
	elif id == 2: # Delete
		project.passes.remove_at(editors_node.current_tab)
		update_pass_viewports()
		update_pass_displays()
		update_code_editors()
		update_uniforms()


func _on_open_file_dialog_file_selected(path: String) -> void:
	project = Project.load_from_file(path)
	update_pass_viewports()
	update_pass_displays()
	update_code_editors()


func _on_editors_tab_clicked(idx: int) -> void:
	var tab = editors_node.get_child(idx)
	if tab.name == "+":
		var sp = ShaderPass.new()
		sp.shader.code = """shader_type canvas_item;

void vertex() {

}

void fragment() {
	
}
"""
		sp.pass_name = get_new_pass_name()
		project.passes.append(sp)
		update_pass_viewports()
		update_pass_displays()
		update_code_editors()

func get_new_pass_name():
	return "new pass" # TODO: make a *unique* name

func get_selected_pass() -> ShaderPass:
	return project.passes[editors_node.current_tab]


func _on_rename_dialog_confirmed() -> void:
	var text = $RenameDialog/HBoxContainer/LineEdit.text
	# TODO: validate input
	if thing_to_rename == RenameType.PassName:
		get_selected_pass().pass_name = text
		
		update_pass_viewports()
		update_pass_displays()
		update_code_editors()
		update_uniforms()
	elif thing_to_rename == RenameType.ProjectName:
		project.project_name = text
		update_project_menu()
