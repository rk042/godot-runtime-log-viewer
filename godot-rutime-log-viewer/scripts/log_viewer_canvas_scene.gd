extends Control

@export var item:PackedScene
@onready var v_box_container: VBoxContainer = $VBoxContainer/bottom_menu/ScrollContainer/VBoxContainer

func _ready() -> void:
	for i in range(100):
		var _item:item_lable_button = item.instantiate()
		v_box_container.add_child(_item)
		_item.button_click.connect(_item_button_click)
		pass
	pass

func _item_button_click() -> void:
	print("button clicked")
	pass
