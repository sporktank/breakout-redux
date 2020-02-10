extends KinematicBody2D


var base_powerup = preload("res://PowerUp.tscn")

var colour = null
var is_alive = true


func _ready():
    pass


func _process(delta):
    if not self.is_alive:
        self.modulate.a -= 3*delta
        if self.modulate.a < 0:
            get_parent().remove_child(self)
            queue_free() 


func setup(colour):
    self.colour = colour
    $BlueBrick.visible = colour == 'blue'
    $GreenBrick.visible = colour == 'green'
    $GreyBrick.visible = colour == 'grey'
    $PurpleBrick.visible = colour == 'purple'
    $RedBrick.visible = colour == 'red'


func hit(possible_powerup):
    if self.colour == 'grey':
        return
        
    self.is_alive = false
    $CollisionShape2D.disabled = true
    
    if possible_powerup and randf() < 0.2:
        var power_up = base_powerup.instance()
        power_up.setup(self.position, self.colour)
        # This is hacky, better learn proper way with signals etc. for the future.
        get_parent().get_parent().get_node('PowerUps').add_child(power_up)
