# MiiTraverse
A Miiverse frontend for Android

The end goal of this project is to provide a full frontend for accessing multiple [Miiverse revivals](https://github.com/c08oprkiua/miiverse-android/blob/main/README.md#implementations-that-should-work) from a single app. Currently, it is not far along, because this is only one of many things spread across my overall workload. But, by the end, it will hopefully be a 1:1 way to access all your favorite Miiverse content from the comfort of your phone or tablet, with some nice QoL things that come from the fact that it's on a phone (like downloading media, and maybe notifications...?).

Currently, the GUI elements it uses are a mix of Godot-native styleboxes and [Articons Dark](https://github.com/Donnnno/Arcticons) icons. If anyone has the skills to create custom icons for this and would like to, I will welcome submissions for custom icons with open arms. 

# DISCLAIMER

This app is designed to mimic the requests a real console would make. To this extent, bans solely for using the app alone should not happen, nor should it be particularly detectable that this app is not a console, albeit one making some odd network requests. That being said...

This app does not do any of the following:
* Allow you to post screenshots where you aren't allowed to*
* Evade console/account bans
* Sidestep access whitelists*
* Prevent bans for otherwise bannable offenses*
* Provide valid console certificates out of the box

*Based on the rules and setup of the Miiverse revival you are accessing

# Requirements:
This app does not include, but will require, the following:
* An already created (and not banned) account on the revival you are accessing
* console certificates from either a Wii U or a 3DS
* A Miiverse instance to access

Additionally, the following can be used with the app but are not included
* Custom stamps

# Features:
* Customizable UI color, with per-profile overrides
* Adding and removing profiles

# Incomplete features: 
- [ ] Server authentication (service tokens) using account server(s);
  - [ ]  3DS-accurate requests
  - [ ]  Wii U-Accurate requests
- [ ] The `param-pack` needs to be completed to properly reflect the locale of the device and/or user account.
- [ ] Processing XML data from:
  - [ ] `/v1/communities/`
  - [ ] `/v1/communities/{id}/posts/`
  - [ ] `v1/topics`
- [ ] Apps for 3DS and Wii U that dump [relevant console information](https://github.com/kinnay/NintendoClients/wiki/Account-Server) for use with this app

# Future features:
- [x] Multiple registered/registerable account servers (ie. Pretendo Network, Nintendo Network, etc.)
- [ ] Downloading images (paintings, screenshots, and Mii icons)
- [ ] Posting
- [ ] Custom stamps

# Implementations that *should* work:
Basically, any implementation that has a working API implementation should work. Some that have said API, as far as I'm aware, include: 
* Juxtaposition (If you have access to it)
* Rverse3 (when it's out, at least)

# FAQ: 
> Q: Will this work with (insert revival here)?

- This app will theoretically work with any Miiverse revival that has an API.

Mileage will vary with it based on how much of the API the given revival has implemented, as MiiTraverse uses a lot of (if not most/all of the) different API endpoints provided by the original Miiverse. 

> Q: Why not use the official Miiverse icon font?

- Copyright reasons
- To maintain a revival-agnostic look.

If you want a version with those icons, I will not provide that for you. However, considering the nature of this being open source, I'm not gonna stop you from self-compiling a version that uses those icons, assuming you legally obtained them.

> Q: Why do you not provide a built in set of custom stamps? 

- Partially copyright
- Partially "I'm not an artist"
- Partially, I just don't want to deal with people requesting to add things to a built-in set.
- Keeps the base app installation size smaller.

I will put tutorials up on how to create custom stamps, and people are welcome to host their own repos with custom stamp sets.

# Credits, Thank-yous, etc.
- NoNameGiven and Mikey of Sapphire
- Jon and Jemma of Pretendo
- Terminal and Oman of Rverse3/Rverse2
- [This project](https://github.com/MatthewL246/Miiverse-PC)
- [This documentation](https://github.com/kinnay/NintendoClients/wiki)

