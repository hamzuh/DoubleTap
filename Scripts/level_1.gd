extends StaticBody2D

@onready var Player = get_parent().get_Player()
@onready var suitable_spawners = [$Spawners/SpawnRoom1, $Spawners/SpawnRoom2]

var current_room = "Spawn Room"

signal doorbuymessage(openOrClose, door, price)
signal roomchange(roomname)

signal powermessage(openOrClose)

#func _input(event: InputEvent):
	#if Input.is_action_just_pressed("ui_accept"):
		#$NavigationRegion2D/NavigationObstacle2D.affect_navigation_mesh = !$NavigationRegion2D/NavigationObstacle2D.affect_navigation_mesh
		#$NavigationRegion2D.bake_navigation_polygon()
		#print("BAKING...")

func _on_door_buyable_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body == Player:
		var doorNum = shape_find_owner(local_shape_index)
		var doorPrice
		match(doorNum):
			0, 2, 8:
				doorPrice = 500
			3, 6, 7, 9:
				doorPrice = 750
			4, 5:
				doorPrice = 1000
			1:
				doorPrice = 1250
		doorbuymessage.emit(true, doorNum, doorPrice)

func _on_door_buyable_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body == Player:
		doorbuymessage.emit(false, 0, 0)

# There's gotta be a better way to do this
# There literally is and I know what it is
func _on_player_buy_door(doorNum: Variant) -> void:
	match doorNum:
		0:
			$Doors/StaticBody2D.visible = false
			$Doors/StaticBody2D.get_node("CollisionShape2D").disabled = true
			$NavigationRegion2D/Room1.affect_navigation_mesh = false
			$NavigationRegion2D/Door1.affect_navigation_mesh = false
			$DoorBuyable/db1.disabled = true
			$Spawners/FirstCorridor.activated = true
		1:
			$Doors/StaticBody2D2.visible = false
			$Doors/StaticBody2D2.get_node("CollisionShape2D").disabled = true
			$NavigationRegion2D/Room1.affect_navigation_mesh = false
			$NavigationRegion2D/Room4.affect_navigation_mesh = false
			$NavigationRegion2D/Door2.affect_navigation_mesh = false
			$DoorBuyable/db2.disabled = true
			$Spawners/FirstCorridor.activated = true
		2:
			$Doors/StaticBody2D3.visible = false
			$Doors/StaticBody2D3.get_node("CollisionShape2D").disabled = true
			$NavigationRegion2D/Room2.affect_navigation_mesh = false
			$NavigationRegion2D/Door3.affect_navigation_mesh = false
			$DoorBuyable/db3.disabled = true
			$Spawners/CRoom.activated = true
		3:
			$Doors/StaticBody2D4.visible = false
			$Doors/StaticBody2D4.get_node("CollisionShape2D").disabled = true
			$NavigationRegion2D/Room3.affect_navigation_mesh = false
			$NavigationRegion2D/Door4.affect_navigation_mesh = false
			$DoorBuyable/db4.disabled = true
			$Spawners/Bunk.activated = true
		4, 5:
			$Doors/StaticBody2D5.visible = false
			$Doors/StaticBody2D5/CollisionShape2D2.disabled = true
			$Doors/StaticBody2D5/CollisionShape2D3.disabled = true
			$NavigationRegion2D/Room6.affect_navigation_mesh = false
			$NavigationRegion2D/Room5.affect_navigation_mesh = false
			$NavigationRegion2D/Door5.affect_navigation_mesh = false
			$NavigationRegion2D/Door6.affect_navigation_mesh = false
			$DoorBuyable/db5.disabled = true
			$DoorBuyable/db6.disabled = true
			$Spawners/OutdoorCubby.activated = true
			$Spawners/OutdoorFence.activated = true
		6:
			$Doors/StaticBody2D7.visible = false
			$Doors/StaticBody2D7.get_node("CollisionShape2D").disabled = true
			$NavigationRegion2D/Room7.affect_navigation_mesh = false
			$NavigationRegion2D/Room5.affect_navigation_mesh = false
			$NavigationRegion2D/Door7.affect_navigation_mesh = false
			$DoorBuyable/db7.disabled = true
			$Spawners/OutdoorCubby.activated = true
			$Spawners/OutdoorFence.activated = true
		7:
			$Doors/StaticBody2D8.visible = false
			$Doors/StaticBody2D8.get_node("CollisionShape2D").disabled = true
			$NavigationRegion2D/Room7.affect_navigation_mesh = false
			$NavigationRegion2D/Door8.affect_navigation_mesh = false
			$DoorBuyable/db8.disabled = true
			$Spawners/Bunk.activated = true
		8:
			$Doors/StaticBody2D9.visible = false
			$Doors/StaticBody2D9.get_node("CollisionShape2D").disabled = true
			$NavigationRegion2D/Room3.affect_navigation_mesh = false
			$NavigationRegion2D/Room2.affect_navigation_mesh = false
			$NavigationRegion2D/Door9.affect_navigation_mesh = false
			$DoorBuyable/db9.disabled = true
			$Spawners/CRoom.activated = true
			$Spawners/Bunk.activated = true
		9:
			$Doors/StaticBody2D10.visible = false
			$Doors/StaticBody2D10.get_node("CollisionShape2D").disabled = true
			$NavigationRegion2D/Room1.affect_navigation_mesh = false
			$NavigationRegion2D/Room5.affect_navigation_mesh = false
			$NavigationRegion2D/Door10.affect_navigation_mesh = false
			$DoorBuyable/db10.disabled = true
			$Spawners/FirstCorridor.activated = true
			$Spawners/OutdoorCubby.activated = true
			$Spawners/OutdoorFence.activated = true
	$NavigationRegion2D.bake_navigation_polygon()

