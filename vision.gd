extends RayCast3D

var raylength = -50
var collidedobject
@onready var ui = $UI

func _ready():
	target_position.z = raylength

func _process(delta):
	if is_colliding():
		collidedobject = get_collider() as Node
		ui.text = str("Vision: ", collidedobject.name)
	else: 
		collidedobject = null
		ui.text = str("Vision: null")

