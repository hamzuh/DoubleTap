extends CanvasLayer

@onready var moneyLabel = $Money
@onready var ammoLabel = $Ammo
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

func _on_player_ammo_changed(current_ammo: Variant, reserve_ammo: Variant) -> void:
	if not self.is_node_ready():
		await self.ready
	ammoLabel.text = str(current_ammo) + " / " + str(reserve_ammo)

func _on_main_powerup_activate(startOrEnd: Variant, powerup_name: Variant) -> void:
	match powerup_name:
		"Double Points":
			$"HBoxContainer/Double Points".visible = startOrEnd
		"Instakill":
			$HBoxContainer/Instakill.visible = startOrEnd
		"Fire Sale":
			$"HBoxContainer/Fire Sale".visible = startOrEnd