func _on_spawn_room_body_entered(body: Node2D) -> void:
	if body == Player:
		current_room = "Spawn Room"
		suitable_spawners = [$Spawners/SpawnRoom1, $Spawners/SpawnRoom2]
		roomchange.emit(current_room)

func _on_first_corridor_body_entered(body: Node2D) -> void:
	if body == Player:
		current_room = "First Corridor"
		suitable_spawners = [$Spawners/FirstCorridor, $Spawners/SpawnRoom1]
		roomchange.emit(current_room)

func _on_c_room_body_entered(body: Node2D) -> void:
	if body == Player:
		current_room = "C Room"
		suitable_spawners = [$Spawners/SpawnRoom2, $Spawners/CRoom, $Spawners/Bunk]
		roomchange.emit(current_room)

func _on_bunk_room_body_entered(body: Node2D) -> void:
	if body == Player:
		current_room = "Bunk Room"
		suitable_spawners = [$Spawners/Bunk, $Spawners/CRoom, $Spawners/SpawnRoom2]
		roomchange.emit(current_room)

func _on_power_room_body_entered(body: Node2D) -> void:
	if body == Player:
		current_room = "Power Room"
		suitable_spawners = [$Spawners/OutdoorFence, $Spawners/Bunk, $Spawners/SpawnRoom2]
		roomchange.emit(current_room)

func _on_the_great_outdoors_body_entered(body: Node2D) -> void:
	if body == Player:
		current_room = "The Great Outdoors"
		suitable_spawners = [$Spawners/OutdoorCubby, $Spawners/OutdoorFence, $Spawners/FirstCorridor]
		roomchange.emit(current_room)

func _on_hell_shed_body_entered(body: Node2D) -> void:
	if body == Player:
		current_room = "Hell Shed"
		suitable_spawners = [$Spawners/OutdoorCubby, $Spawners/OutdoorFence]
		roomchange.emit(current_room)

func _on_surprise_body_entered(body: Node2D) -> void:
	if body == Player:
		current_room = "Surprise!"
		suitable_spawners = [$Spawners/FirstCorridor, $Spawners/OutdoorCubby]
		roomchange.emit(current_room)

func _on_power_switch_body_entered(body: Node2D) -> void:
	if body == Player:
		powermessage.emit(true)

func _on_power_switch_body_exited(body: Node2D) -> void:
	if body == Player:
		powermessage.emit(false)

func _on_player_power_on() -> void:
	$"Power Switch".monitoring = false
