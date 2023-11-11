extends XMLParser
#class_name XMLtoJSON

signal file_processed

var xml: XMLParser  = XMLParser.new()
var itname
var commtoggle
var information

#This function attempts to parse an XML for only relevant data
#Rename function to "ConvertXMLBuffer
func ConvertXML(raw: PackedByteArray, TriggerNode: String):
	xml.open_buffer(raw)
	var stringtionary: Dictionary
	var entry: int = 0
	while xml.read() != ERR_FILE_EOF:
		var checkdata = xml.get_node_type()
		match checkdata:
			1:
				var nodename = xml.get_node_name()
				#This node name tells the function that it's gotten to the 
				#relevant data, and starts a dictionary for it
				if nodename == TriggerNode:
					
					stringtionary[entry] = {}
					commtoggle = true
				#This enters a key into the aforemtioned dictionary
				else: 
					itname = nodename
					if xml.is_empty():
						print("is null")
			2:
				if commtoggle:
					#I feel like something was gonna go here but idr what
					stringtionary[entry][itname] = information
				if xml.get_node_name() == TriggerNode:
					entry = entry + 1 
					commtoggle = false
			3:
				if xml.is_empty():
					information = null
				else:
					information = xml.get_node_data()
			4:
				pass
			5:
				pass
			6:
				pass
	print("XML processed")
	#Satellite.emit_signal.call_deferred("LoadInfo")
	emit_signal.call_deferred("file_processed")


#This function just converts the whole XML into a dictionary, which may not be needed
# nor as fast as the regular ConvertXML
func FullConvertXML(raw, datatype):
	var nodearray: PackedStringArray
	var do
	if DaBa.UseCache:
		if DaBa.Tbl[datatype]:
			pass
		var filename = DaBa.Tbl[datatype].get("Filename") as String
		if DaBa.Tbl[datatype].get("URL-EXT"):
			print(filename)
			filename = filename.format(API.formatas)
			print(filename)
		var tabla = {"Network": API.CurrentAPIHost, "Filename": filename}
		var file =  ("user://{Network}/{Filename}.xml".format(tabla))
		print(file)
		if not FileAccess.file_exists(file):
			if raw != "":
				do = xml.open_buffer(raw)
			else:
				print("Neither a valid file nor buffer were detected")
				return
		else:
			do = xml.open(file)
	else:
		if raw != "":
			do = xml.open_buffer(raw)
	var stringtionary: Dictionary
	var entry = 0
	while xml.read() != ERR_FILE_EOF:
		var checkdata = xml.get_node_type()
		match checkdata:
			0:
				#No node. This is in here as a safety catch, in case it somehow
				#gets this far without a valid file
				break
			1:
				#Node element
				var nodename = xml.get_node_name()
				#This node name tells the function that it's gotten to the 
				#relevant data, and starts a dictionary for it
				stringtionary[entry] = {}
				commtoggle = true
				#This enters a key into the aforemtioned dictionary 
				itname = nodename
				if xml.is_empty():
					print("is null")
			2:
				#Node element end
				if commtoggle:
					#I feel like something was gonna go here but idr what
					stringtionary[entry][itname] = information
				if xml.get_node_name():
					entry = entry + 1 
					commtoggle = false
			3:
				#Node text
				if xml.is_empty():
					information = null
				else:
					information = xml.get_node_data()
			4:
				#Node comment
				pass
			5:
				#Node cdata
				pass
			6:
				#Node unknown
				pass
	if DaBa.UseCache:
		var savecache = FileAccess.open("user://"+API.CurrentAPIHost+"/"+DaBa.Tbl[datatype].get("Filename")+"full.json", FileAccess.WRITE_READ)
		savecache.store_string(JSON.stringify(stringtionary))
		print("XML processed")
	Satellite.emit_signal.call_deferred("LoadInfo")
