extends Control

# ughhgghhgghghhhhhhhhh
const dictionaire = {"4" : Vector2i(16,0), "0" : Vector2i(17,0), "1" : Vector2i(18,0), "2" : Vector2i(19,0)
	, "3" : Vector2i(20,0), "D" : Vector2i(21,0), "9" : Vector2i(16,1), "5" : Vector2i(17,1), "6" : Vector2i(18,1)
	, "7" : Vector2i(19,1), "8" : Vector2i(20,1), "A" : Vector2i(16,2), "B" : Vector2i(17,2), "C" : Vector2i(18,2)}
var atlas_coords = Vector2i(16,0)
var mode = 0
var holdy = false
var blaring_out_loud = false
var muted = false

func _ready() -> void:
	toggler(0)
	if FileAccess.file_exists("user://map.shovel"):
		$TextEdit.text = FileAccess.get_file_as_string("user://map.shovel")
		_on_import_button_pressed()
	if FileAccess.file_exists("user://muted.shovel"):
		var file = FileAccess.open("user://muted.shovel",FileAccess.READ)
		_on_mute_button_toggled(bool(file.get_8()))
		file.close()
	blaring_out_loud = true
	
func _process(_delta: float) -> void:
	$TextureRect.position = $TileMapLayer.local_to_map($TileMapLayer.get_local_mouse_position()) * 32 - Vector2i(8,0)
	if holdy and $TextureRect.visible:
		if mode == 0:
			$TileMapLayer.set_cell($TileMapLayer.local_to_map($TileMapLayer.get_local_mouse_position()),0,atlas_coords)
		elif mode == 1:
			$TileMapLayer.set_cell($TileMapLayer.local_to_map($TileMapLayer.get_local_mouse_position()),0,Vector2i(21,0))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			mode = 0
		elif event.button_index == 2:
			mode = 1
		elif event.button_index == 3:
			mode = 2
		if event.pressed and $TextureRect.visible:
			holdy = true
		else:
			holdy = false
		if not event.pressed and $TextureRect.visible:
			_on_export_button_pressed()

# if there's a better way of doing this you can stone me to death pretty please
func toggler(which_one : int) -> void:
	if not muted and blaring_out_loud:
		$AudioChange.play()
	var bleh : Array
	for i in range(14):
		bleh.insert(i,false)
	bleh[which_one] = true
	$TileButton.button_pressed = bleh[0]
	$TileButton2.button_pressed = bleh[1]
	$EraserButton.button_pressed = bleh[2]
	$TileButton3.button_pressed = bleh[3]
	$TileButton4.button_pressed = bleh[4]
	$TileButton5.button_pressed = bleh[5]
	$TileButton6.button_pressed = bleh[6]
	$TileButton7.button_pressed = bleh[7]
	$TileButton8.button_pressed = bleh[8]
	$TileButton9.button_pressed = bleh[9]
	$TileButton10.button_pressed = bleh[10]
	$TileButton11.button_pressed = bleh[11]
	$TileButton12.button_pressed = bleh[12]
	$TileButton13.button_pressed = bleh[13]

func _on_tile_button_pressed() -> void:
	toggler(0)
	atlas_coords = Vector2i(16,0)
func _on_tile_button_2_pressed() -> void:
	toggler(1)
	atlas_coords = Vector2i(17,0)
func _on_eraser_button_pressed() -> void:
	toggler(2)
	atlas_coords = Vector2i(21,0)
func _on_tile_button_3_pressed() -> void:
	toggler(3)
	atlas_coords = Vector2i(18,0)
func _on_tile_button_4_pressed() -> void:
	toggler(4)
	atlas_coords = Vector2i(19,0)
func _on_tile_button_5_pressed() -> void:
	toggler(5)
	atlas_coords = Vector2i(20,0)
func _on_tile_button_6_pressed() -> void:
	toggler(6)
	atlas_coords = Vector2i(16,1)
func _on_tile_button_7_pressed() -> void:
	toggler(7)
	atlas_coords = Vector2i(17,1)
func _on_tile_button_8_pressed() -> void:
	toggler(8)
	atlas_coords = Vector2i(18,1)
func _on_tile_button_9_pressed() -> void:
	toggler(9)
	atlas_coords = Vector2i(19,1)
func _on_tile_button_10_pressed() -> void:
	toggler(10)
	atlas_coords = Vector2i(20,1)
