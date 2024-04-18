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
	raycast.target_position.z = -10
	
const RAY_LENGTH = 1000
var collidedobject
var defalertbuffer = 1.0
var alertbuffer = defalertbuffer
var speed = 2


#func _physics_process(delta):

	
	
func _process(delta):
	# raycast stuff
	if raycast.is_colliding():
		collidedobject = raycast.get_collider() as Node
		
		if collidedobject.name == "Player":
			state = ALERT
			
	else: 
		collidedobject = null
		
		
	match state:
		IDLE:
			print("I am idle")
			alertbuffer = defalertbuffer
			# idle -> roam timer
				# when 0 -> set roampoint
		ROAMING:
			print("I am ROAMING")
			# navigate to roampoint
			# 
		ALERT:
			print("I am alert")
			
			
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
					print("Player lost!")
					state = IDLE # mos izsauc funkciju set_state(idle) prieks vienreizejiem calliem, lai var resetot alertbuffer

			
	#print(alertbuffer)
	#print(collidedobject)
	#print(rotation)
	

	
