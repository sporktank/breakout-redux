extends Node2D


var base_brick = preload("res://Brick.tscn")
var base_ball = preload("res://Ball.tscn")

var starting_brick_count
var remaining_bricks
var level_num = 0
var lives = 3


func _ready():
    
    $Background.region_rect.position.y = 0
    
    setup_bricks(level_num)
    new_ball()
    
    $Left.visible = Global.running_on == 'mobile'
    $Right.visible = Global.running_on == 'mobile'

    
func new_ball():
    var ball = base_ball.instance()
    $Balls.add_child(ball)
    ball.setup($Paddle, $Action, level_num)
    $Action.text = 'UP to launch' if Global.running_on == 'pc' else 'TAP to launch'
    
    
func setup_bricks(level_num):

    for brick in $Bricks.get_children():
        $Bricks.remove_child(brick)
        brick.queue_free()
    
    starting_brick_count = 0
    var x = 0
    var y = 0
    for line in LEVELS[level_num%10].split('\n'):
        if line:
            x = 0
            for chr in line:
                if chr in ['r','b','g','p','x',' ']:
                    
                    if chr != ' ':
                        var brick = base_brick.instance()
                        brick.setup({'r':'red', 'b':'blue', 'g':'green', 'p':'purple', 'x':'grey'}[chr])
                        brick.position.x = 48 + x*64
                        brick.position.y = 32 + y*32
                        $Bricks.add_child(brick)
                        starting_brick_count += (1 if brick.colour != 'grey' else 0)
                    
                    x += 1
            y += 1
    
func _process(delta):
    
    # General.
    
    $Background.region_rect.position.y -= delta*50
    while $Background.region_rect.position.y < 0:
        $Background.region_rect.position.y += 1024
        
    if Input.is_action_just_pressed("ui_cancel"):
        #get_tree().change_scene("res://Menu.tscn")
        get_tree().quit()
        
    # Score.
    
    remaining_bricks = 0 
    for brick in $Bricks.get_children():
        remaining_bricks += (1 if brick.colour != 'grey' else 0)
    
    $Score.text = '%02d.%02d' % [level_num, starting_brick_count-remaining_bricks]
    
    # Lost balls.
    
    if $Balls.get_child_count() == 0:
        lives -= 1
        
        if lives == -1:
            Global.last_score = [level_num, starting_brick_count-remaining_bricks]
            get_tree().change_scene("res://Menu.tscn")
        
        $Lives/Life1.visible = lives > 0
        $Lives/Life2.visible = lives > 1
        $Lives/Life3.visible = lives > 2
        $Paddle.reset()
        new_ball()
        for powerup in $PowerUps.get_children():
            $PowerUps.remove_child(powerup)
            powerup.queue_free()
        for bullet in $Bullets.get_children():
            $Bullets.remove_child(bullet)
            bullet.queue_free()
    
    # Finished level.
    
    if remaining_bricks == 0:
        level_num += 1
        setup_bricks(level_num)
        for ball in $Balls.get_children():
            $Balls.remove_child(ball)
            ball.queue_free()
        for bullet in $Bullets.get_children():
            $Bullets.remove_child(bullet)
            bullet.queue_free()
        for powerup in $PowerUps.get_children():
            $PowerUps.remove_child(powerup)
            powerup.queue_free()
        new_ball()
        $Paddle.has_power_shoot = 0.0
        $Paddle.has_power_wide = 0.0



const LEVELS = [
## Level 0
#"""
#
# gggggg 
# p    b 
# p xx b 
# p xx b 
# p xx b 
# p xx b 
# p xx b 
# p xx b 
# p    b 
# rrrrrr 
#
#""",
## Level 1
#"""
#rrrrrrrr
#gggggggg
#bbbbbbbb
#pppppppp
#rrrrrrrr
#gggggggg
#bbbbbbbb
#pppppppp
#rrrrrrrr
#gggggggg
#bbbbbbbb
#pppppppp
#""",
## Level 2
#"""
#rrrrrrrr
#prrrprrr
#prrrprrr
#pprrpprr
#rrrrrrrr
#brbrbrbr
#rbrrbrbr
#brbrbbbr
#rrrrrrrr
#rrrrrrrr
#pppppppp
#rrrrrrrr
#""",
#]
# Level 0
"""
        
pppppppp
bbbbbbbb
gggggggg
rrrrrrrr
pppppppp
bbbbbbbb
gggggggg
rrrrrrrr
        
        
        
""",
# Level 1
"""
        
        
r       
rg      
rgb     
rgbp    
xxxxx   
rgbprg  
rgbprgb 
rgbprgbp
        
        
""",
# Level 2
"""
        
gggggggg
        
xxxxxrrr
        
pppppppp
        
bbbxxxxx
        
gggggggg
        
xxxxxrrr
""",
# Level 3
"""
        
grb  grb
rbp  rbp
bpb  bpb
pbg  pbg
bgr  bgr
grb  grb
rbp  rbp
bpb  bpb
pbg  pbg
bgr  bgr
        
""",
# Level 4
"""
pp    pp
 p    p 
 p    p 
 gggggg 
gggggggg
ggxggxgg
ggxggxgg
gggggggg
gggggggg
 gggggg 
  b  b  
bbb  bbb
""",
# Level 5
"""
g r  r g
g r  r g
g r  r g
g x  x g
g p  p g
g p  p g
g b  b g
g b  b g
x r  r x
r r  r r
r r  r r
r b  b r
""",
# Level 6
"""
        
  bbbb  
 brrrrb 
brggggrb
brgppgrb
brgppgrb
brggggrb
 brrrrb 
  bbbb  
        
x      x
x      x
""",
# Level 7
"""
        
 x    x 
        
 x rr x 
   gg   
   bb   
x  pp  x
   xx   
        
 x    x 
        
   xx   
""",
# Level 8
"""
rrrrrrrr
prrrprrr
prrrprrr
pprrpprr
rrrrrrrr
brbrbrbr
rbrrbrbr
brbrbbbr
rrrrrrrr
rrrrrrrr
pppppppp
rrrrrrrr
""",
# Level 9
"""
        
        
grx  xgr
pbx  xpb
xxx  xxx
        
  rrrr  
  gggg  
  bbbb  
  pppp  
        
        
""",
]