func _on_tile_button_11_pressed() -> void:
	toggler(11)
	atlas_coords = Vector2i(16,2)
func _on_tile_button_12_pressed() -> void:
	toggler(12)
	atlas_coords = Vector2i(17,2)
func _on_tile_button_13_pressed() -> void:
	toggler(13)
	atlas_coords = Vector2i(18,2)

func _on_reference_rect_mouse_entered() -> void:
	$TextureRect.visible = true
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)

func _on_reference_rect_mouse_exited() -> void:
	$TextureRect.visible = false
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)

func _on_export_button_pressed() -> void:
	if not muted:
		$AudioDull.play()
	var bleh : Array
	for j in range(13):
		for i in range(13):
			var clicked_cell = Vector2i(i+1,j+1)
			var data = $TileMapLayer.get_cell_tile_data(clicked_cell)
			bleh.append(data.get_custom_data("hexen"))
		bleh.append("D")
	var stingy_string : String
	for l in bleh.size():
		stingy_string = stingy_string + bleh[l]
	$TextEdit.text = stingy_string
	var file = FileAccess.open("user://map.shovel",FileAccess.WRITE)
	file.store_string($TextEdit.text)
	file.close()

# same as the toggler function
func _on_import_button_pressed() -> void:
	var array_of_death : Array
	var stingy_string : String = $TextEdit.text
	var busted : bool = false
	var previous_tilemap = $TileMapLayer.tile_map_data
	if stingy_string.length() == 182 or stingy_string.length() == 272:
		if stingy_string.length() == 272:
			stingy_string = stingy_string.replace(" ", '')
		for p in range(13):
			array_of_death.append(14+p*14-1)
		for o in array_of_death.size():
			stingy_string[array_of_death[o]] = "Æ"
		stingy_string = stingy_string.replace("Æ", '')
		for j in range(13):
			for i in range(13):
				if dictionaire.has(stingy_string[i+j*13]):
					$TileMapLayer.set_cell(Vector2i(i+1,j+1),0,dictionaire[stingy_string[i+j*13]])
				else:
					busted = true
					pass
		if not busted:
			if blaring_out_loud:
				if not $TileMapLayer.tile_map_data == previous_tilemap:
					$ErrorLabel.text = "MAP SUCCESSFULLY IMPORTED"
					$Timer.start()
					if not muted:
						$AudioSuccess.play()
				else:
					$ErrorLabel.text = "MAP ALREADY IMPORTED"
					$Timer.start()
					if not muted:
						$AudioDull.play()
		else:
			$ErrorLabel.text = "INVALID CHARACTERS FOUND"
			$Timer.start()
			if not muted:
				$AudioInvalid.play()
			$TileMapLayer.tile_map_data = previous_tilemap
	else:
		$ErrorLabel.text = "INVALID LENGTH"
		$Timer.start()
		if not muted:
			$AudioInvalid.play()

func _on_stage_box_value_changed(value: int) -> void:
	if not muted:
		$AudioCount.play()
	$StageBox/Label.text = "%X" % (12426 + (value - 1) * 91)

func _on_clipboard_button_pressed() -> void:
	if not muted:
		$AudioSuccess.play()
	$ErrorLabel.text = "COPIED MAP TO CLIPBOARD"
	$Timer.start()
	DisplayServer.clipboard_set($TextEdit.text)

func _on_timer_timeout() -> void:
	$ErrorLabel.text = ""

func _on_mute_button_toggled(toggled_on: bool) -> void:
	# nasty
	if toggled_on:
		$MuteButton.texture_normal = $MuteButton.texture_pressed
	else:
		$MuteButton.texture_normal = $MuteButton.texture_disabled
	muted = toggled_on
	if !toggled_on and blaring_out_loud:
		$AudioSuccess.play()
	else:
		$AudioSuccess.stop()
	var file = FileAccess.open("user://muted.shovel",FileAccess.WRITE)
	file.store_8(int(toggled_on))
	file.close()

# SCALING HELL YEAH!!!
func _on_resized() -> void:
	var current_width = self.size.x / 640
	var current_height = self.size.y / 480
	if current_height < current_width:
		$Camera2D.zoom = Vector2(current_height,current_height)
	else:
		$Camera2D.zoom = Vector2(current_width,current_width)
	if self.size.x < 480 or self.size.y < 360:
		$ErrorLabel.text = "GET A BETTER MONITOR"
		$Timer.start()
