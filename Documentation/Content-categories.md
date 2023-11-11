# What are Content Categories?
Content categories are modular sections of the UI for loading content. The Base UI and Networking nodes serve as backing support for these modules, so that content can be added in without having to worry about clipping through the UI, sorting out (API and account server) requests manually, and other things. That being said, content categories intentionally do not handle some things, because different parts of Miiverse have different needs. 

# Responsiblities:
Things that content categories have to handle on their own are:
* Determining API suburl to fetch, and calling the Network node to request it
* Parsing whatever information they requested to be fetched
* Possible extra tasks per case

They all derive from a base category script, but in the end I found that having a handful of forks that could be specialized for the specific needs of how and when the content is displayed was better overall, with a base script they’re derived from to give a couple of universal helper functions. This design makes the MiiTraverse app somewhat of a framework for content loading, which makes adding and removing features without other features breaking relatively easy, so long as categories aren’t designed too heavily to lean on each other. Hypothetically, this design could lead to custom pages in the MiiTraverse UI that load entirely different pages, such as pages for the Pretendo website, but this is something that will likely not be actively utilized by MiiTraverse, as that would digress away from the core goals, design target, and features of the app. The only current “custom” category is the settings category.

# Custom Classes 
The two custom classes I made for these are `CatBoxContainer` and `CatFlowContainer`. These should act essentially the same, just that one inherets from a Box Container and the other inherents from a Flow Container.

# Pre-designed Content Categories:
These are all the content categories implemented in MiiTraverse, as both a reference to what they should be doing and also as examples of implementing other content categories
| Content Category | API Endpoint(s)| Godot Container | Description| Notes|
| ---------------- | ----------------------------- | --------------- | ------------------------------------------------------------------------------ | ------------------------------- |
| Activity Feed| (Unknown)|| Activity feed of people the user follows||
| Communities| `v1/communities`| CatFlowContainer| List of all communities on the Miiverse instance (that are visible to the API) ||
| Home| `v1/topics`|CatFlowContainer| Customizable landing page| Filled out using WWP information by default |
| Messages| (Unknown)| CatBoxContainer| Direct messages between the user and other users|AKA "DMs"|
| Notifications| (Unknown)| CatBoxContainer| In app notifications||
| People| `v1/people`|CatBoxContainer| People||
| Posts| `v1/communities/{ID}/posts` |CatFlowContainer| Post in a community| Linked to Communities|
| Settings| N/A| CatBoxContainer| The place for managing all in app settings, both global and per-profile| Does not use any network connectivity directly|
