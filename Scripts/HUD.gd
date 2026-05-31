extends CanvasLayer

@onready var moneyLabel = $Money
@onready var buyPrompt = $"Buy Prompt"
@onready var doorDebug = $"Door Debug"
@onready var roundCounter = $"Round Counter"
@onready var roomDebug = $"Room Debug"
@onready var powerMessage = $"Power Prompt"

func _on_player_money_changed(money):
	moneyLabel.text = ("£" + str(money))

func _on_level_doorbuymessage(openOrClose: Variant, door, price) -> void:
	if openOrClose:
		doorDebug.visible = true
		doorDebug.text = str(door)
		buyPrompt.text = ("Press X to buy door" + "\n£" + str(price))
		buyPrompt.visible = true
	else:
		doorDebug.visible = false
		buyPrompt.visible = false

func _on_level_roomchange(roomname: Variant) -> void:
	roomDebug.text = roomname

func _on_main_round_start(roundCount: Variant) -> void:
	roundCounter.text = "Round " + str(roundCount)

func _on_level_powermessage(openOrClose: Variant) -> void:
	if openOrClose:
		powerMessage.text = ("Press X to switch the power on")
		powerMessage.visible = true
	else:
		powerMessage.visible = false
