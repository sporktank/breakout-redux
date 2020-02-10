extends KinematicBody2D


var colour = null


func setup(position, colour):
    self.position = position
    self.colour = colour
    $BluePowerUp.visible = colour == 'blue'
    $GreenPowerUp.visible = colour == 'green'
    $PurplePowerUp.visible = colour == 'purple'
    $RedPowerUp.visible = colour == 'red'
    
    
#func _process(delta):
#    self.position.y += 200*delta
#    self.rotation += 2*PI * delta
func _physics_process(delta):
    
    self.rotation += 2*PI * delta
    
    var collision = move_and_collide(Vector2(0, 200) * delta)
    if collision:
        collision.collider.get_powerup(self)
        self.queue_free()
    