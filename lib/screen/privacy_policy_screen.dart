import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          _privacyText,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade800,
            height: 1.6, // Khoảng cách dòng cho dễ đọc
          ),
        ),
      ),
    );
  }

  // Chứa toàn bộ nội dung văn bản bạn cung cấp
  static const String _privacyText = '''
NIKE PRIVACY POLICY AND COOKIE POLICY

This privacy policy describes the personal data collected or generated (processed) when you interact with Nike through our websites (“Sites”), digital experiences, mobile applications, stores events, or one of our other products or services, all of which are part of Nike's Platform (“Platform”). It also explains how your personal data is used, shared and protected, what choices you have relating to your personal data and how you can contact us.

WHO is Responsible for the Processing of Your Personal Data?
The Nike entity responsible for the processing of your personal data will depend on how you interact with Nike’s Platform and where you are located in the world. The relevant Nike entity are referred to as “Nike”, “our”, “we” or “us” in this privacy policy.
Please review our List of Local Entities for the name of the Nike entity responsible and the appropriate contact information.

WHAT Personal Data Do We Collect and WHEN?
We ask you for certain personal data to provide you with the products or services you request. For example, when you make purchases, contact our consumer services, request to receive communications, create an account, participate in our events or contests, or use our Platform. Additionally, when you request specific services in store, we may ask you to login to provide services that are then associated with your account (e.g. size, fit, preferences). 
This personal data includes your:
• contact details including name, email, telephone number and shipping and billing address;
• login and account information, including screen name, password and unique user ID;
• personal details including gender, hometown, date of birth and purchase history;
• payment or credit card information;
• images, photos and videos;
• data on physical characteristics, including weight, height, and body measurements (such as estimated stride and shoe/foot measurements or apparel size);
• fitness activity data provided by you or generated through our Platform (time, duration, distance, location, calorie count, pace/stride); or
• personal preferences including your wish list as well as marketing and cookie preferences.

We collect additional personal data from you to enable particular features within our Platform. For example, we request access to your phone’s location data to log your run route, your contacts to allow you to interact with your friends, your calendar to schedule a training plan or your social network credentials to post content from our Platform to a social network. This personal data includes your:
• movement data from your device’s accelerometer;
• photos, audio, contacts and calendar information;
• sensor data, including heart rate and (GPS) location data; or
• social network information, including credentials and any information from your public posts about Nike or your communications with us.

When interacting with our Platform, certain data is automatically collected from your device or web browser. More information about these practices is included in the “ABOUT COOKIES AND SIMILAR TECHNOLOGIES” section of this privacy policy below. This data includes:
• Device IDs, call state, network access, storage information and battery information; and
• Cookies, IP addresses, referrer headers, data identifying your web browser and version, and web beacons, tags and interactions with our Platform.

KIDS
We comply with local laws and do not allow children to register on our Platform when they are under the legal age limit of the country in which they reside. We will ask for parental consent for children participating in Nike experiences and events.

TOOLS to Manage What Personal Data We Collect
When using our Platform, we also provide in-time notice or obtain consent for certain practices. For example, we will obtain consent to use your location or send push notifications. We may obtain this consent through the Platform or using the standard permissions available on your device.
In many cases, your web browser or mobile device platform will provide additional tools to allow you to control when your device collects or shares particular categories of personal data. For example, your mobile device or web browser may offer tools to allow you to manage cookie usage or location sharing. We encourage you to familiarize yourself with and use the tools available on your devices.

WHY and HOW Do We Use Your Personal Data?
We use your personal data in the following ways:
To Provide the Features of the Platform and Services You Request...
(This data is processed as necessary to provide services and communicate with you about your account or purchase).

To Communicate Information about our Products, Services, Events and for Other Promotional Purposes
When you consent, we will send you marketing communications and news concerning Nike’s products, services, events and other promotions that may be of interest to you. You can opt-out at any time after you have given your consent.

Direct Marketing
If you are an existing customer of Nike (for example, if you have placed an order with us), we may use the contact details you provided to send you marketing communications about similar Nike products or services where permitted by applicable law (unless you have opted-out). In other cases, we ask for your consent to send you marketing information.

Personalization
We may use the information that you provide to us as well as information from other Nike products or services - such as your use of Nike’s Platform, your visits to or purchases made in Nike stores, your participation in Nike events and contests - to personalize communications on products and services that may be interesting for you. In doing so, we may combine the information you provide to us with information that we create about your online activity, including internal insights and analysis.

To Operate, Improve and Maintain our Business, Products and Services
We use the personal data you provide to us to operate our business. For example, when you make a purchase, we use that information for accounting, audits and other internal functions. We may use personal data about how you use our products and services to enhance your user experience and to help us diagnose technical and service problems and administer our Platform.

To Protect Our or Others' Rights, Property or Safety
We may also use personal data about how you use our Platform to prevent, detect or investigate fraud, abuse, illegal use, violations of our Terms of Use, and to comply with court orders, governmental requests or applicable law.

For General Research and Analysis Purposes
We use data about how our visitors use our Platform and services to understand customer behavior or preferences. For example, we may use information about how visitors to Nike.com search for and find products to better understand the best ways to organize and present product offerings in our storefront.  

Use (Processing) of Workout Info
As discussed above, Nike collects data about your fitness activity or your physical characteristics , together, “Workout Info”, to provide our services on our Platform. Because of the personal nature of this data, we strive to provide you with clear information about how Workout Info will be used. As this data may be considered sensitive in certain jurisdictions, we take appropriate measures in protecting and using this data and, where required by applicable law or under Nike’s internal policies, will obtain your consent for use of your Workout Info. Click here to learn more.

Other Purposes
We may also use your personal data in other ways and will provide specific notice at the time of collection and obtain your consent where necessary.

Legal Grounds
To process your personal data, we rely on certain legal grounds, depending on how you interact with our Platform.
When you purchase Nike products from our Platform, we need your personal data to fulfill our contract with you. For example, we need your payment and contact details to deliver your order.
When you use our Apps, we rely on your consent for processing and for certain limited purposes to fulfill our contract with you (for example, for in-App purchases). 
We also rely on other legal grounds, such as our legitimate interests as a business to process information about the effectiveness of our marketing campaigns, our products, services, events and other promotional initiatives; to operate, improve and maintain our business, products and services; to protect our or others' rights, property or safety; and for general research and analysis purposes. When processing personal data for our legitimate interests, we take appropriate measures to ensure that the interests we pursue are balanced with your interests, rights and freedoms, which we are happy to explain upon request.
We also process your personal data, to comply with a legal obligation, or to protect your vital interests.

SHARING of Your Personal Data
Nike’s Sharing
Nike shares your personal data with:
Nike entities for the purposes and under the conditions outlined above. 
Service providers processing personal data on Nike’s behalf, for example to process credit cards and payments, shipping and deliveries, host, manage and service our data, distribute emails, research and analysis, manage brand and product promotions as well as administering certain services and features.  When using service providers we enter into agreements that require them to implement appropriate technical and organizational measures to protect your personal data.
Other third parties to the extent necessary to: (i) comply with a government request, a court order or applicable law; (ii) prevent illegal uses of our Platform or violations of our Platform’s Terms of Use and our policies; (iii) defend ourselves against third party claims; and (iv) assist in fraud prevention or investigation (e.g., counterfeiting). 
Third-party targeted advertising providers that provide personalization ad tailored advertising services to us.  We use such services to match information that we hold with personal data in their database to create custom audiences and tailor advertising to your interests on the Internet, including social media, as permitted by applicable law. You may opt-out of personalized advertising and custom audiences by using the relevant settings in our Platform.
To any other third party where you have provided your consent.
We may also transfer personal data we have about you in the event we sell or transfer all or a portion of our business or assets (including in the event of a reorganization, spin-off, dissolution or liquidation).

Your Sharing
When you use certain social features on our Platform, you can create a public profile that may include information such as your screen name, profile picture and hometown. You can also share content with your friends or the public, including information about your Nike activity. We encourage you to use the tools we provide for managing Nike’s social sharing to control what information you make available through Nike’s social features.

PROTECTION and MANAGEMENT of Your Personal Data
Encryption & Security 
We use a variety of technical and organizational security measures, including encryption and authentication tools, to maintain the safety of your personal data.

International Transfers of your Personal Data
The personal data we collect (or process) in the context of our Platform will be stored in the USA and other countries. Some of the data recipients with whom Nike shares your personal data may be located in countries other than the country in which your personal data originally was collected. The laws in those countries may not provide the same level of data protection compared to the country in which you initially provided your data. Nevertheless, when we transfer your personal data to recipients in other countries, including the USA, we will protect that personal data as described in this privacy policy and in compliance with applicable law.
We use a variety of measures to ensure that your personal data receives adequate protection in accordance with data protection rules. Where personal data is transferred within Nike, we use an intragroup data transfer agreement.

Retention of your Personal Data 
Your personal information will be retained for as long as is necessary to carry out the purposes set out in this privacy policy (unless a longer retention period is required by applicable law). In general, this means that we will keep your personal data for as long as you keep your Nike account. For personal data related to product purchases, we retain this longer to comply with legal obligations (such as tax and sales laws and for warranty purposes). Click here to learn more for Australia, India, Indonesia, New Zealand, Singapore, Taiwan, Thailand.

YOUR RIGHTS Relating to Your Personal Data
You have the right to request: (i) access to your personal data; (ii) an electronic copy of your personal data (portability) and to have this information transmitted to another company; (iii) correction of your personal data if it is incomplete or inaccurate; or (iv) deletion or restriction of your personal data in certain circumstances provided by applicable law. These rights are not absolute. Where we have obtained your consent for the processing of your personal data, you have the right to withdraw your consent at any time.
If you like would to request a copy of your personal data or exercise any of your other rights, please email us at privacy@nike.com.

Opting Out of Direct Marketing
If you have a Nike account, you can opt-out of receiving Nike’s marketing communications by modifying your preferences in the "My Account->Account Settings" section of our Platform. You can also opt-out by modifying your email or SMS subscriptions by clicking on the unsubscribe link or following the opt-out instructions included in the message.  You can also contact us using the contact details in the “Question and Feedback” section below.

ABOUT COOKIES and SIMILAR TECHNOLOGIES
Nike, our service providers, and third parties collect information—which may include personal information—from your browser, devices, or apps when you use our Platform. We use a variety of methods, such as cookies, pixel tags, identifiers for mobile devices, and other similar technologies. The information collected by these tools may include your (i) IP address; (ii) unique cookie identifier, cookie information and information on whether your device has software to access certain features; (iii) unique device identifier and device type; (iv) domain, browser type and language, (v) operating system and system settings; (vi) country and time zone; (vii) previously visited websites; (viii) information about your interaction with our Platform such as click behavior, purchases and indicated preferences; and (ix) access times and referring URLs. 

We use cookies and similar technologies to analyze how you access and use our Platform, remember your preferences (such as country and language), secure and optimize our Platform, improve performance, and enhance your overall experience. These tools also help us understand usage trends and conduct analytics to improve our services. 

We also use cookies and similar technologies for personalized advertising and content across our Platform and third-party sites. This includes: 

Personalized Advertising: We may share data about how you use our site and apps with advertising partners. This data is used to serve you with relevant ads and enhance and report on the personalized advertising experience on partner sites. 

Profile-Based Personalized Advertising: We may also share certain personal identifiers—such as your email address or phone number—with advertising partners to personalize advertising based on your interests and to measure the effectiveness of ads shown on partner sites. 

See more about managing your preferences below .

Third-Party Technologies and Services 
Some cookies and similar technologies are operated by third-party service providers. We use third-party services such as Google Analytics, Google Signals, Google Ads, and reCAPTCHA. These services may collect data through cookies and similar tools for purposes including analytics, security, performance optimization, and advertising. The use of data by these third parties is subject to their own privacy policies. In some cases, the processing of this data is subject to these third parties’ privacy policies. For more information about how Google Analytics collects and uses data when you visit our Platform, visit www.google.com/policies/privacy/partners, and to opt out of Google Analytics, tools.google.com/dlpage/gaoptout/.  

You may see Nike ads on other websites and apps, including those of our advertising partners. These partners may track your activity over time and across platforms through automated means to deliver interest-based advertising. 

Managing Your Cookie and Advertising Preferences 
We provide several options for managing cookies and advertising preferences: 
In-Platform Controls: You can manage your Personalized Advertising and profile-based Personalized Advertising preferences in your Privacy Settings. While logged out, your selections apply only to your current browser and device. To apply your preferences across all Nike experiences, please sign in to your Nike Membership.  

Mobile Settings: You can adjust your advertising preferences on your mobile device at the device level. For example, turn off new app tracking requests, adjust your tracking preferences in iOS, visit Settings > Privacy & Security > Tracking. To adjust your advertising preferences in Android, visit Settings > Google > Ads > Opt out of interest-based ads. 

Browser Settings: Your browser may offer choices to manage your cookies, including blocking all or third-party cookies. You do this through your browser settings on each browser and device that you use. Each browser is a little different, so look at your browser “Help” menu to learn the correct way to modify your cookies. If you turn cookies off, you may not have access to many features that make our Platform more efficient and some of our services will not function properly. 

Please note that opting out of personalized or profile-based advertising does not mean you will stop seeing ads altogether, but they may not be as relevant to you or based on your interests or activity on Nike.  
USING Nike Platform with Third-Party Products and Services
Our Platform allow you to interact with a wide variety of other digital products and services.  For example, our Platform can integrate with third-party devices for activity tracking, social networks, music streaming services and other digital services.
If you choose to connect your Nike account with a third-party device or account, your privacy rights on third-party platforms will be governed by their respective policies.  For example, if you choose to share your Nike activity on third-party social media platforms, the policies of those platforms govern the data that resides there.
Our Platform may provide links to other (third-party) websites and apps for your convenience or information. Linked sites and apps have their own privacy notices or policies, which we strongly encourage you to review. To the extent any linked websites or apps are not owned or controlled by us, we are not responsible for their content, any use of the websites or apps, or the privacy practices of the websites or apps.

CHANGES to Our Privacy Policy
Applicable law and our practices change over time. If we decide to update our privacy policy, we will post the changes on our Platform. If we materially change the way in which we process your personal data, we will provide you with prior notice, or where legally required, request your consent prior to implementing such changes. We strongly encourage you to read our privacy policy and keep yourself informed of our practices. This privacy policy was last modified in June 2025.

QUESTIONS and Feedback
We welcome questions, comments, and concerns about our privacy policy and privacy practices. If you wish to provide feedback or if you have questions or concerns or wish to exercise your rights related to your personal data, please contact us via: (i) the “Contact Us” section of our website; or (ii) an email to privacy@nike.com; or (iii) our Privacy Office at: our Privacy Office at: 30 Pasir Panjang Rd, #10-31, Maple Tree Business City, Singapore 117440
If you contact us with a privacy complaint it will be assessed with the aim of resolving the issue in a timely and effective manner.
  ''';
}