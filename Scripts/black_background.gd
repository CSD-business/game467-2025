extends Sprite2D
@export var transition_time : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fade_transition():
	show()
	Global.in_menu = true
	$AnimationPlayer.play("Fade2Black")
	#for i in range(100):
		#print(i)
		#modulate.a = i/100
		#await get_tree().create_timer(transition_time/100).timeout
	await get_tree().create_timer(1).timeout
	#for i in range(100):
		#print(i)
		#modulate.a = 1-(i/100)
		#await get_tree().create_timer(transition_time/100).timeout
	$AnimationPlayer.play("Fade2Clear")
	Global.in_menu = false
	hide()
