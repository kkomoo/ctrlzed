import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String firstName = '';
  String middleName = '';
  String lastName = '';
  String age = '';
  String sex = '';
  String dateOfBirth = '';
  String homeAddress = '';
  String emergencyContact = '';
  String dateAdded = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Profile picture and name section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      'assets/profile.jpg'), // Replace with your image asset
                ),
                const SizedBox(height: 10),
                Text(
                  '$firstName $lastName',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showEditProfileDialog(context);
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Details section
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  ProfileDetailField(title: 'First name', value: firstName),
                  ProfileDetailField(title: 'Middle Name', value: middleName),
                  ProfileDetailField(title: 'Last Name', value: lastName),
                  ProfileDetailField(title: 'Age', value: age),
                  ProfileDetailField(title: 'Sex', value: sex),
                  ProfileDetailField(
                      title: 'Date of Birth', value: dateOfBirth),
                  ProfileDetailField(title: 'Home Address', value: homeAddress),
                  ProfileDetailField(
                      title: 'Emergency Contact', value: emergencyContact),
                  ProfileDetailField(title: 'Date Added', value: dateAdded),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final TextEditingController firstNameController =
        TextEditingController(text: firstName);
    final TextEditingController middleNameController =
        TextEditingController(text: middleName);
    final TextEditingController lastNameController =
        TextEditingController(text: lastName);
    final TextEditingController ageController =
        TextEditingController(text: age);
    final TextEditingController sexController =
        TextEditingController(text: sex);
    final TextEditingController dateOfBirthController =
        TextEditingController(text: dateOfBirth);
    final TextEditingController homeAddressController =
        TextEditingController(text: homeAddress);
    final TextEditingController emergencyContactController =
        TextEditingController(text: emergencyContact);
    final TextEditingController dateAddedController =
        TextEditingController(text: dateAdded);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ProfileDetailField(
                    title: 'First name',
                    controller: firstNameController,
                    isEditing: true),
                ProfileDetailField(
                    title: 'Middle Name',
                    controller: middleNameController,
                    isEditing: true),
                ProfileDetailField(
                    title: 'Last Name',
                    controller: lastNameController,
                    isEditing: true),
                ProfileDetailField(
                    title: 'Age', controller: ageController, isEditing: true),
                ProfileDetailField(
                  title: 'Sex',
                  controller: sexController,
                  isEditing: true,
                  isDropdown: true,
                  dropdownItems: ['Male', 'Female'],
                ),
                ProfileDetailField(
                    title: 'Date of Birth',
                    controller: dateOfBirthController,
                    isEditing: true,
                    showCalendarIcon: true),
                ProfileDetailField(
                    title: 'Home Address',
                    controller: homeAddressController,
                    isEditing: true),
                ProfileDetailField(
                    title: 'Emergency Contact',
                    controller: emergencyContactController,
                    isEditing: true,
                    isPhoneNumber: true),
                ProfileDetailField(
                    title: 'Date Added',
                    controller: dateAddedController,
                    isEditing: false),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Save the changes and close the dialog
                setState(() {
                  firstName = firstNameController.text;
                  middleName = middleNameController.text;
                  lastName = lastNameController.text;
                  age = ageController.text;
                  sex = sexController.text;
                  dateOfBirth = dateOfBirthController.text;
                  homeAddress = homeAddressController.text;
                  emergencyContact = emergencyContactController.text;
                  dateAdded = dateAddedController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}

class ProfileDetailField extends StatelessWidget {
  final String title;
  final String value;
  final bool isEditing;
  final bool showCalendarIcon;
  final bool isPhoneNumber;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final TextEditingController? controller;

  const ProfileDetailField({
    super.key,
    required this.title,
    this.value = '',
    this.isEditing = false,
    this.showCalendarIcon = false,
    this.isPhoneNumber = false,
    this.isDropdown = false,
    this.dropdownItems,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          if (isDropdown && dropdownItems != null)
            DropdownButtonFormField<String>(
              value:
                  controller?.text.isNotEmpty == true ? controller?.text : null,
              items: dropdownItems!
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged:
                  isEditing ? (value) => controller?.text = value ?? '' : null,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: isEditing ? Colors.white : Colors.grey.shade200,
              ),
            )
          else
            TextField(
              controller: controller,
              enabled: isEditing,
              keyboardType:
                  isPhoneNumber ? TextInputType.phone : TextInputType.text,
              inputFormatters: isPhoneNumber
                  ? [
                      LengthLimitingTextInputFormatter(11),
                      FilteringTextInputFormatter.digitsOnly,
                    ]
                  : null,
              decoration: InputDecoration(
                hintText: value,
                hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: isEditing ? Colors.white : Colors.grey.shade200,
                suffixIcon: showCalendarIcon
                    ? IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (selectedDate != null) {
                            controller?.text =
                                DateFormat('yyyy-MM-dd').format(selectedDate);
                          }
                        },
                      )
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}
