extends Node

#UI/Misc.
signal InitDir
signal Thisitem
signal Gohere #This will be used by Search to tell a matching item to grab focus
signal Confirm
signal InitPosts #By default, the posts tab is hidden until it has a community to load
signal SwitchTabs

signal DebugFunc

signal ColorTint #This tells all relevent objects to self_modulate to a new color
signal NewBubble

#Downloading
signal DownloadStarted
signal DownloadPercent
signal DownloadComplete

#Icon Processing
signal Processedicon

#List loading
signal LoadInfo #I'm gona depreciate this for the following:
signal LoadPosts
signal LoadComms
signal LoadProfile
signal NewProfile

#These two are used for calling the network connect, using a valid integer 
#corresponding to a network in Network.networkarray, and information fetching, 
#using a string corresponding to a valid category, respectively.
signal SwapNetworks #Initial Connection
signal NetFetch #Page Connect


signal RefreshNetworks

func gimme():
	print(get_signal_connection_list("InitDir"))
	print(get_signal_connection_list("Thisitem"))
