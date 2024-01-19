extends RefCounted
class_name WiiUHeaders

@export_group("Universal")
@export var PlatformID:OliveRes.Platform_ID = OliveRes.Platform_ID.WiiU
@export var DeviceType: int = 2
@export var DeviceID: int
@export var SerialNumber: String
@export var SystemVersion: int
@export var Region: int
@export var Country: String
@export var ClientID: String = "a2efa818a34fa16b8afbc8a74eba3eda"
@export var ClientSecret: String = "c91cdb5658bd4954ade78533a339cf9a"
@export var FPD_Version: int = 0000
@export var XEnvironment: String
@export var TitleID: int
@export var UniqueID: String
@export var ApplicationVersion: String
@export var DeviceCert: String

var universalheaders:PackedStringArray = [
	"X-Nintendo-Platform-ID", 
	"X-Nintendo-Device-Type",
	"X-Nintendo-Device-ID", #Returned by MCP_GetDeviceID on a Wii U
	"X-Nintendo-Serial-Number", #String
	"X-Nintendo-System-Version",
	"X-Nintendo-Region",
	"X-Nintendo-Country", #Country ID
	"X-Nintendo-Client-ID", #Are these static? Also, should be sent with every request
	"X-Nintendo-Client-Secret", #Are these static?
	"X-Nintendo-FPD-Version", #areyousureaboutthat.png
	"X-Nintendo-Environment",
	"X-Nintendo-Title-ID",
	"X-Nintendo-Unique-ID",
	"X-Nintendo-Application-Version",
	"X-Nintendo-Device-Cert",
]

var AccessTokenBody: Dictionary = {
	"grant_type": "password",
	"user_id": "",
	"password": "",
	"password_type": "hash"
}

func UniHeaderBuilder(Region: int):
	#Put value-setting bs here
	
	#This is the loop that creates the actual PackedStringSrray
	var returned:PackedStringArray
	var tempstring:String = ""
	for values in universalheaders:
		var keyvalue:String
		returned.append(values)
		var val = self.get(values)
		returned.append(val)
	return returned

func TokenHeaderBuilder(Username: String, Password: String):
	AccessTokenBody["grant_type"] = "password"
	AccessTokenBody["user_id"] = Username
	AccessTokenBody["password"] = Password
	#Insert thing that adds these to the universalheaders
