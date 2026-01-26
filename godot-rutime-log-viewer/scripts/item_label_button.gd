class_name item_lable_button

extends Node

@onready var label:RichTextLabel = $"."
@onready var button: Button = $Button

signal button_click

func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	pass

func set_text_in_lable(value:String) -> void:
	label.text = value
	pass

func _on_button_pressed() -> void:
	button_click.emit()
	pass # Replace with function body.
