extends Control

@export var item:PackedScene
@onready var v_box_container: VBoxContainer = $VBoxContainer/bottom_menu/ScrollContainer/VBoxContainer
@onready var button_clean: Button = $VBoxContainer/top_menu/HBoxContainer/button_clean
@onready var button_settings: Button = $VBoxContainer/top_menu/HBoxContainer/button_settings
@onready var button_close: Button = $VBoxContainer/top_menu/HBoxContainer/button_close
@onready var button_debug: Button = $VBoxContainer/top_menu/HBoxContainer/button_debug
@onready var button_error: Button = $VBoxContainer/top_menu/HBoxContainer/button_error

var is_log_visible:bool = true
var is_error_visible:bool = true

var items:Array[item_lable_button] 

func _ready() -> void:
	self.visible = false
	LogRouter.log_message.connect(_on_log_message)
	LogRouter.log_error.connect(_on_log_error)
	LogRouter.log_display.connect(_on_log_display)
	
	button_clean.pressed.connect(_clean_button_pressed)
	button_settings.pressed.connect(_settings_button_pressed)
	button_close.pressed.connect(_close_button_pressed)
	button_debug.pressed.connect(_log_button_pressed)
	button_error.pressed.connect(_error_button_pressed)
	pass		

func _log_button_pressed() ->void:
	for i in items:
		if not i._is_error:
			if i.visible:
				i.visible = false
			else:
				i.visible = true
			pass
			
	if not is_log_visible:
		button_debug.self_modulate = Color.WHITE
		pass
	else:
		button_debug.self_modulate = Color.RED
		pass
		
	is_log_visible = !is_log_visible
	pass
	
func _error_button_pressed() ->void:
	for i in items:
		if i._is_error:
			if i.visible:
				i.visible = false
			else:
				i.visible = true
			pass
	
	if not is_error_visible:
		button_error.self_modulate = Color.WHITE
		pass
	else:
		button_error.self_modulate = Color.RED
		pass		
	
	is_error_visible = !is_error_visible
	
	pass

func _on_log_display(has_drawn:bool) ->void:
	self.visible=true
	pass

func _close_button_pressed() -> void:
	self.visible = false
	pass
func _clean_button_pressed() -> void:
	for i in v_box_container.get_children():
		i.queue_free()
	items.clear()
	pass
func _settings_button_pressed() -> void:
	print("coming soon!")
	pass	
	
func _on_log_message(message: String, is_error: bool) -> void:
	
	for existing_item in items:
		if existing_item.get_message() == message:
			existing_item.increase_count()
			return  # Already exists, do not add again
			
	var _item:item_lable_button = item.instantiate()
	v_box_container.add_child(_item)
	_item.set_text_in_lable(message,false)
	_item.button_click.connect(_item_button_click)
	
	items.append(_item)
	
	if not is_log_visible:
		_item.visible = false
		pass
	pass

func _on_log_error(data: String) -> void:
	for existing_item in items:
		if existing_item.get_message() == data:
			existing_item.increase_count()
			return  # Already exists, do not add again
	
	var _item:item_lable_button = item.instantiate()
	v_box_container.add_child(_item)
	_item.set_text_in_lable(data,true)
	_item.button_click.connect(_item_button_click)
	items.append(_item)
	
	if not is_error_visible:
		_item.visible = false
		pass
		
	pass

func _item_button_click() -> void:
	print("button clicked")
	pass
