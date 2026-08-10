/// Static User Manual content sourced from the official
/// "Rewaldo Customer App User Manual" document for the Rewaldo Customer
/// Application. Rendered as HTML via flutter_html.
const String kUserManualHtml = '''
<h3><strong>REWALDO</strong></h3>
<h4>Loyalty &amp; Rewards Platform</h4>
<h3><strong>Customer App</strong></h3>
<p>A complete guide to earning, redeeming, and enjoying your rewards on the Rewaldo mobile customer application.</p>
<h3><strong>Mobile Customer Application</strong></h3>
<p><strong>User Manual: </strong>Version 1.0</p>
<h1>1. Introduction</h1>
<p>The Rewaldo Customer App is the mobile application that lets shoppers join their favourite retailers' loyalty programs, earn points on every purchase, redeem rewards, collect gift cards and vouchers, and discover promotions from merchants near them. This manual explains every screen and feature available to a customer, from creating an account to redeeming a reward at checkout.</p>
<h1>2. Getting Started</h1>
<h2>2.1 Installing the App</h2>
<p>Download the Rewaldo customer app from the Apple App Store (iOS) or Google Play Store (Android) and install it on your device.</p>
<h2>2.2 Onboarding</h2>
<p>The first time you open the app, a short onboarding walkthrough introduces the core benefits of the loyalty program. Tap through the introduction screens to reach the sign-in options.</p>
<h2>2.3 Creating an Account</h2>
<p>You can join Rewaldo in two ways:</p>
<ul>
<li>Sign Up — create a new account using your name, email/phone number, and a password. Password should contain 8 digits with special characters</li>
<li>Sign Up with a Referral ID — if a friend invited you, enter their referral code during sign-up to link your account to them and unlock referral rewards for both of you.</li>
<li>You will receive a OTP (One Time Password) on your registered email/phone number to verify your account. Enter the OTP on the Verify OTP screen to complete the sign-up process.</li>
</ul>
<h2>2.4 Signing In</h2>
<ul>
<li>Open the app and select Sign In.</li>
<li>Enter your registered email/phone number and password.</li>
<li>Tap Sign In to reach your Home screen.</li>
</ul>
<h2>2.5 Forgotten Password</h2>
<ul>
<li>On the sign-in screen, tap Forgot Password.</li>
<li>Enter your registered email/phone number to receive a One-Time Password (OTP).</li>
<li>Enter the OTP on the Verify OTP screen.</li>
<li>Create a new password on the Create New Password screen and sign in with it.</li>
</ul>
<h2>2.6 Location Access</h2>
<p>The app requests permission to access your device location so it can show nearby merchants and calculate distances on the map. Allow location access for the best experience — you can still browse without it, but nearby-merchant recommendations will be limited.</p>
<h1>3. Getting Around the App</h1>
<p>The app is organised around four main tabs at the bottom of the screen:</p>
<h1>4. Home Screen</h1>
<p>The Home screen is your starting point every time you open the app and includes:</p>
<h2>4.1 Nearby Merchants Map</h2>
<p>A map preview shows participating merchants near your current location. Tap the map preview to open the full map and directions view.</p>
<h2>4.2 Service Categories</h2>
<p>Merchant's Promotions are organised into categories so you can quickly find the type of business you're looking for:</p>
<p>Tap a category to see all merchants offering that type of service.</p>
<h2>4.3 Special Promotions Carousel</h2>
<p>An auto-scrolling carousel highlights active promotions and rewards from merchants you follow or that are near you. Tap any card to view the full offer details. It also shows the applied promos carousel at the bottom of screen.</p>
<h1>5. Discovering Merchants</h1>
<h2>5.1 Search &amp; Browse</h2>
<ul>
<li>Open the Merchants tab.</li>
<li>You can add merchants to favourite so you can filter out the favourite merchant from search.</li>
<li>Use Search Merchants to find a specific store by name, or scroll the list of nearby merchants.</li>
<li>Tap a merchant to open its details page.</li>
<li>Use specific filters to search out specific merchants with location, distance, favourite merchants and Services.</li>
<li>The customer can view merchant's points and tier details and transaction history from merchant details screen.</li>
</ul>
<h2>5.2 Merchant Details</h2>
<p>The merchant details screen shows the store's description, address, contact information, active promotions, and a map location. From here you can view directions on the map details screen. User can view all information though merchant website.</p>
<h1>6. My Wallet</h1>
<p>The Wallet tab is where all your loyalty value lives — points, gift cards, vouchers, and transaction history.</p>
<h2>6.1 Points Balance</h2>
<p>Your current point balance by Merchant is shown at the top of respective Merchants Wallet screen, reflecting points earned from purchases and adjusted for any points already redeemed.</p>
<h2>6.2 Gift Cards</h2>
<p>The Gift Card list shows all gift cards issued to you. Each card is labelled as:</p>
<ul>
<li>Earned — gift cards you have received but not yet used.</li>
<li>Used — gift cards that have already been redeemed.</li>
</ul>
<p>Use the search bar on the gift card list to quickly find a specific card.</p>
<h2>6.3 Transaction History</h2>
<p>Every purchase, points-earning event, and redemption is recorded in Transaction History, giving you a full audit trail of your loyalty activity.</p>
<h1>7. Earning & Redeeming Points</h1>
<h3>7.1 Earning Points</h3>
<p>Earn loyalty points every time you make an eligible purchase from a participating business and unlock greater rewards as your loyalty grows:</p>
<ul>
<li>Visit a participating merchant and purchase an eligible product or service. You will receive loyalty points based on the earning percentage associated with your current loyalty tier for that business.</li>
<li>Continue visiting and transacting with the same merchant to accumulate loyalty points. As your points increase, you may qualify for higher loyalty tiers, allowing you to earn points at higher rates on future purchases.</li>
<li>Each loyalty point earned has a redemption value of PKR 10, which can be redeemed in accordance with the business redemption policy.</li>
<li>To maintain your current loyalty tier, you should make at least one eligible purchase with the business every six months. If no qualifying transaction is recorded during this period, your loyalty tier may be downgraded, resulting in a lower points earning rate for future purchases.</li>
</ul>
<h3>7.2 Redeeming Points</h3>
<p>When you want to use your points at checkout (in-store), you approve a redemption request from your app:</p>
<ul>
<li>From the Wallet or the merchant's checkout (New Sale) flow, choose Redeem Points.</li>
<li>Advise the Merchant the number of points you want to redeem.</li>
<li>Confirm the Redemption Request that comes on your customer app. The request is sent in real time from the merchant's point-of-sale device for approval.</li>
<li>Once the merchant confirms the transaction, your points balance and gift card wallet update automatically.</li>
</ul>
<p><strong>Note: </strong>Redemption requests are delivered instantly using a live connection between your app and the merchant's device, so make sure you have an internet connection while checking out.</p>
<h1>8. Special Promotions</h1>
<p>The Special Promotions screen lists every active promotion available to you, sorted by relevance and merchant. Recently viewed promotions are saved so you can quickly return to an offer you were considering.</p>
<h1>9. Referral Program</h1>
<p>Invite friends to join Rewaldo and you can be rewarded once they sign up.</p>
<ul>
<li>Open Profile and select Refer a Friend.</li>
<li>Share your personal referral link or code with a friend.</li>
<li>Your friend enters your referral ID when they sign up (Sign Up with Referral ID).</li>
<li>Once your friend purchases a paid membership you will receive your referral cash reward, that can be used to renew your next membership.</li>
<li>Track everyone you've invited on the Referred Friends list.</li>
</ul>
<h1>10. Notifications</h1>
<p>The app sends push notifications for new promotions, points earned, redemption confirmations, and account updates. Open the bell icon to view your Notifications list at any time.</p>
<h2>10.1 Notification Settings</h2>
<p>From Profile → Notification Settings you can turn specific notification types on or off according to your preference.</p>
<h1>11. Managing Your Profile</h1>
<h2>11.1 Edit Profile</h2>
<p>Update your name, photo, and contact details from Profile → Edit Profile Info.</p>
<h2>11.2 Change Password</h2>
<p>Go to Profile → Change Password, enter your current password, and set a new one.</p>
<h2>11.3 Preferences</h2>
<p>Set your preferred categories and communication preferences from the Preferences screen.</p>
<h2>11.4 Membership</h2>
<p>If your loyalty program includes a paid membership tier, the membership screen lets you view plan details and complete checkout for an upgraded membership. My Membership shows your current active plan.</p>
<h2>11.5 Contact Us, Privacy Policy &amp; Terms</h2>
<p>Support and legal information are always available from the Profile menu: Contact Us, Privacy Policy, and Terms &amp; Conditions.</p>
<h1>12. Troubleshooting &amp; Support</h1>
<p><strong>For any issue not covered here, reach out through Profile → Contact Us and our support team will assist you.</strong></p>
''';
