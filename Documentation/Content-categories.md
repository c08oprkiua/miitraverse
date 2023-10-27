
Content categories are responsible for:
    • The fetched URL
    • How/if fetched information is saved
    • Parsing whatever information they fetch
    • Possible extra tasks per case
    • Determining suburl to fetch, and/or base URL to (re)connect to

They all derive from a base category script, but in the end I found that having a handful of forks that could be specialized for the specific needs of how and when the content is displayed was better overall, with a base script they’re derived from to give a couple of universal helper functions. This design makes the MiiTraverse app somewhat of a framework for content loading, which makes adding and removing features without other features breaking relatively easy, so long as categories aren’t designed too heavily to lean on each other. Hypothetically, this design could lead to custom pages in the MiiTraverse UI that load entirely different pages, such as pages for the Pretendo website, but this is something that will likely not be actively utilized by MiiTraverse, as that would digress away from the core goals, design target, and features of the app. The only current “custom” category is the settings category.


Pre-designed Content Categories:
    • People
        ◦ Endpoint: v1/people
    • Communities
        ◦ Endpoint: v1/communities
        ◦ Loads content in an Hflow container (not a VboxContainer, for the sake of screen space utilization on tablets)
    • Activity Feed
        ◦ 
    • Posts
        ◦ Endpoint: v1/communities/{ID}/posts
            ▪ posts in {ID} community
    • Messages
        ◦ 
    • Notifications
        ◦ 
    • Settings
        ◦ Not related to any networking 