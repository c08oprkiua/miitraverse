# MiiTraverse
A Miiverse frontend for Android

The end goal of this project is to provide a full frontend for accessing multiple [Miiverse instances](https://github.com/c08oprkiua/miiverse-android/blob/main/README.md#implementations-that-should-work) from a single app on an Android device. Currently, it is not far along, because this is only one of many things spread across my overall workload. But, by the end, it will hopefully be a 1:1 way to access all your favorite Miiverse content from the comfort of your phone or tablet, with some nice QoL things that come from the fact that it's on a phone (like downloading media, and maybe notifications...?).

Currently, the GUI elements it uses are a mix of Godot-native styleboxes and [Articons Dark](https://github.com/Donnnno/Arcticons) icons. If anyone has the skills to create custom icons for this and would like to, I will welcome submissions for custom icons with open arms. 

# DISCLAIMER

This app is designed to mimic the requests a real console would make. To this extent, bans solely for using the app alone should not happen, nor should it be particularly detectable that this app is not a console. That being said...

This app will not magically make you a hackerman capable of evading rules. You are stull subject to the rules of whichever Miiverse revival(s) you are accessing, this app will not change that. I hold no responsiblity for you getting banned for behavior explicitly outlined against the TOS of whichever Miiverse revival you are using through MiiTraverse. This app will not allow you to easily evade bans, as it still requires console certificates and account tokens to pass authentication on (some of) these services.

# Requirements
This app does not include, but will require, the following:
* An already created (and not banned) account on the revival you are accessing
* console certificates from either a Wii U or a 3DS

Additionally, the following can be used with the app but are not included
* Custom stamps


# Features:
* ~~existing~~
* Custom settable UI color, with per-profile overrides

# Incomplete features: 
* Server authentication (service tokens) using account server(s)
* The `param-pack` needs to be completed to properly reflect the locale of the device and/or user account.
* Processing XML data. It can currently properly process the XML response from:
  * `/v1/communities/`
* Save and swap between different Miiverse implementations on the fly (*mostly* done)

# Future features:
* Multiple registered/registerable account servers (ie. Pretendo Network, Nintendo Network, etc.)
* Downloading images (paintings, screenshots, and Mii icons)
* Posting
* Custom stamps

# Implementations that *should* work:
Basically, any implementation that has a working API implementation should work. Some that have said API, as far as I'm aware, include: 
* Juxtaposition (If you have access to it)
* Sapphire
* Rverse3 (when it's out, at least)

# FAQ: 
Q: Will this work with (insert revival here)?

- A: As said above, this app will theoretically work with any Miiverse revival that has an API. Mileage will vary with it based on how much of the API the service has implemented, as MiiTraverse uses a lot of different API endpoints. 

Q: Why not use the official Miiverse icon font?

- A: Copyright reasons, and also to maintain a revival-agnostic look. If you want a version with those icons, I will not provide that for you. However, considering the nature of this being open source, I'm not gonna stop you from self-compiling a version that uses those icons, assuming you legally obtained them.

Q: Why do you not provide a built in set of custom stamps? 

- A: Partially copyright, partially "I'm not an artist", and partially, I just don't want to deal with people requesting to add things to a built-in set. Also, keeps the base app installation size smaller. I will put tutorials up on how to create custom stamps, and people are welcome to host their own repos with custom stamp sets.

