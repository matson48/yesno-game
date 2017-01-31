extends Spatial

func _ready():
    # Taken from the 2d-in-3d demo
    # It would be nice if there was a way to do this in the editor :p
    var tex = get_node("inside screen").get_render_target_texture()
    get_node("screen").get_material_override().set_texture(FixedMaterial.PARAM_DIFFUSE, tex)
