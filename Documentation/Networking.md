MiiTraverse has two networking node, autoloaded at startup, that manage Account Server and API requests, respectively. 


# Account server design:
1. Determine which base account server URL to access (NN, PN, etc.)
2. Connect to base URL
3. Request suburl:
    1. Encrypt login info
    2. Send login info
4. Mount service token in API loading script

# API loading design: 
1. Determine which network is being used, based on the default network to load
2. Connect to discovery. This is used to validate the login?
3. Get the `api host` URL based on the discovery url
4. Connect
5. Profit

# Networking resources:
* https://github.com/MatthewL246/Miiverse-PC/blob/main/ParamIdEnums.cs
* http://wiibrew.org/wiki/Country_Codes

# Headers sent in requests:
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
