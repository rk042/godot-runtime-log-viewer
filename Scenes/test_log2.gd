extends Node

@onready var label: Label = $"../Label2"


func _ready() -> void:
	print("this is working or not?")
	
	label = null
	for i in range(10):
		label.text = "test"
