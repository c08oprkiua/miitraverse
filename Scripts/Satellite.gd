extends Node

#UI/Misc.
signal InitDir
signal Thisitem
signal Gohere
signal Confirm

#This is for telling all relevent objects to self_modulate to a new color
signal ColorTint

#Downloading
signal DownloadStarted
signal DownloadPercent
signal DownloadComplete

#Icon Processing
signal Processedicon

#List loading
signal LoadInfo

#These two are used for calling the network connect, using a valid integer 
#corresponding to a network in Network.networkarray, and information fetching, 
#using a string corresponding to a valid category, respectively.
#Initial Connection
signal SwapNetworks
#Page Connect
signal NetFetch


signal RefreshNetworks
