class_name item_lable_button

extends Node

@onready var label:RichTextLabel = $"."
@onready var button: Button = $Button

var _is_error:bool = false

signal button_click

func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	pass

func set_text_in_lable(value:String, is_error:bool) -> void:
	if is_error:
		label.modulate = Color.RED
		_is_error = true
		pass
		
	if not is_error:
		label.text = value
		_is_error = false
	pass

func _on_button_pressed() -> void:
	button_click.emit()
	pass # Replace with function body.
