# Welcome
Welcome to the MiiTraverse docs! I created these so that any developer who would like to contribute or fork this code has a decent, plain English way of getting up to speed on how the app works, including how networking requests are handled, how loading content is handled, and more!

During the development of this app, I was going through a pretty busy point in my life, so this documentation started as both a way for me to retrace my steps when I had left the project sitting for some time, and also to remind myself on what to implement when I had time to, because it was often easier for me to write down "make it work like this" than to actually go and do that. 

In that regard, I made the app to be somewhat of a modular framework, so that I could have as little resource duplication as possible, and also so that I could add, subtract, and tweak different specific aspects without everything crashing down, both metaphorically and literally. 

# App overall design
* Networking node
  * Discovery server parsing
  * API requests
  * account server requests (for retrieving a valid service token)
* Base UI
* Content categories
