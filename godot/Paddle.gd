extends KinematicBody2D


var base_bullet = preload("res://Bullet.tscn")

var speed = 320
var velocity = Vector2()
var shoot = false
var button_touched = false
var left_touched = false
var right_touched = false

var has_power_shoot = 0.0
var has_power_wide = 0.0


func _ready():
    reset()
    

func reset():
    has_power_shoot = 0.0
    has_power_wide = 0.0
    $BluePaddle1.visible = false
    $BluePaddle2.visible = false
    $BluePaddle3.visible = false
    $CollisionShape2D2.disabled = true
    $CollisionShape2D3.disabled = true


func _input(event):
    if event is InputEventMouseButton:
        if event.is_pressed():
            button_touched = get_parent().get_node('Action').get_rect().has_point(event.position)
            left_touched = get_parent().get_node('Left').get_rect().has_point(event.position)
            right_touched = get_parent().get_node('Right').get_rect().has_point(event.position)
        else:
            button_touched = false
            left_touched = false
            right_touched = false


func get_input():
    velocity = Vector2()
    if Input.is_action_pressed('ui_left') or left_touched:
        velocity += Vector2(-speed, 0)
    if Input.is_action_pressed('ui_right') or right_touched:
        velocity += Vector2(speed, 0)
    shoot = Input.is_action_just_pressed("ui_up") or button_touched


func _physics_process(delta):
    get_input()
    #velocity = move_and_slide(velocity)
    self.position += velocity * delta
    if self.position.x < 50: self.position.x = 50
    if self.position.x > 490: self.position.x = 490
    
    # Power ups.
    
    if self.has_power_shoot > 0:
        self.has_power_shoot -= 0.1*delta
        if shoot:
            var bullet = base_bullet.instance()
            bullet.position = self.position - Vector2(0, 22)
            get_parent().get_node('Bullets').add_child(bullet)
            button_touched = false
    if self.has_power_shoot < 0:
        self.has_power_shoot = 0.0
        get_parent().get_node('Action').text = ''
    
    if self.has_power_wide > 0:
        self.has_power_wide -= 0.1*delta
    if self.has_power_wide < 0:
        self.has_power_wide = 0.0
        $BluePaddle1.visible = false
        $BluePaddle2.visible = false
        $BluePaddle3.visible = false
        $CollisionShape2D2.disabled = true
        $CollisionShape2D3.disabled = true


func get_powerup(powerup):
    if powerup.colour == 'purple':
        self.has_power_shoot = 1.0
        get_parent().get_node('Action').text = 'UP to shoot' if Global.running_on == 'pc' else 'TAP to shoot'
    elif powerup.colour == 'red':
        self.has_power_wide = 1.0
        $BluePaddle1.visible = true
        $BluePaddle2.visible = true
        $BluePaddle3.visible = true
        $CollisionShape2D2.disabled = false
        $CollisionShape2D3.disabled = false
    elif powerup.colour == 'blue':
        for ball in get_parent().get_node('Balls').get_children():
            ball.make_cannon()
    elif powerup.colour == 'green':
        var new_balls = []
        for ball in get_parent().get_node('Balls').get_children():
            var new_ball = ball.clone()
            new_ball.velocity = new_ball.velocity.rotated(-PI*0.1)  
            ball.velocity = ball.velocity.rotated(PI*0.1)  
            new_balls.append(new_ball)
            break  # Just one extra ball for now.
        for ball in new_balls:
            get_parent().get_node('Balls').add_child(ball)
            