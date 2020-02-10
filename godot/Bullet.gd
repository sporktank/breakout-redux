extends KinematicBody2D


var velocity = Vector2()


func _ready():
    velocity = Vector2(0, -600)


func _physics_process(delta):
    var collision = move_and_collide(velocity * delta)
    if collision:
        if collision.collider.has_method('hit'):
            collision.collider.hit(false)
            get_parent().remove_child(self)
            self.queue_free()
