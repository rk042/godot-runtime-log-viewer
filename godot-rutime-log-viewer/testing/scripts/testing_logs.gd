extends Node

func _ready() -> void:
	for i in range(50):
		push_error("Something went wrong at runtime!",i)	
		print("testing message",i)
