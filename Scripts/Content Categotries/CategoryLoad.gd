extends Control
class_name CategoryLoadingScript

#The export enum here alligns to the dictionary below
@export_enum(
	"Home", 
	"Communities", 
	"DMs", 
	"Notifications", 
	"Posts"
	) var PageInt: int

#This converts the enum to a key for Daba.Tbl
const IntToText = {
	0: "Home",
	1: "Communities",
	2: "DMs",
	3: "Notifications",
	4: "Posts",
}

var genericitem
var spacer = load("res://Scenes/spacer.tscn")
var converted

func _ready():
	#Converts the enum into the plain text key
	converted = IntToText.get(PageInt)
	var node = DaBa.Tbl[converted].get("Bubble")
	genericitem = load(node)
	Satellite.connect("SwitchTabs", VisibilityToggle)
	Satellite.connect("DebugFunc", ProceedLoadList)

#This will also manage triggering the loading/downloading of content for a page
#It *should* automatically dis/connect the node to the Network finished signal, in
#order to have only the correct node loading content at a given point in time
func VisibilityToggle(tabnow, active):
	if tabnow == converted:
		if active:
			print("Hello from ", converted)
			show()
			if DaBa.Tbl[converted].get("URL") == "":
				return
			Network.connect("Done", ProcessReadData, 4)
			Satellite.emit_signal("NetFetch", converted)
		else:
			if Network.is_connected("Done", ProceedLoadList):
				Network.disconnect("Done", ProceedLoadList)
			hide()
	else:
		if Network.is_connected("Done", ProceedLoadList):
				Network.disconnect("Done", ProceedLoadList)
		hide()

#Known bug: If the XML has an error, the file_processed signal never happens
#When that happens, the app is left hanging.
func ProcessReadData():
	var xml = XMLtoJSON.new()
	print("Proper procedure 2")
	xml.ConvertXML("", converted)
	await xml.file_processed
	ProceedLoadList()

func ProceedLoadList():
	print("Proper Procedure 3")
	#make sure there's data to load to avoid errors
	if DaBa.Tbl[converted].get("data") == null:
		if DaBa.UseCache:
			var XML = XMLtoJSON.new()
			XML.ConvertXML("", converted)
			await XML.file_processed
		print("Loading blocked because data for "+converted+" is empty")
		return
	if get_child_count() != 0:
		print("Child count is over 0")
		return
	add_child(spacer.instantiate())
	var DataSize = DaBa.Tbl[converted].get("data").size()
	for i in range(0, DataSize):
		add_child(genericitem.instantiate())
		Satellite.emit_signal("InitDir", i)
	add_child(spacer.instantiate())
