import 'package:flutter/material.dart';

class GenderDropdown extends StatefulWidget {
  @override
  _GenderDropdownState createState() => _GenderDropdownState();
}

class _GenderDropdownState extends State<GenderDropdown> {
  String selectedGender = 'Male';

  List<String> genderOptions = [
    'Male',
    'Female',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        items: genderOptions.map((String gender) {
          return DropdownMenuItem<String>(
              value: gender,
              child: Text(gender,
                  style: const TextStyle(
                    color: Colors.white,
                  )));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedGender = newValue!;
          });
        },
        dropdownColor: Colors.grey[900],
        decoration: InputDecoration(
          hintText: 'Gender',
          hintStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.grey[900],
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
