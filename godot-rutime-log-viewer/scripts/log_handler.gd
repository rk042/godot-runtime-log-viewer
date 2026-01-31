extends Node2D

@onready var label := $Label

func _ready() -> void:
	LogRouter.log_message.connect(_on_log_message)
	LogRouter.log_error.connect(_on_log_error)

func _on_log_message(message: String, is_error: bool) -> void:
	label.text += message + "\n"

func _on_log_error(data: String) -> void:
	label.text += data
	pass
