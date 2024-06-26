extends TileMap


var i_0 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1)]
var i_90 := [Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2), Vector2i(2, 3)]
var i_180 := [Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2)]
var i_270 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(1, 3)]
var i := [i_0, i_90, i_180, i_270]

var j_0 = [Vector2i(0,0), Vector2i(0, 1), Vector2i(1,1), Vector2i(2,1)]
var j_90 := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 1), Vector2i(1, 2)]
var j_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)]
var j_270 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 2), Vector2i(1, 2)]
var j := [j_0, j_90, j_180, j_270]

var t_0 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var t_90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var t_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var t_270 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
var t := [t_0, t_90, t_180, t_270]

var l_0 := [Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var l_90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)]
var l_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2)]
var l_270 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2)]
var l := [l_0, l_90, l_180, l_270]

var s_0 := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1)]
var s_90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)]
var s_180 := [Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2), Vector2i(1, 2)]
var s_270 := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
var s := [s_0, s_90, s_180, s_270]

var z_0 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1)]
var z_90 := [Vector2i(2, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var z_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)]
var z_270 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(0, 2)]
var z := [z_0, z_90, z_180, z_270]

var o_0 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o_90 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o_180 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o_270 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o := [o_0, o_90, o_180, o_270]

var shapes = [i, j, l, s, z, o, t]
var shapes_full = shapes.duplicate()

const ROW:int = 20
const COL:int = 10

#movement variables
const directions := [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.DOWN]
var steps := [0, 0, 0]
const steps_req : int = 100
const start_pos := Vector2i(5, 1)
var cur_pos : Vector2i
var ghost_cur_pos : Vector2i
var speed = 1
const ACCEL : float = 0.05


#game variables
var line_clear : int
var score : int
var highest_score: int
var game_running : bool
var main_menu_running: bool
var is_pause_avail : bool
var is_block_change_used = false
var left_pressed = false
var right_pressed = false
var audio_ins
const SAVEFILE = "user://tetris_save.dat"



#game variables
var piece_type
var next_piece_type
var stash_piece_type
var ghost_piece:Array
var rotation_index : int = 0
var active_piece:Array

#tilemap variables
var tile_id: int = 1
var ghost_tile_id: int = 0
var piece_atlas:Vector2i
var next_piece_atlas:Vector2i
var ghost_piece_atlas:Vector2i
var stash_piece_atlas:Vector2i

#layer variables
var board_layer : int = 1
var active_layer : int = 2
var ghost_layer : int= 0



func _ready():
	main_menu_running = true
	is_pause_avail = false
	load_score()
	audio_ins = get_node("Audio")


func _input(event):
	if event.is_action_pressed("restart") and game_running:
			save_score()
			game_over()
	#pause function is buggy
	#if event.is_action_pressed("pause") and is_pause_avail:
	#		pause_game()

func _process(delta):
	if game_running:
		if Input.is_action_just_pressed("ui_up"):
			rotate_piece()
			audio_ins.rotate_sound()
		if Input.is_action_just_pressed("change_block"):
			stash_block()
			
		if Input.is_action_just_pressed("land_instant"):
			land_instant()
			audio_ins.land_instant_sound()
		
		

		#This 2 block of conditions let us move the blocks 1 pixel before it moves continuesly.
		if Input.is_action_just_pressed("ui_left"):
			if not left_pressed:  
				left_pressed = true
				move_piece(Vector2i.LEFT)
				await get_tree().create_timer(0.1).timeout
				left_pressed = false
				audio_ins.move_sound()

		if Input.is_action_just_pressed("ui_right"):
			if not right_pressed:  
				right_pressed = true
				move_piece(Vector2i.RIGHT)
				await get_tree().create_timer(0.1).timeout
				right_pressed = false
				audio_ins.move_sound()

		
		#Makes blocks move continuesly
		if not left_pressed and Input.is_action_pressed("ui_left"):
			steps[0] += 20
		if not right_pressed and Input.is_action_pressed("ui_right"):
			steps[1] += 20
		if Input.is_action_pressed("ui_down"):
			steps[2] += 20

		steps[2] += speed


		#move the pieces if requirement 'steps' condition is met
		for ii in range(steps.size()):
			if steps[ii] >= steps_req:
				move_piece(directions[ii])
				move_ghost_piece_hor(Vector2i.DOWN)
				steps[ii] = 0
		move_ghost_piece_down()
	elif main_menu_running:
		if Input.is_action_just_pressed("land_instant"):
			start_game()
			main_menu_running = false






