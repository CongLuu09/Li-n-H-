// lib/data/contacts.dart
import '../models/contact.dart';

// Sử dụng List để lưu trữ và quản lý danh sách các liên hệ.
List<Contact> getContacts() {
  return [
    Contact(name: 'Alice', phone: '123-456-7890', email: 'alice@example.com'),
    Contact(name: 'Bob', phone: '987-654-3210', email: 'bob@example.com'),
    // Thêm các liên hệ khác
  ];
}
