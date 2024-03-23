extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hide_slowly():
	var tween = create_tween()
	var text = $Label

	tween.tween_property(text, "modulate",Color.TRANSPARENT, 1)

func show_slowly():
	var tween = create_tween()
	var text = $Label

	tween.tween_property(text, "modulate",Color.ALICE_BLUE, 1)
