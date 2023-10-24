import 'package:flutter/material.dart';
import '../model/account.dart';
import 'accountsDatabase.dart';

class AccountEditScreen extends StatefulWidget {
  final account accountToEdit;

  AccountEditScreen({required this.accountToEdit});

  @override
  _AccountEditScreenState createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends State<AccountEditScreen> {
  late TextEditingController _displayNameController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(text: widget.accountToEdit.dispname);
    _firstNameController = TextEditingController(text: widget.accountToEdit.firstname);
    _lastNameController = TextEditingController(text: widget.accountToEdit.lastname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _displayNameController,
              decoration: InputDecoration(labelText: 'Display Name'),
            ),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print('Updating Account: ${_displayNameController.text}, ${_firstNameController.text}, ${_lastNameController.text}');
                account updatedAccount = widget.accountToEdit.copy(
                  dispname: _displayNameController.text,
                  firstname: _firstNameController.text,
                  lastname: _lastNameController.text,
                );

                accountsDatabase.instance.update(updatedAccount).then((value) {
                  print('Account updated successfully!');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Account updated successfully!'),
                  ));
                }).catchError((error) {
                  print('Error updating account: $error');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Error updating account: $error'),
                  ));
                });
                Navigator.pop(context, true);
              },
              child: Text('Save'),
            ),

          ],
        ),
      ),
    );
  }
}
