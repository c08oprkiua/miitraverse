extends RefCounted
class_name WiiUHeaders

var universalheaders = {
	"X-Nintendo-Platform-ID": 1,
	"X-Nintendo-Device-Type": 2,
	"X-Nintendo-Device-ID": null, #MCP_GetDeviceID
	"X-Nintendo-Serial-Number": null, #String
	"X-Nintendo-System-Version": null,
	"X-Nintendo-Region": null,
	"X-Nintendo-Country": null, #Country ID
	"X-Nintendo-Client-ID": "a2efa818a34fa16b8afbc8a74eba3eda", #Are these static?
	"X-Nintendo-Client-Secret": "c91cdb5658bd4954ade78533a339cf9a", #Are these static?
	"X-Nintendo-FPD-Version": 0000, #areyousureaboutthat.png
	"X-Nintendo-Environment": null,
	"X-Nintendo-Title-ID": null,
	"X-Nintendo-Unique-ID": null,
	"X-Nintendo-Application-Version": null,
	"X-Nintendo-Device-Cert": null
}

var AccessTokenHeaders: Dictionary = {
	"grant_type": "password",
	"user_id": "",
	"password": "",
	#"password_type": "hash"
}

func UniHeaderBuilder(Region: int):
	
	pass

func CreateTokenHeaders(Username: String, Password: String):
	AccessTokenHeaders["grant_type"] = "password"
	AccessTokenHeaders["user_id"] = Username
	AccessTokenHeaders["password"] = Password
	#Insert thing that adds these to the universalheaders
	pass
