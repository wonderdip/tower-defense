@tool
extends Control
class_name Money

@export var starting_cash: int:
	set(value):
		starting_cash = value
		current_cash = value
		if Engine.is_editor_hint():
			_on_starting_cash_changed()

var current_cash: int:
	set(value):
		current_cash = value
		if not Engine.is_editor_hint():
			_on_current_cash_changed()

@onready var cash_label: Label = $CoinSprite/CashLabel

func _ready() -> void:
	current_cash = starting_cash
	_on_current_cash_changed()
	
func add_money(amount: int):
	current_cash += amount

func can_buy(cost: int) -> bool:
	return current_cash >= cost

func subtract_money(amount: int):
	if current_cash >= amount:
		current_cash -= amount

func _on_starting_cash_changed():
	if not is_inside_tree():
		return
	var label: Label = get_node_or_null("CoinSprite/CashLabel")
	if label:
		label.text = "$" + str(starting_cash)

func _on_current_cash_changed():
	if not is_inside_tree():
		return
	if cash_label:
		cash_label.text = "$" + str(current_cash)