#game functions
func new_game():
	
	game_running = true
	score = 0
	speed = 1
	steps = [0, 0, 0]

	clean_panel()
	clear_piece()
	clean_stash_panel()

	stash_piece_type = null
	piece_type = pick_piece()
	next_piece_type = pick_piece()
	piece_atlas = Vector2i(shapes_full.find(piece_type) , 0)
	next_piece_atlas = Vector2i(shapes_full.find(next_piece_type), 0)
	ghost_piece_atlas = Vector2i(0, 1)
	load_score()
	
	create_piece()
	$Audio/Korobeiniki.play()
	is_pause_avail = true
	
func start_game():
	var main_menu := $MainMenu
	$Audio/Splash.play()
	main_menu.hide_slowly()
	await get_tree().create_timer(1).timeout

	#cleaning the grass for blocks
	for ii in range(ROW):
		await get_tree().create_timer(0.05).timeout
		$Audio/LandSoft.play()
		for jj in range(COL):
			erase_cell(board_layer, Vector2i(jj + 1, ii + 1))

		
	new_game()

func pause_game():
	if game_running:
		game_running = false
		$Audio/Korobeiniki.stop()
		
	else:
		game_running = true
		$Audio/Korobeiniki.play()
	




#drawing
func draw_piece(piece, pos, atlas, tile_id_given, layer):
	for ii in piece:
		set_cell(layer, pos + ii, tile_id_given, atlas)

func set_board_layer():
	for ii in active_piece:
		erase_cell(active_layer, cur_pos + ii)
		set_cell(board_layer, cur_pos + ii, tile_id, piece_atlas)



#pick and create piece
func pick_piece():
	var piece
	if not shapes.is_empty():
		shapes.shuffle()
		piece = shapes.pop_front()
	else:
		shapes = shapes_full.duplicate()
		shapes.shuffle()
		piece = shapes.pop_front()
	return piece

func create_piece():
	
	steps = [0, 0 , 0]
	cur_pos = start_pos
	ghost_cur_pos = cur_pos
	active_piece = piece_type[0]
	ghost_piece = active_piece
	draw_piece(active_piece, start_pos, piece_atlas, tile_id, active_layer)
	#
	draw_piece(next_piece_type[0], Vector2i(15, 4), next_piece_atlas, tile_id, active_layer)
	


#ghost functions
func move_ghost_piece_down():
	for ii in ghost_piece:
			erase_cell(ghost_layer, ghost_cur_pos + ii)
	ghost_cur_pos = cur_pos
	while can_move(Vector2i.DOWN, ghost_cur_pos, ghost_piece):
		ghost_cur_pos += Vector2i.DOWN
	
	draw_piece(ghost_piece, ghost_cur_pos, ghost_piece_atlas, ghost_tile_id, ghost_layer)

func move_ghost_piece_hor(dir):
	for ii in ghost_piece:
		erase_cell(ghost_layer, ghost_cur_pos + ii)
	if can_move(dir, ghost_cur_pos, ghost_piece):
		ghost_cur_pos += dir

	draw_piece(ghost_piece, ghost_cur_pos, ghost_piece_atlas, ghost_tile_id, ghost_layer)
	




#moving piece functions
func move_piece(dir):
	if can_move(dir, cur_pos, active_piece):
		clear_piece()
		cur_pos+=dir
		draw_piece(active_piece,cur_pos, piece_atlas, tile_id, active_layer)
	else:
		if dir == Vector2i.DOWN:
			await get_tree().create_timer(0.5).timeout #It is buggy: Works on firts land, doesn't on others
			if !can_move(dir, cur_pos, active_piece):
				audio_ins.land_soft_sound()
				land_piece()
	
