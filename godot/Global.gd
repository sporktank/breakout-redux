extends Node


var running_on = null
var last_score = null
var highscores = [[0,0], [0,0], [0,0], [0,0], [0,0]]


func save_highscores():
    var save = File.new()
    save.open('user://highscores.save', File.WRITE)
    save.store_line(to_json(highscores))
    save.close()


func load_highscores():
    var save = File.new()
    if not save.file_exists('user://highscores.save'):
        save_highscores()
    save.open('user://highscores.save', File.READ)
    highscores = parse_json(save.get_line())
    save.close()


func _ready():
    #save_highscores()
    load_highscores()
        
    if OS.get_name() in ['Windows', 'HTML5']:
        running_on = 'pc'
    elif OS.get_name() in ['Android']:
        running_on = 'mobile'
    else:
        running_on = 'error'  # TODO: Raise exception.
    #running_on = 'mobile'