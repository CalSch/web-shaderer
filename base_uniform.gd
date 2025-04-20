class_name BaseUniform
extends Node

signal changed

var uniform_name: String = ""

func get_value():
	return -1

func set_value(val):
	pass

func set_label(text:String):
	$Label.text = text