func shift_row(row):
	var atlas
	while row > 1:
		for col in range(COL):
			atlas = get_cell_atlas_coords(board_layer, Vector2i(col + 1, row - 1))
			if is_free(atlas):
				erase_cell(board_layer, Vector2i(col + 1, row))
				erase_cell(ghost_layer,Vector2i(col + 1, row))
			else:
				set_cell(board_layer, Vector2i(col + 1, row), tile_id, atlas)
		row-=1
	
func rotate_piece():
	print("Fonksiyona girildi")
	if can_rotate():
		print("Dönebilir")
		clear_piece()
		for ii in ghost_piece:
			erase_cell(ghost_layer, ghost_cur_pos + ii)
		rotation_index = (rotation_index + 1) % 4
		active_piece = piece_type[rotation_index]
		ghost_piece = active_piece
	else:
		$Audio/CantRotate.play()
		

	draw_piece(active_piece, cur_pos, piece_atlas, tile_id, active_layer)
	print("Döndü %s" % str(rotation_index))
	draw_piece(ghost_piece, ghost_cur_pos, ghost_piece_atlas, ghost_tile_id, ghost_layer)


#landing and pointing

func land_piece():
		set_board_layer()
		#show_gained_point("TETRIS!\n 2000")
		check_rows()


		rotation_index = 0
		piece_type = next_piece_type
		piece_atlas = next_piece_atlas
		next_piece_type = pick_piece()
		next_piece_atlas = Vector2i(shapes_full.find(next_piece_type), 0)
		is_block_change_used = false
		clean_panel()
		create_piece()
		check_game_over()
		
func land_instant():
	while(can_move(Vector2i.DOWN, cur_pos, active_piece)):
		move_piece(Vector2i.DOWN)
	land_piece()
	
func check_rows():
	var row = ROW
	
	while row > 0:
		var count = 0
		for ii in range(COL):
			if not is_free(Vector2i(ii + 1, row)):
				count+=1
		if count == COL:
			
			shift_row(row)
			$Audio/Splash.play()
			line_clear += 1
			if speed < 20:
				speed += ACCEL
			
		else:
			row -= 1
	score += calculate_line_clear()
	save_score()
	load_score()
	$CanvasLayer/Score.text = "Score:\n    %s" % [  score]

func calculate_line_clear():
	var reward = 0

	if line_clear == 1:
		reward = 100
		Global.camera.shake(0.3,5)
		show_gained_point("SINGLE\n 100")
	elif line_clear == 2:
		reward = 400
		Global.camera.shake(0.3,7)
		show_gained_point("DOUBLE\n 400")
	elif line_clear == 3:
		reward = 900
		Global.camera.shake(0.3,8)
		show_gained_point("TRIPLE\n 900")
	elif line_clear == 4:
		Global.camera.shake(0.3,10)
		reward = 2000
		show_gained_point("TETRIS\n 2000")
	
	line_clear = 0
	return reward








#check section
func can_move(dir, pos, active_or_ghost_piece):
	var result = true
	for ii in active_or_ghost_piece:
		if not is_free( ii + pos + dir):
			result = false
	return result

func can_rotate():
	var cr = true
	var temp_rotation_index = (rotation_index + 1) % 4
	for ii in piece_type[temp_rotation_index]:
		if not is_free(cur_pos + ii):
			cr = false
	return cr

func is_free(pos):
	return get_cell_source_id(board_layer, pos) == -1




#cleaning
func clean_panel():
	for ii in range(14, 19):
				for jj in range(3, 7):
					erase_cell(active_layer, Vector2i(ii, jj))

func clean_stash_panel():
	for ii in range(10, 20):
				for jj in range(10, 20):
					erase_cell(active_layer, Vector2i(ii, jj))

func clear_board():
	for ii in range(ROW):
		for jj in range(COL):
			erase_cell(board_layer, Vector2i(jj + 1, ii + 1)) 

func clear_piece():
	for ii in active_piece:
		erase_cell(active_layer, cur_pos + ii)

