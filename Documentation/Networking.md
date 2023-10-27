Account server design:
    1. Determine which base account server URL to access (NN, PN, etc.)
    2. Connect to base URL
    3. Request suburl:
        1. 
        2. Encrypt login info
        3. Send login info
    4. Mount service token in API loading script

API loading design: 
    1. Determine which network is being used, based on the default network to load
    2. Connect to discovery. This is used to validate the login?
    3. Get the `api host` URL based on the discovery url
    4. Connect
    5. Profit

Networking notes:
    • https://github.com/MatthewL246/Miiverse-PC/blob/main/ParamIdEnums.cs
    • http://wiibrew.org/wiki/Country_Codes
    • Console certs are required
    • Header notes:
        ◦ Param Pack:
            ▪ A pack of parameters that tells the server what console is connected, which Title ID it’s posting from, etc. 
            ▪ Example: \title_id\1407375153045504\access_key\4045990404\platform_id\1\region_id\2\language_id\1\country_id\49\area_id\6\network_restriction\0\friend_restriction\0\rating_restriction\17\rating_organization\1\transferable_id\5221273826140205058\tz_name\America/Phoenix\utc_offset-25200\ 
            ▪ Base64 encoded
            ▪ Contains: 
                • Title ID
                • Access Key
                • Region ID
                • Language ID
                • Country ID
                • Area ID
                • Network Restriction
                • Friend Restriction
                • Rating Restriction
                • Rating Organization
                • Transferrable ID
                • Timezone name
                • UTC Offset
        ◦ Nintendo service token:
            ▪ Received upon login from account server
        ◦ Console certificate:
            ▪ Endpoints check for a certificate
