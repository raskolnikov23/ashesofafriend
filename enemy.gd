extends CharacterBody3D

@export var player : CharacterBody3D


enum {
	IDLE,
	ALERT,
	ROAMING
}

var state = IDLE
@onready var raycast = $RayCast3D # onready??
@onready var navagent = $NavigationAgent3D

func _ready():
	raycast.target_position.z = raylength
	
var raylength = -10
var collidedobject
var defalertbuffer = 1.0
var alertbuffer = defalertbuffer
var speed = 2
var defidletime = 2
var idletime = defidletime


#func _physics_process(delta):

	
	
func _process(delta):
	# raycast stuff
	if raycast.is_colliding():
		collidedobject = raycast.get_collider() as Node
		
		if collidedobject.name == "Player":
			state = ALERT
			print("Detected player, following")
			
	else: 
		collidedobject = null
		
		
	match state:
		IDLE:
			alertbuffer = defalertbuffer
			idletime -= delta
			
			if idletime <= 0:
				navagent.set_target_position(Vector3(randi_range(0,5), 0, randi_range(0,5)))
				print("I start to roam")
				state = ROAMING

		ROAMING:
			var nextnavpoint = navagent.get_next_path_position()			
			velocity = (nextnavpoint - global_transform.origin).normalized() * speed			
			move_and_slide()
			
			if navagent.is_navigation_finished():
				print("Roaming dst reached, going idle")
				state = IDLE
				idletime = defidletime
			 
		ALERT:
			# follow player
			navagent.set_target_position(player.global_transform.origin)
			var nextnavpoint = navagent.get_next_path_position()
			velocity = (nextnavpoint - global_transform.origin).normalized() * speed
			move_and_slide()
			look_at(Vector3(player.transform.origin.x, 1, player.transform.origin.z))
			
			# trigger timer if player lost
			if not collidedobject or collidedobject.name != "Player":
				alertbuffer -= delta
				if alertbuffer <= 0:
					alertbuffer = 0
					print("Player lost, going idle")
					state = IDLE # mos izsauc funkciju set_state(idle) prieks vienreizejiem calliem, lai var resetot alertbuffer
					idletime = defidletime

			
	#print(alertbuffer)
	#print(collidedobject)
	#print(rotation)
	

	
