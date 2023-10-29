# Settings
Ever wondered how the settings work? No? Well too bad, I wrote this for myself so I could keep track of it and decided not to delete it from the documentation. 

Settings is divided into 3 main scripts of interest:

* SetBase.gd
* SetGlobal.gd
* SetProfile.gd

And all of these need to talk in harmony or users will find the most important part of the app to be utterly borked. Not Good.

So how does it work then? 

# Initial Loading

When MiiTraverse first loads, SetBase is loaded. This is because neither SetGlobal nor SetProfile(s) have been instantiated into existence. It will start by loading in SetGlobal. 

SetGlobal will then make a check for the settings file, and create it and write all global settings, as defined in the Project Settings, if it does not yet exist. 

Back to SetBase, its next course of action is to load in all the SetProfiles that it should load in. It does this by looking for all the sections in the settings file that are not blacklisted (blacklist for Globals and other sections)

But wait, we have one small issue: The internally stored profile, the default settings, does not have a section nor values in the settings file at this point. 
