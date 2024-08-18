# externalOTPResetSFDC
 
1.1 Create a Connected App in Salesforce
Navigate to: Setup → App Manager → New Connected App.

Basic Information:

Connected App Name: MarketingCloudOTPApp
API Name: MarketingCloudOTPApp
Contact Email: Your email address
API (Enable OAuth Settings):

Check Enable OAuth Settings.
Callback URL: This can be any valid URL since it’s not used for this server-to-server flow. You might use https://login.salesforce.com/services/oauth2/success.
Selected OAuth Scopes:
Full access (full)
Perform requests on your behalf at any time (refresh_token, offline_access)
Access and manage your data (api)
Require Secret for Web Server Flow: Leave this unchecked.
Save the connected app and make a note of the Consumer Key (Client ID) and Consumer Secret.

OAuth Policies (after saving):

Permitted Users: Admin approved users are pre-authorized.
IP Relaxation: Relax IP restrictions (if applicable based on security requirements).
Refresh Token Policy: Set the refresh token policy to your needs (e.g., Refresh token is valid until revoked).





1.2. Create the Custom Object: Password_Reset_Token__c
This object will store the OTP tokens.

Navigate to: Setup → Object Manager → Create New Custom Object.
Object Name: Password_Reset_Token__c
Label: Password Reset Token
Plural Label: Password Reset Tokens
API Name: Password_Reset_Token__c
Fields:
Token (Text)
Field Label: Token
Field Name: Token__c
Length: 255
User (Lookup)
Related to: User
Field Name: User__c
Expiration Date (DateTime)
Field Label: Expiration Date
Field Name: Expiration_Date__c

1.3 Add Experience Cloud Site Password Reset Page
Add a new page called 'passwordreset' to an existing or new experience cloud site. 

Add the LWC called resetPasswordFromOTP on this page and make sure the page is accessible to public.

Add the value {!token} to the component's token property so it can get the value from a URL.

Make sure you expicitly set permission to the site's guest user for the LWC's apex controller called PasswordResetController

Create a custom tab for the Password Reset Token custom object to make it easier to debug
