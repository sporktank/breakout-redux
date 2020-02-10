extends Node2D


const MOBILE_CONTROLS = """move left : hold "<"
move right : hold ">"
shoot/launch : tap center"""
const PC_CONTROLS = """move left : left arrow
move right : right arrow
shoot/launch : up arrow"""


class MyCustomSorter:
    static func sort(a, b):
        if a[0] < b[0] or (a[0] == b[0] and a[1] < b[1]):
            return true
        return false


func _ready():
    if Global.last_score:
        Global.highscores = Global.highscores + [Global.last_score]
        Global.highscores.sort_custom(MyCustomSorter, "sort")
        Global.highscores.invert()
        Global.highscores.pop_back()
        Global.save_highscores()
        
    var num = 0
    $ScoresText.text = ''
    for score in Global.highscores:
        num += 1
        $ScoresText.text += '%d) %02d.%02d\n' % [num, score[0], score[1]]
    
    $Controls.text = MOBILE_CONTROLS if Global.running_on == 'mobile' else PC_CONTROLS


func _process(delta):
    if Input.is_action_just_pressed("ui_cancel"):
        get_tree().quit()


func _on_PlayButon_pressed():
    get_tree().change_scene("res://Game.tscn")
