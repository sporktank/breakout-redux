extends KinematicBody2D


enum {STATE_ON_PADDLE, STATE_NORMAL, STATE_CANNON}


var speed = 400
var velocity = Vector2()
var state = STATE_ON_PADDLE
var paddle = null
var action = null
var cannon_count = 0.0


#func _ready():
#    #rotation = -PI/4
#    #velocity = Vector2(speed, 0).rotated(rotation)
#    #velocity = Vector2(0, -speed)
#    velocity = Vector2(0, -speed).rotated(-PI/8 + PI/4*randf())
#    #$GreyBall.visible = false


func setup(paddle, action, level_num):
    self.paddle = paddle
    self.action = action
    self.speed = 400 + level_num*15


func make_cannon():
    self.cannon_count = 1.0
    self.state = STATE_CANNON
    $BlueBall.visible = false
    $GreyBall.visible = true


func clone():
    var b = load('res://Ball.tscn').instance()
    b.speed = self.speed
    b.position = self.position
    b.velocity = self.velocity
    b.paddle = self.paddle
    b.action = self.action
    b.state = self.state
    b.cannon_count = self.cannon_count
    b.get_node('GreyBall').visible = $GreyBall.visible
    b.get_node('BlueBall').visible = $BlueBall.visible
    return b


func _physics_process(delta):
    
    if state == STATE_ON_PADDLE:
        self.position = self.paddle.position - Vector2(0, 24)
        
        if Input.is_action_just_pressed("ui_up") or (Global.running_on == 'mobile' and get_parent().get_parent().get_node('Paddle').button_touched):
            state = STATE_NORMAL
            self.action.text = ''
            velocity = Vector2(0, -speed).rotated(-PI/8 + PI/4*randf())
        
    else:
        
        if self.cannon_count > 0:
            self.cannon_count -= 0.1*delta
        if self.cannon_count < 0:
            self.cannon_count = 0
            self.state = STATE_NORMAL
            $BlueBall.visible = true
            $GreyBall.visible = false
        
        var collision = move_and_collide(velocity * delta)
        if collision:
            
            if collision.collider.name == 'Paddle':
                var diff = self.position.x - collision.collider.position.x
                var angle = clamp(diff/50 * PI/3, -0.8 * PI/2, 0.8 * PI/2)
                velocity = Vector2(0, -speed).rotated(angle)
                if position.y > collision.collider.position.y - 22:
                    position.y = collision.collider.position.y - 22
            else:
                if collision.collider.name == 'Walls' or self.state != STATE_CANNON or collision.collider.colour == 'grey':
                    velocity = velocity.bounce(collision.normal)
            
            if collision.collider.has_method('hit'):
                collision.collider.hit(self.state != STATE_CANNON)
    
    if position.y > 1300:
        get_parent().remove_child(self)
        self.queue_free()
