# Welcome
Welcome to the MiiTraverse docs! I initially created these so that I could keep my head on straight about the design of the app while dipping in and out of development, but have kept them so that any developer who would like to contribute or fork this code has a decent, plain English way of getting up to speed on how the app works, including how networking requests are handled, how loading content is handled, and more!

During the development of this app, I was going through a pretty busy point in my life, so this documentation started as both a way for me to retrace my steps when I had left the project sitting for some time, and also to remind myself on what to implement when I had time to, because it was often easier for me to write down "make it work like this" than to actually go and do that. That being said, if something in the documentation does not actually allign with how the app is implemented, assume the docs are the intended/future-tesne implementation of said thing.

I made the app to be somewhat of a modular framework, so that I could have as little resource duplication as possible, and also so that I could add, subtract, and tweak different specific aspects without everything crashing down, both metaphorically and literally.

# App overall design
* Networking nodes:
  * API node:
    * Handles all post-login requests to the actual Miiverse instance
  * Accounts node:
    * account server requests (for retrieving a valid service token)
    * Contains requesting functions for both Wii U and 3DS
* Base UI
* Content categories
* Audoloaded database
