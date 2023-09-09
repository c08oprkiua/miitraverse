# MiiTraverse
A Miiverse frontend for Android

The end goal of this project is to provide a full frontend for accessing [Miiverse instances](https://github.com/c08oprkiua/miiverse-android/blob/main/README.md#implementations-that-should-work) on an Android device. Currently, it is not far along, because this is only one of many things spread across my overall workload. But, by the end, it will hopefully be a 1:1 way to access all your favorite Miiverse content from the comfort of your phone or tablet, with some nice QoL things that come from the fact that it's on a phone (like downloading media, and maybe notifications...?).

Currently, the GUI elements it uses are a mix of programmer art that I made (it's bad) and [Articons Dark](https://github.com/Donnnno/Arcticons) icons. If anyone has the skills to create assets for this, please do so and commit them, I will add them if I like them (and tbh prolly even if I don't, cause it's still an improvement over my awful icons.)

# Features:
* ~~existing~~

# Incomplete features: 
* GET requests. It can fetch pretty much any URL from an API that would've been present in Miiverse, the issue is providing the proper headers. That being said...
  * The `param-pack` needs to be completed to properly reflect the locale of the device and/or user account.
  * I have not messed with implementing service tokens at all, lol
* Processing XML data. It can currently properly process the XML response from:
  * `/v1/communities/`
* Save and swap between different Miiverse implementations on the fly (*mostly* done)

# Future features:
* Downloading images
* Posting

# Implementations that *should* work:
Basically, any implementation that has a working API should work. Some that have said API, as far as I'm aware, include: 
* Juxtaposition (This one is complicated, so support might not be 100% or at all at first)
* NoNameVerse
* Rverse3 (when it's out, at least)
