extends Node

#UI/Misc.
signal InitDir
signal Thisitem
signal Gohere #This will be used by Search to tell a matching item to grab focus
signal Confirm
signal InitPosts #By default, the posts tab is hidden until it has a community to load
signal SwitchTabs

signal ColorTint #This tells all relevent objects to self_modulate to a new color
signal NewBubble
signal NewPopUp

#Downloading
signal DownloadStarted
signal DownloadPercent
signal DownloadComplete

#Icon Processing
signal Processedicon

#List loading

#Practically none of these need to be here and in fact should probably be handled locally instead

signal LoadInfo #I'm gona depreciate this for the following:
signal LoadPosts
signal LoadComms

signal NewProfile #Used to tell SetBase to create a new profile bubble
signal LoadProfile #Used in settings to pass on profile information to a profile bubble


signal SwapNetworks #Change API and/or account server
signal NetFetch #Fetch API content


signal RefreshNetworks #Signal to refresh all the active UI Elements

