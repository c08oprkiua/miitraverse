# Settings
In a literal sense, settings exist as the following custom Resources:

* Profile (Profile.gd)
* GlobSet (Globals.gd)

Settings, in the processing sense, are divided into 4 scripts, based on functions:

* database.gd ("DaBa")
* SetBase.gd
* SetGlobal.gd
* SetProfile.gd

And all of these need to talk in harmony or users will find the most important part of the app to be utterly borked. Not Good.

So how does it work then? 

# Initial Loading

When MiiTraverse first loads, SetBase is loaded. This is because neither SetGlobal nor SetProfile(s) have been instantiated into existence. SetBase is responsible for instantiating them, and it will start by loading in SetGlobal. 

In the database file (which is autoloaded and accessed in code with the "DaBa" name), there is a helper function that either returns the settings file if it exists, or returns a new settings file if not.

SetGlobal itself, when loaded in, will call this function, and when it gets the GlobSet returned by it, parses it for all its values. With these values, it does two things:

* Sets the copies of these values seen in DaBa
* Sets the states of the various UI elements in the GlobalSettings scene

Back to SetBase, its next course of action is to load in all the SetProfiles that it should load in. It does this by looking for all the directories in the `user://` directory, excluding the shader_cache and other Godot system directories. I may change this to just look for the `settings.tres` file in each folder, cause obviously it wouldn't exist in any folder besides the profiles (more on that in a bit).

But wait, we have one small issue: The internally stored profile, the default settings, does not have a section nor values in the settings file at this point.

To solve this, let's jump back to the part where the SetGlobal writes up all the settings if they don't exist. While it's doing this, it will also write in the section name of MiiTraverse's internal default profile, so that it will show up in the list. 

Now, I'm going to take a divergence into how making new profiles is handled, but I swear it's not to leave loose ends about loading.

# Making New Profiles

So, when making a new profile, the actual writing of settings is 90% handled by SetProfile. SetProfile has a function to load up default values, both to reset to defaults under the user's request, and also to initialize the internally stored defaults if it doesn't have them. 

So how does it work?

Well, first a section name is created for the profile, and written to settings. Then, NetworkIndexLoad is called on SetBase, reloading all the settings. This is inefficient, and maybe someday I'll make it not do this, but for right now, it's an *okay* solution to the problem. When NetworkIndexLoad is called, as previously mentioned, it will create a profile bubble for every non blacklisted section it makes. Because we added a new section, this means that a new bubble will be created for our new profile, and as a cascade effect of this, our bubble will fill itself with the default settings because it lacks settings in the settings file.

# SetBase
* Determines the values of the in-app/in-memory settings (whether to use cache, what color the UI should be)
* Loads in SetGlobal
* Loads in SetProfile based on sections present in the settings file
  * Change to add based on values in the networkarray
# SetGlobal
* Checks for the existence of the settings file
* Creates settings file if it doesn't exist
* Writes global settings to the settings file
 * Resets settings to default values 
# SetProfile
* Writes specific profile settings 

