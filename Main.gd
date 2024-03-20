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

const ROW:int = 20
const COL:int = 10

#movement variables
const directions := [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.DOWN]
var steps := [0, 0, 0]
const steps_req : int = 50
const start_pos := Vector2i(5, 1)
var cur_pos : Vector2i
const ACCEL : float = 0.01

var line_clear : int
var score : int
var game_running : bool

var piece_type
var next_piece_type
var stash_piece_type
var rotation_index : int = 0
var active_piece:Array

var tile_id: int = 1
var piece_atlas:Vector2i
var next_piece_atlas:Vector2i
var stash_piece_atlas:Vector2i

var board_layer : int = 0
var active_layer : int = 1

var shapes = [i, j, l, s, z, o]
var shapes_full = shapes.duplicate()

var is_block_change_used = false


func _ready():
	new_game()
	print(pick_piece())

func _process(delta):
	#if Input.is_action_pressed("ui_left"):
	#	steps[0] += 5
	#if Input.is_action_pressed("ui_right"):
	#	steps[1] += 5
	#if Input.is_action_pressed("ui_down"):
	#	steps[2] += 5
	if Input.is_action_just_pressed("ui_up"):
		rotate_piece()
	if Input.is_action_just_pressed("change_block"):
		stash_block()
	if Input.is_action_just_pressed("land_instant"):
		land_instant()


	
	

	#steps[2] += speed
	#move the piece
	#for ii in range(steps.size()):
	#	if steps[ii] >= steps_req:
	#		move_piece(directions[ii])
	#		steps[ii] = 0

func _input(event):
	if Input.is_action_pressed("ui_left"):
		move_piece(Vector2i.LEFT)
	if Input.is_action_pressed("ui_right"):
		move_piece(Vector2i.RIGHT)
	if Input.is_action_pressed("ui_down"):
		move_piece(Vector2i.DOWN)



func on_time_out():
	move_piece(Vector2i.DOWN)

func land_instant():
	clear_piece()
	while(can_move(Vector2i.DOWN)):
		move_piece(Vector2i.DOWN)


func new_game():
	piece_type = pick_piece()
	next_piece_type = pick_piece()
	piece_atlas = Vector2i(shapes_full.find(piece_type) , 0)
	next_piece_atlas = Vector2i(shapes_full.find(next_piece_type), 0)
	score = 0
	create_piece()


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
	active_piece = piece_type[0]
	draw_piece(active_piece, start_pos, piece_atlas)
	#
	draw_piece(next_piece_type[0], Vector2i(15, 4), next_piece_atlas)
		


var is_landed = false
func move_piece(dir):
	if can_move(dir):
		clear_piece()
		cur_pos+=dir
		draw_piece(active_piece,cur_pos, piece_atlas)
		is_landed = false
	else:
		if dir == directions[2] and is_landed == false:
			is_landed = true
			#needs polishing
			while is_landed:
				await get_tree().create_timer(0.5).timeout
				if !can_move(dir):
					print("landed")
					land_piece()
					check_rows()
					piece_type = next_piece_type
					piece_atlas = next_piece_atlas
					next_piece_type = pick_piece()
					next_piece_atlas = Vector2i(shapes_full.find(next_piece_type), 0)
					is_block_change_used = false
					clean_panel()
					create_piece()
				else:
					is_landed = false
			
			




func check_rows():
	var row = ROW
	while row > 0:
		var count = 0
		for ii in range(COL):
			if not is_free(Vector2i(ii + 1, row)):
				count+=1
		if count == COL:
			shift_row(row)
			line_clear += 1
			if $Timer.wait_time >= 0.09:
				$Timer.wait_time -= ACCEL
			
		else:
			row -= 1
	score += calculate_line_clear()
	$CanvasLayer/Score.text = "Score: %s" % [score]
func calculate_line_clear():
	var reward = 0

	if line_clear == 1:
		reward = 100
	elif line_clear == 2:
		reward = 400
	elif line_clear == 3:
		reward = 900
	elif line_clear == 4:
		reward = 2000
	
	line_clear = 0
	return reward

func shift_row(row):
	var atlas
	while row > 1:
		for col in range(COL):
			atlas = get_cell_atlas_coords(board_layer, Vector2i(col + 1, row - 1))
			if is_free(atlas):
				erase_cell(board_layer, Vector2i(col + 1, row))
			else:
				set_cell(board_layer, Vector2i(col + 1, row), tile_id, atlas)
		row-=1

func can_move(dir):
	var result = true
	for ii in active_piece:
		if not is_free( ii + cur_pos + dir):
			result = false
	return result


func land_piece():
	for ii in active_piece:
		erase_cell(active_layer, cur_pos + ii)
		set_cell(board_layer, cur_pos + ii, tile_id, piece_atlas)


func rotate_piece():
	if can_rotate():
		clear_piece()
		rotation_index = (rotation_index + 1) % 4
		active_piece = piece_type[rotation_index]
		draw_piece(active_piece, cur_pos, piece_atlas)

func can_rotate():
	var cr = true
	var temp_rotation_index = (rotation_index + 1) % 4
	for ii in piece_type[temp_rotation_index]:
		if not is_free(ii + cur_pos):
			cr = false
	return cr

func clear_piece():
	for ii in active_piece:
		erase_cell(active_layer, cur_pos + ii)

func is_free(pos):
	return get_cell_source_id(board_layer, pos) == -1

func draw_piece(piece, pos, atlas):
	for ii in piece:
		set_cell(active_layer, pos + ii, tile_id, atlas)

func clean_panel():
	for ii in range(14, 19):
				for jj in range(3, 7):
					erase_cell(active_layer, Vector2i(ii, jj))

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

		if stash_piece_type == null:


			piece_type = next_piece_type
			piece_atlas = next_piece_atlas

			next_piece_type = pick_piece()
			next_piece_atlas = Vector2i(shapes_full.find(next_piece_type), 0)
		else:
			piece_type = stash_piece_type
			piece_atlas = stash_piece_atlas

		stash_piece_type = temp_piece_type
		stash_piece_atlas = temp_piece_atlas


		for ii in range(10, 20):
				for jj in range(10, 20):
					erase_cell(active_layer, Vector2i(ii, jj))
		draw_piece(stash_piece_type[0], Vector2i(15, 15), stash_piece_atlas)

		
		

		is_block_change_used = true

		clean_panel()
		clear_piece()

		create_piece()


