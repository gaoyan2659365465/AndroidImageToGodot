extends Control


var _plugin_name = "ShareTool"
var _android_plugin


var client = StreamPeerTCP.new()


func _ready():
	if Engine.has_singleton(_plugin_name):
		_android_plugin = Engine.get_singleton(_plugin_name)
	else:
		print("插件加载失败")
	
	

func 发送数据(data:Array):
	var error = client.connect_to_host($LineEdit.text,int($LineEdit2.text))
	client.put_var([""])
	await get_tree().create_timer(1.0).timeout
	client.put_var(data)
	await get_tree().create_timer(1.0).timeout
	client.disconnect_from_host()

func _process(delta):
	client.poll()
	if client.get_status()==client.STATUS_CONNECTED:
		if int(client.get_available_bytes())>=int(3): #获取字节大小
			emit_signal("接收数据",client.get_var())

func _on_button_pressed() -> void:
	var image = Image.load_from_file("user://my_image.png")
	$TextureRect.texture = ImageTexture.create_from_image(image)
	发送数据(["图像",image.get_size(),image.get_data(),image.get_format(),image.has_mipmaps()])
	
