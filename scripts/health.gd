class_name Health
extends Node

@onready var ui = $UI

var maxhealth : float = 100
var health = maxhealth
#func _ready():
	#get_node("Label").text = "aaaaa"
	#print(ui.)

func _process(delta):
	ui.text = str("HP: ", health)

func gethealth():
	return health
	
func modifyhealth(value):
	
	if health + value <= 0:
		health = 0
		print("Player is dead")
		return
		
	health += value
	health = clamp(health, 0, 100)
	
	print("Health is now ", health)
