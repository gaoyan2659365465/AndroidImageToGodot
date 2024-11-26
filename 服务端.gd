extends Control


var 服务器 = TCPServer.new()
var 客户:StreamPeerTCP
signal 接收数据(_data)

func _ready():
	var 错误信息 = 服务器.listen(25550,"192.168.31.70")
	if 错误信息 == OK:
		print("服务器开始监听")


func _process(delta):
	if 服务器.is_listening():# 判断是否正在监听
		if 服务器.is_connection_available():
			客户 = 服务器.take_connection()#触发客户链接一次
			print("客户链接")
		if 客户 != null:
			客户.poll()
			var status = 客户.get_status()
			if status == 3:
				客户 = null
			elif status == 2:
				var bytes = 客户.get_available_bytes()
				if bytes > 0:
					var data = 客户.get_var()
					emit_signal("接收数据",data)
					if data[0] == "图像":
						var img = Image.create_from_data(data[1].x,data[1].y,data[4],data[3],data[2])
						$TextureRect.texture = ImageTexture.create_from_image(img)
						print("成功接收图片")
						img.save_png("res://保存数据.png")

func 发射数据(data):
	if 客户 != null:
		客户.put_var(data)
