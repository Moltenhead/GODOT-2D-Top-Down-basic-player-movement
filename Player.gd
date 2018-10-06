extends KinematicBody2D

""" -------- DECLARATION -------- """
#input and direction
var horizontal_input
var vertical_input
var direction = Vector2()

#spacial speed
var horizontal_speed
var vertical_speed
var speed = Vector2()

#velocity vectors
var velocity = Vector2()
var delta_velocity = Vector2()

#speed managers
var max_speed = 10
var speed_multiplier = 1000
var true_max_speed = max_speed * speed_multiplier

#acceleration/deceleration lerping weight
const ACCEL_WEIGHT = .3

""" -------- FUNCTIONS -------- """
#initialize variables
func _ready():
	horizontal_input = 0
	vertical_input = 0
	
	horizontal_speed = 0;
	vertical_speed = 0;
	pass

#executed each frame
func _physics_process(delta):
	#boolean returning if any moving key is pressed
	var is_moving = Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left")
	
	""" Movement manager
	"    if is_moving
	"      then modify speed and inputs depending on player's request
	"    else
	"     conserve last direction inputs from the player and lerp speed to 0
	"""
	if is_moving:
		horizontal_input = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		vertical_input = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
		
		horizontal_speed = lerp(horizontal_speed, abs(horizontal_input), ACCEL_WEIGHT)
		vertical_speed = lerp(vertical_speed, abs(vertical_input), ACCEL_WEIGHT)
	else:
		horizontal_speed = lerp(horizontal_speed, 0, ACCEL_WEIGHT)
		vertical_speed = lerp(vertical_speed, 0, ACCEL_WEIGHT)
	
	""" Direction and speed vectors assignement
	"    normalizing the direction vector to avoid diagonal super speed
	"    and creating a speed vector with both "spacialized" speed ; x and y axis
	"""
	direction = Vector2(horizontal_input, vertical_input).normalized()
	speed = Vector2(horizontal_speed, vertical_speed)
	
	#multiplying valors to get velocity vectors
	velocity = direction * speed
	delta_velocity = true_max_speed * velocity * delta
	
	#applying the needed vector to the object, to make it move thanks to the move_and_slide function
	move_and_slide(delta_velocity)
	pass
