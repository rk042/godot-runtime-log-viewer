class_name item_lable_button

extends Node

@onready var label:RichTextLabel = $"."
@onready var button: Button = $Button

var _is_error:bool = false
var message: String = ""
var count: int = 1
signal button_click

func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	pass

func set_text_in_lable(value:String, is_error:bool) -> void:
	if is_error:
		label.modulate = Color.RED
		_is_error = true
		pass
	
	message = value
	count = 1
	_update_label()
		
	if not is_error:
		_is_error = false
	pass

func get_message() -> String:
	return message

func increase_count() -> void:
	count += 1
	_update_label()
	
func _update_label() -> void:
	if count > 1:
		label.text = "%s (%d)" % [message, count]
	else:
		label.text = message

func _on_button_pressed() -> void:
	button_click.emit()
	pass # Replace with function body.
