extends RefCounted
class_name WiiUHeaders

@export_group("Universal")
@export var PlatformID: int = 1
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

@export_group("Access Token")
@export var DeviceCert: String

@export_group("Miiverse")
@export var ServiceToken: String
@export var ParamPack: String

var universalheaders:Dictionary = {
	"X-Nintendo-Platform-ID": "PlatformID",
	"X-Nintendo-Device-Type": "DeviceType",
	"X-Nintendo-Device-ID": "DeviceID", #Returned by MCP_GetDeviceID on a Wii U
	"X-Nintendo-Serial-Number": "SerialNumber", #String
	"X-Nintendo-System-Version": "SystemVersion",
	"X-Nintendo-Region": "Region",
	"X-Nintendo-Country": "Country", #Country ID
	"X-Nintendo-Client-ID": "ClientID", #Are these static? Also, should be sent with every request
	"X-Nintendo-Client-Secret": "ClientSecret", #Are these static?
	"X-Nintendo-FPD-Version": "FPD_Version", #areyousureaboutthat.png
	"X-Nintendo-Environment": "XEnvironment",
	"X-Nintendo-Title-ID": "TitleID",
	"X-Nintendo-Unique-ID": "UniqueID",
	"X-Nintendo-Application-Version": "ApplicationVersion",
	"X-Nintendo-Device-Cert": "DeviceCert",
}

var AccessTokenBody: Dictionary = {
	"grant_type": "password",
	"user_id": "",
	"password": "",
	"password_type": "hash"
}

var MiiverseHeaders: Dictionary = {
	"X-Nintendo-ServiceToken" = "",
	"X-Nintendo-Param-Pack" = ""
	
}

var ParamPackContents: Dictionary = {
	"title_id" = "",
	"platform_id" = "",
	"region_id" = "",
	"language_id" = "",
	"country_id" = "",
}

func UniHeaderBuilder(Region: int):
	#Put value-setting bs here
	
	#This is the loop that creates the actual PackedStringSrray
	var returned: PackedStringArray
	for values in universalheaders.keys():
		returned.append(values)
		var cont = universalheaders.get(values)
		var val = self.get(cont)
		returned.append(val)
	return returned

func TokenHeaderBuilder(Username: String, Password: String):
	AccessTokenBody["grant_type"] = "password"
	AccessTokenBody["user_id"] = Username
	AccessTokenBody["password"] = Password
	#Insert thing that adds these to the universalheaders


func PasswordToHashword(password: String, PID: String):
	pass

#Shamelessly copy pasted, cause no, I did not want to type allat
