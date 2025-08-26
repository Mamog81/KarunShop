import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/constants.dart'; // Import Constants for colors

class SupportScreen extends StatelessWidget {
  // اطلاعات تماس را با داده‌های واقعی خود جایگزین کنید
  final String supportEmail = 'support@Nikashop.com';
  final String supportPhone = '+98-917-271-7133';

  // Example FAQ data
  final List<Map<String, String>> faqs = [
    {
      'question': 'How can I track my order?',
      'answer': 'Use the tracking link provided in your order confirmation email.',
    },
    {
      'question': 'What are your working hours?',
      'answer': 'Our support team is available from 9 AM to 5 PM (EST), Monday to Friday.',
    },
    {
      'question': 'Can I modify my order after placing it?',
      'answer': 'Order modifications are only possible within 2 hours of placement. Please contact us immediately.',
    },
  ];

  // Function to launch email client
  void _launchEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: 'subject=Support Inquiry&body=Dear Support Team,',
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open email app. Please email us at $supportEmail')),
      );
    }
  }

  // Function to launch phone dialer
  void _launchPhone(BuildContext context) async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: supportPhone,
    );
    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open dialer. Please call us at $supportPhone')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support & Contact'),
        backgroundColor: Constants.nBlue, // Use nBlue from the palette for AppBar
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Contact Information Section ---
            Text(
              'Contact Information',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Constants.nCharcoal, // Title color from palette
              ),
            ),
            SizedBox(height: 10),

            // 1. Email Tile
            Card(
              color: Constants.nGrey, // Light grey background for cards
              child: ListTile(
                leading: Icon(Icons.email, color: Constants.nBlue), // Email icon with nBlue color
                title: Text('Email Support', style: TextStyle(color: Constants.nBlue)),
                subtitle: Text(supportEmail),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Constants.nBlue),
                onTap: () => _launchEmail(context),
              ),
            ),

            // 2. Phone Tile
            Card(
              color: Constants.nGrey, // Light grey background for cards
              child: ListTile(
                leading: Icon(Icons.phone, color: Constants.nGreen), // Green color for phone icon
                title: Text('Call Us', style: TextStyle(color: Constants.nGreen)),
                subtitle: Text(supportPhone),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Constants.nGreen),
                onTap: () => _launchPhone(context),
              ),
            ),

            SizedBox(height: 30),

            // --- FAQ Section ---
            Text(
              'Frequently Asked Questions (FAQ)',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Constants.nCharcoal, // Title color from palette
              ),
            ),
            Divider(height: 20, thickness: 1, color: Constants.nBlue),

            ...faqs.map((faq) {
              return ExpansionTile(
                title: Text(
                  faq['question']!,
                  style: TextStyle(fontWeight: FontWeight.w600, color: Constants.nCharcoal),
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        faq['answer']!,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
