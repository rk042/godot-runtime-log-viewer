extends Control

@export var item:PackedScene
@onready var v_box_container: VBoxContainer = $VBoxContainer/bottom_menu/ScrollContainer/VBoxContainer

func _ready() -> void:
	LogRouter.log_message.connect(_on_log_message)
	LogRouter.log_error.connect(_on_log_error)
	
	for i in range(100):
		print("testing message",i)

func _on_log_message(message: String, is_error: bool) -> void:
	var _item:item_lable_button = item.instantiate()
	v_box_container.add_child(_item)
	_item.set_text_in_lable(message)
	_item.button_click.connect(_item_button_click)
	pass

func _on_log_error(data: String) -> void:
	var _item:item_lable_button = item.instantiate()
	v_box_container.add_child(_item)
	_item.set_text_in_lable(data)
	_item.button_click.connect(_item_button_click)
	pass

func _item_button_click() -> void:
	print("button clicked")
	pass
