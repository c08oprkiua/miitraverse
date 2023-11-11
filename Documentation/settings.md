# Settings
In a literal sense, settings exist as the following custom Resources:

* Profile (Profile.gd)
* GlobSet (Globals.gd)

Settings, in the processing sense, are divided into 4 scripts, based on functions:

* database.gd ("DaBa")
* SetBase.gd
* SetGlobal.gd
* SetProfile.gd

# SetBase
* Determines the values of the in-app/in-memory settings (whether to use cache, what color the UI should be)
* Loads in SetGlobal
* Loads in Profiles based on valid folders present in the `user://` directory
# SetGlobal
* Writes global settings to the settings file
# SetProfile
* Writes specific profile settings 
# Database
* Contains all the `(Thing)Check` functions, which either load and return a settings that exists, or create a new one, set defaults, and return that.
