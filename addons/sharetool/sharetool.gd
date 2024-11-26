@tool
extends EditorPlugin


var export_plugin : AndroidExportPlugin

func _enter_tree():
	export_plugin = AndroidExportPlugin.new()
	add_export_plugin(export_plugin)


func _exit_tree():
	remove_export_plugin(export_plugin)
	export_plugin = null


class AndroidExportPlugin extends EditorExportPlugin:
	var _plugin_name = "ShareTool"

	func _supports_platform(platform):
		if platform is EditorExportPlatformAndroid:
			return true
		return false

	func _get_android_libraries(platform, debug):
		if debug:
			return PackedStringArray(["sharetool/sharetool-debug.aar",])
		else:
			return PackedStringArray(["sharetool/sharetool-release.aar",])

	func _get_android_dependencies(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
		return PackedStringArray(["androidx.legacy:legacy-support-core-ui:1.0.0","androidx.appcompat:appcompat:1.6.1","com.google.android.material:material:1.9.0","androidx.constraintlayout:constraintlayout:2.1.4"])

	func _get_android_dependencies_maven_repos(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
		return PackedStringArray([
			"https://jitpack.io",
		])
	
	func _get_android_manifest_application_element_contents(platform: EditorExportPlatform, debug: bool) -> String:
		return """
		<activity 
		android:name="com.example.sharetool.ShareReceiverActivity" 
		android:theme="@style/Theme.MaterialComponents.NoActionBar" 
		android:exported="true" 
		tools:replace="android:exported"
		>
			<intent-filter>
				<action android:name="android.intent.action.SEND"/>
				<category android:name="android.intent.category.DEFAULT"/>
				<data android:mimeType="image/*"/>  <!-- 如果是图片，可以设置具体的 MIME 类型 -->
			</intent-filter>
		</activity>
		"""
	
	func _get_android_manifest_element_contents(platform: EditorExportPlatform, debug: bool) -> String:
		return """
	
	<uses-permission android:name="android.permission.INTERNET"/>
	<uses-permission android:name="android.permission.WAKE_LOCK"/>
	<uses-permission android:name="android.permission.GET_TASKS"/>
	<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
	<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
	<uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES"/>
	
	<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
	<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
	<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
	<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
	<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
	"""

#<uses-permission android:name="android.permission.READ_PHONE_STATE"  tools:node="remove"/>
#<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"  tools:node="remove"/>
#<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"  tools:node="remove"/>
#<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"  tools:node="remove"/>
#<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"  tools:node="remove"/>
	
	func _get_name():
		return _plugin_name
