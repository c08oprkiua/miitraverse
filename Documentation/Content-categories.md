# What are Content Categories?
Content categories are modular sections of the UI for loading content. The Base UI and Networking nodes serve as backing support for these modules, so that content can be added in without having to worry about clipping through the UI, sorting out (API and account server) requests manually, and other things. That being said, content categories intentionally do not handle some things, because different parts of Miiverse have different needs. 

# Responsiblities:
Things that content categories have to handle on their own are:
* Determining API suburl to fetch, and calling the Network node to request it
* How/if fetched information is saved ("Offline Cache")
* Parsing whatever information they requested to be fetched
* Possible extra tasks per case

They all derive from a base category script, but in the end I found that having a handful of forks that could be specialized for the specific needs of how and when the content is displayed was better overall, with a base script they’re derived from to give a couple of universal helper functions. This design makes the MiiTraverse app somewhat of a framework for content loading, which makes adding and removing features without other features breaking relatively easy, so long as categories aren’t designed too heavily to lean on each other. Hypothetically, this design could lead to custom pages in the MiiTraverse UI that load entirely different pages, such as pages for the Pretendo website, but this is something that will likely not be actively utilized by MiiTraverse, as that would digress away from the core goals, design target, and features of the app. The only current “custom” category is the settings category.


# Pre-designed Content Categories:
People: 
* Endpoint: v1/people

Communities:
* Endpoint: v1/communities
* HFlow container (intentionally *not* a VboxContainer, for the sake of screen space utilization on tablets)

Activity Feed:
* I am honestly not sure where to fetch this from in the API, if it even can be fetched

Home:
* Endpoint: v1/topics
* WWP information is used to create a homepage-like page to open the app to

Posts:
* Endpoint: v1/communities/{ID}/posts
    * posts in {ID} community

Messages:
* AKA "DMs"

Notifications:
* Displays in app notifications

Settings:
* Not related to any networking
* Displays per-profile and global settings
