import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Terms of Use',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          _termsText,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade800,
            height: 1.6, 
          ),
        ),
      ),
    );
  }

  // Toàn bộ nội dung văn bản Điều khoản sử dụng của Nike
  static const String _termsText = '''
NIKE TERMS OF USE
Date of last revision: October 2025
Welcome to the NIKE community!
PLEASE READ THESE NIKE TERMS OF USE (“TERMS”) CAREFULLY BEFORE USING ANY NIKE SERVICES OR PRODUCTS OR PARTICIPATING IN ANY NIKE EXPERIENCES.
These Terms apply to the NIKE websites, social media platforms, and mobile apps (the “Platform”); the digital experiences, membership program(s), and other services accessible through or enabled by the Platform (together with the Platform, the “Services”); the footwear, apparel, equipment, accessories, and other products sold or otherwise provided by NIKE (“Products”); and the experiences and events hosted by NIKE or in NIKE stores (“Experiences”).

These Terms create a legally binding agreement between you and NIKE regarding your use of Services and Products and your participation in Experiences. If you live in any of the following countries or regions, additional or alternative provisions of these Terms (set forth below) may apply to you: Argentina, Australia, Brazil, Canada, Colombia, Hong Kong, Indonesia, Japan, Philippines, Thailand, Vietnam, and all European countries. 

When we say “NIKE,” “we,” “us,” or “our,” we are referring to the NIKE entity responsible for providing the Services, Products, or Experiences in your country or region. Please review our List of Local Entities for the NIKE entities responsible for providing the Services, Products and Experiences to you. You enter into these Terms with each applicable NIKE entity.

TERMS APPLICABLE TO YOU

Updates
We may update these Terms from time to time. The “date of last revision” above indicates when these Terms were last updated. If we make updates, we may also send you a notification. Unless we indicate otherwise, updated Terms will be effective immediately upon posting and your continued use of the Services, purchase of additional Products, or participation in Experiences will confirm your acceptance of the updates.

Supplemental Terms
We may indicate that different or additional terms, conditions, guidelines, policies, or rules apply in relation to some of our Services, Products, or Experiences (“Supplemental Terms”). Any Supplemental Terms become part of your agreement with us if you use the applicable Services, Products or Experiences, and if there is a conflict between these Terms and the Supplemental Terms, the Supplemental Terms will control for that conflict.

Terms of Sale
By purchasing a Product from us, you also agree to the Terms of Sale that apply in your country or region. The Terms of Sale are Supplemental Terms. For information about how to return Products, see the Return Policy that applies in your country or region.

Privacy
Our Privacy Policy describes how NIKE collects, uses, shares, and otherwise processes information about you.

Accessibility
Our Digital Accessibility page explains how NIKE Services are accessible to all users, including individuals with disabilities.
 
Amateur Athlete Eligibility
You are responsible for ensuring that your use of the Services and Products and your participation in Experiences does not affect your eligibility as an amateur athlete. Please check with your amateur athletic association for the rules that apply to you. NIKE is not responsible or liable if your use of the Services and Products or your participation in Experiences results in your ineligibility as an amateur athlete.

GROUND RULES

Eligibility
If you are younger than the legal age of majority where you live, you may only use the Services under the supervision of a parent or guardian who also agrees to these Terms. There may be additional age restrictions on Services or Experiences in certain countries or regions.

Account Registration
When you register for a NIKE account, the following rules apply:
• Be True: Provide accurate registration information and keep your account information up to date.
• Be You: Your account is for your personal use only. Do not register for more than one account, register an account on behalf of someone else, or transfer your account to someone else.
• Be Secure: Keep your username, password, and other login credentials secure and do not allow anyone else to use your account.
• Be Responsible: Inform us immediately of any unauthorized use of your account. You are responsible for anything that happens through your account – with or without your permission.

Devices
You may access the Services through a computer, mobile phone, tablet, console, or other technology (a “Device”). You agree to receive transactional and other emails, SMS and text messages from NIKE at the email address or other contact information you provide. Your carrier's normal data and text message rates and fees apply to your Device.

NIKE CONTENT

Content We Own
Except for your User Content (defined below), all of the content on our Services, including text, software, scripts, code, designs, graphics, photos, sounds, music, videos, applications, interactive features, articles, news stories, sketches, animations, stickers, general artwork and other content ("Content"), is owned by NIKE or our licensors and is protected by copyright, trademark, patent and other laws. Content is part of the Services, and you may only use the Services as expressly permitted by these Terms. NIKE reserves all rights not expressly granted to you in these Terms.

License to Use
Subject to your compliance with these Terms, NIKE grants you a limited, non-exclusive, non-transferable, non-sublicensable, revocable license to access and use our Services for your own personal, noncommercial use and, solely with respect to any applications included as part of the Services, to install and use such applications on Devices that you own or control. 

USER CONTENT

Content You Submit
Some parts of the Services may allow you and other users to create, post, store, share, or otherwise provide content including photos, videos, and text (“User Content”). NIKE is not responsible for User Content. Except for the license you grant NIKE below, as between you and NIKE, you retain all rights in and to your User Content, excluding any portion of the Services included in your User Content.

License to Use
You grant NIKE and its subsidiaries and affiliates a non-exclusive, perpetual, irrevocable, transferable, sub-licensable, royalty-free, worldwide and fully paid license to use, reproduce, modify, adapt, publish, translate, create derivative works from, distribute, publicly or otherwise perform and display, and exploit your User Content.

Right to User Content
You represent and warrant that your User Content, and our use of such User Content as permitted by these Terms, will not violate any rights of any person or entity, including any third-party rights, or cause injury to any person or entity.

FEEDBACK AND IDEAS
We typically do not review unsolicited suggestions, ideas, feedback, or other materials that you post, submit, or otherwise communicate to us about NIKE or our Services, Products, or Experiences (collectively, “Feedback”). However, any Feedback you send us is provided on a non-confidential basis and you grant NIKE a license to use such Feedback for any purpose.

USER CODE OF CONDUCT
We’re excited to have you contribute to the NIKE community. However, you are solely responsible for your conduct while using our Services or Products or participating in our Experiences and you must comply with the rules.
• Be Yourself. Do not impersonate or otherwise misrepresent your affiliation with any person or organization.
• Be Original. Do not create, post, store, or share any User Content if you do not have all the rights necessary.
• Be Safe. Take precautions when interacting with other users.
• Be Considerate. Do not do anything that may expose NIKE or its users to any type of harm.
• Be Respectful. You may only use the Services for their intended and authorized purposes.
• Be Appropriate. Respect the community and do not post User Content that is illegal or objectionable.

COPYRIGHT INFRINGEMENT
NIKE has adopted a policy of terminating, in appropriate circumstances, the accounts of users found to infringe the intellectual property rights of others.

PARTNERS ON THE PLATFORM
From time to time, NIKE may link to, provide information about, partner with, or allow you to connect your NIKE account with third-party websites. NIKE is not responsible for the content, policies, or activities of Third Parties.

PHYSICAL ACTIVITY & SAFETY
The Services and Experiences may include features that provide information about physical activity. Content is provided for educational and informational purposes only and are not intended as medical advice. YOU ASSUME THE RISKS ASSOCIATED WITH ANY PHYSICAL ACTIVITIES THAT YOU ENGAGE IN.

INDEMNIFICATION
To the fullest extent permitted by applicable law, you agree to and will indemnify and hold harmless NIKE, Inc. and its subsidiaries from all claims, losses, liabilities, expenses, damages and costs.

WARRANTIES; DISCLAIMERS
Your use of our Services and Products is at your sole risk. Our Products, Services, Experiences are provided “AS IS” and “AS AVAILABLE” without any representation or warranties of any kind.

LIMITATION OF LIABILITY
TO THE FULLEST EXTENT PERMITTED BY APPLICABLE LAW, NEITHER NIKE NOR ANY OF THE NIKE PARTIES WILL BE LIABLE TO YOU FOR ANY DIRECT, SPECIAL, INCIDENTAL, INDIRECT, EXEMPLARY OR CONSEQUENTIAL DAMAGES.

MODIFICATION AND TERMINATION
NIKE may terminate or modify all or part of any Services at any time without notice. NIKE may terminate or suspend your account at any time and for any reason.

DISPUTES, JURISDICTION, VENUE
Any disputes will be governed by and in all respects construed and enforced in accordance with Oregon law, except where specific country/region laws apply (such as Vietnam).

VIETNAM SPECIFIC TERMS
If you live in Vietnam, the following terms apply and/or supersede any inconsistent terms:
Language: These Terms are made in both the English and the Vietnamese. Both texts are equally valid. In case of any inconsistency, the text that is interpreted more favorably to you will prevail.
  ''';
}