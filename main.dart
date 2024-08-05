// lib/main.dart
import 'package:flutter/material.dart';
import 'package:lienhe/models/contact.dart';
import 'package:lienhe/data/contacts.dart';
import 'package:url_launcher/url_launcher.dart'; // Đảm bảo bạn đã thêm gói này vào pubspec.yaml

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'danh sách các liên hệ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactListScreen(),
    );
  }
}

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final List<Contact> contacts = getContacts();

  void _addContact(Contact contact) {
    setState(() {
      contacts.add(contact);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('danh sách các liên hệ'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            title: Text(contact.name),
            subtitle: Text(contact.phone),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactDetailScreen(contact: contact),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newContact = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddContactScreen()),
          );
          if (newContact != null) {
            _addContact(newContact);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddContactScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm liên hệ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập Email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newContact = Contact(
                      name: _nameController.text,
                      phone: _phoneController.text,
                      email: _emailController.text,
                    );
                    Navigator.pop(context, newContact);
                  }
                },
                child: Text('Thêm liên hệ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Màn hình chi tiết liên hệ
class ContactDetailScreen extends StatelessWidget {
  final Contact contact;

  ContactDetailScreen({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phone: ${contact.phone}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Email: ${contact.email}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _makePhoneCall(contact.phone);
                  },
                  icon: Icon(Icons.call),
                  label: Text('Call'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _sendSMS(contact.phone);
                  },
                  icon: Icon(Icons.message),
                  label: Text('SMS'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Hàm để gọi điện
  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Xử lý trường hợp không thể gọi điện
      print('Could not launch $launchUri');
    }
  }

  // Hàm để nhắn tin
  void _sendSMS(String phoneNumber) async {
    final Uri smsUri = Uri(
        scheme: 'sms',
        path: phoneNumber,
        queryParameters: {'body': 'Xin chào, Tin nhắn này được gửi tới bạn và chúc bạn một ngày tốt lành'} // Tin nhắn mặc định
    );
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      // Xử lý trường hợp không thể nhắn tin
      print('Could not launch $smsUri');
    }
  }
}