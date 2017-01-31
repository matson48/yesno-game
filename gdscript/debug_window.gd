extends WindowDialog

func on_load_script():
    var list = get_node("script list")
    list.clear()

    var interpreter = get_node("/root/root/interpreter")
    var script = interpreter.script
    var index = 0
    for item in script:
        if typeof(item) == TYPE_STRING:
            list.add_item(str(index, ": ", "\"", item, "\""))
        elif item extends interpreter.parser.Command:
            list.add_item(str(index, ": ", item.to_string())) 
        index += 1

