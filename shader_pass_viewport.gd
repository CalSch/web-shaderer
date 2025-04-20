class_name ShaderPassViewport
extends Viewport

var is_image: bool = false
var shader_pass: ShaderPass

func set_texture(tex: Texture2D):
	#print("im image")
	#is_image = true
	$TextureRect.texture = tex
func set_shader(sh: ShaderPass):
	print("im shader")
	var mat = ShaderMaterial.new()
	mat.shader = sh.shader
	for param in sh.params.keys():
		print("setting %s to %s" % [param, sh.params[param]])
		mat.set_shader_parameter(param, sh.params[param])
	$TextureRect.material = mat
	self.shader_pass = sh
func set_param(key,value):
	$TextureRect.material.set_shader_parameter(key,value)
