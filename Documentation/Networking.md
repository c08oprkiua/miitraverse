MiiTraverse has two networking nodes, autoloaded at startup, that manage Account Server and API requests, respectively. 


# Account server design:
1. Determine which device is being mimicked
2. Determine which base account server URL to access
4. Connect to base URL
   1. Get login information from profile
   2. Create headers with relevant profile information
   3. Send request
5. Mount returned service token in API loading script

# API loading design: 
1. Determine which network is being used (based on `ProfileCheck`)
2. Connect to the api domain
3. Send subsequent url requests
4. Profit

# Networking resources:
* https://github.com/MatthewL246/Miiverse-PC/blob/main/ParamIdEnums.cs
* http://wiibrew.org/wiki/Country_Codes

# Headers sent in API requests:
Param Pack:
* A pack of parameters that tells the server what console is connected, which Title ID it’s posting from, etc. 
* Base64 encoded
* Contains:
    * Title ID
    * Access Key
    * Region ID
    * Language ID
    * Country ID
    * Area ID
    * Network Restriction
    * Friend Restriction
    * Rating Restriction
    * Rating Organization
    * Transferrable ID
    * Timezone name
    * UTC Offset
Nintendo Service token
* Received upon login from account server


Console certificate:
* Endpoints check for a certificate

Network array load:
* New profiles are made with a directory scheme of `Profile[int]`, with their profile settings stored in `settings.tres`
* The array creating function looks for all folders that follow the above scheme, and then for each one, adds its name to the optionbutton listings. 
