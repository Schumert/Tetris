extends Node

@export var button:Button
@export var button2:Button
var bus_index_music:int = 1
var bus_index_fx:int = 2

var is_music_stop = false
var is_fx_stop = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func mute_play_background():
	if is_music_stop:
		#$Korobeiniki.volume_db = -20
		AudioServer.set_bus_volume_db(bus_index_music, 0)
		is_music_stop = false
		button.release_focus()
	else:
		#$Korobeiniki.volume_db = -80
		AudioServer.set_bus_volume_db(bus_index_music, -80)
		is_music_stop = true
		button.release_focus()

func mute_fx():
	if is_fx_stop:
		AudioServer.set_bus_volume_db(bus_index_fx, 0)
		is_fx_stop = false
		button2.release_focus()
	else:
		AudioServer.set_bus_volume_db(bus_index_fx, -80)
		is_fx_stop = true
		button2.release_focus()


func move_sound():
	if not $Move.is_playing():
		$Move.play()
func rotate_sound():
	if not $Rotate.is_playing():
		$Rotate.play()
func land_instant_sound():
	$LandInstant.play()
func land_soft_sound():
	$LandSoft.play()
func cant_rotate_sound():
	$CantRotate.play()
func game_over_sound():
	$GameOver.play()
