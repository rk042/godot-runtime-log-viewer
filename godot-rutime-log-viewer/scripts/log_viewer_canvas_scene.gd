extends Control

@export var item:PackedScene
@onready var v_box_container: VBoxContainer = $VBoxContainer/bottom_menu/ScrollContainer/VBoxContainer
@onready var button_clean: Button = $VBoxContainer/top_menu/HBoxContainer/button_clean
@onready var button_settings: Button = $VBoxContainer/top_menu/HBoxContainer/button_settings
@onready var button_close: Button = $VBoxContainer/top_menu/HBoxContainer/button_close

func _ready() -> void:
	self.visible = false
	LogRouter.log_message.connect(_on_log_message)
	LogRouter.log_error.connect(_on_log_error)
	LogRouter.log_display.connect(_on_log_display)
	
	button_clean.pressed.connect(_clean_button_pressed)
	button_settings.pressed.connect(_settings_button_pressed)
	button_close.pressed.connect(_close_button_pressed)
	
	for i in range(100):
		print("testing message",i)

func _on_log_display(has_drawn:bool) ->void:
	self.visible=true
	pass

func _close_button_pressed() -> void:
	self.visible = false
	pass
func _clean_button_pressed() -> void:
	for i in v_box_container.get_children():
		i.queue_free()
	pass
func _settings_button_pressed() -> void:
	print("coming soon!")
	pass	
	
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
