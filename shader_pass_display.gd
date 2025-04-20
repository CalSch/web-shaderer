class_name ShaderPassDisplay
extends TextureRect

func set_source(vp: ShaderPassViewport):
	#var tex := ViewportTexture.new()
	#tex.viewport_path = vp.get_path()
	#print(" vp path = "+str(tex.viewport_path))
	self.texture = vp.get_texture()