#I use stash_block func instead of change_block
func change_block():
	if !is_block_change_used:
		var temp_piece_type = piece_type
		var temp_piece_atlas = piece_atlas
		piece_type = next_piece_type
		piece_atlas = next_piece_atlas

		next_piece_type = temp_piece_type
		next_piece_atlas = temp_piece_atlas

		is_block_change_used = true

		clean_panel()
		clear_piece()

		create_piece()

func stash_block():
	if !is_block_change_used:
		var temp_piece_type = piece_type
		var temp_piece_atlas = piece_atlas
		for ii in ghost_piece:
				erase_cell(ghost_layer, ghost_cur_pos + ii)

		if stash_piece_type == null:
			
			print("girdim")
			piece_type = next_piece_type
			piece_atlas = next_piece_atlas

			next_piece_type = pick_piece()
			next_piece_atlas = Vector2i(shapes_full.find(next_piece_type), 0)
		else:
			piece_type = stash_piece_type
			piece_atlas = stash_piece_atlas

		stash_piece_type = temp_piece_type
		stash_piece_atlas = temp_piece_atlas


		clean_stash_panel()
		draw_piece(stash_piece_type[0], Vector2i(15, 15), stash_piece_atlas, tile_id, active_layer)

		is_block_change_used = true



		$Audio/Stash.play()

		clean_panel()
		clear_piece()

		create_piece()

#gameover
func game_over():
	game_running = false
	is_block_change_used = false
	set_board_layer()

	clean_panel()
	clean_stash_panel()

	save_score()
	$Audio/Korobeiniki.stop()
	$Audio/GameOver.play()
	show_you_died()

func check_game_over():
	for ii in active_piece:
		if not is_free(ii + cur_pos + Vector2i.DOWN):
			game_over()

#UI
func show_gained_point(point_msg):
	var msg = $CanvasLayer/PointGained
	msg.text = point_msg
	msg.scale = Vector2(0.2, 0.2)
	msg.position.y = 384
	msg.visible = true
	var tween = create_tween()
	tween.tween_property(msg, 'position', Vector2(msg.position.x, 288), 0.3)
	tween.parallel().tween_property(msg, 'scale', Vector2(1, 1), 0.3)
	tween.tween_property(msg, 'scale', Vector2(0.2, 0.2), 0.3)
	await tween.finished
	#await get_tree().create_timer(0.1).timeout
	msg.visible = false
	msg.scale = Vector2(0.2, 0.2)

func show_you_died():
	var black_template = $CanvasLayer/Panel
	var you_died = $CanvasLayer/Panel/YouDied
	black_template.visible = true
	var tween = create_tween()

	tween.tween_property(black_template, "modulate", Color.ALICE_BLUE,0.5)
	tween.tween_property(you_died, "modulate",Color.ALICE_BLUE, 1)
	tween.tween_interval(3.5)
	tween.tween_property(black_template, "modulate", Color.TRANSPARENT,1)
	tween.parallel().tween_property(you_died, "modulate",Color.TRANSPARENT, 1)
	await tween.finished

	for ii in range(ROW):
		await get_tree().create_timer(0.05).timeout
		$Audio/LandSoft.play()
		for jj in range(COL):
			set_cell(board_layer, Vector2i(jj + 1, ii + 1), 7, Vector2i(1, 1)) 

	await get_tree().create_timer(1).timeout

	var main_menu := $MainMenu
	main_menu.show_slowly()


	#part that main_menu become active
	main_menu_running = true
	#clear ghosts
	for ii in range(ROW):
		for jj in range(COL):
			erase_cell(ghost_layer, Vector2i(jj + 1, ii + 1)) 


#save&load
func save_score():
	if score > highest_score:
		var file = FileAccess.open(SAVEFILE, FileAccess.WRITE_READ)
		file.store_32(score)

func load_score():
	var file = FileAccess.open(SAVEFILE, FileAccess.READ)
	if FileAccess.file_exists(SAVEFILE):
		highest_score = file.get_32()
		$CanvasLayer/Record.text = "Record: " + str(highest_score)
