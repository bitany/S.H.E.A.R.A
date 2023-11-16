import 'package:flutter/material.dart';
import 'accountEdit.dart';
import 'accountsDatabase.dart';
import '../model/account.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AccountsMasterlist(),
    );
  }
}

class AccountsMasterlist extends StatefulWidget {
  @override
  _AccountsMasterlistState createState() => _AccountsMasterlistState();
}

class _AccountsMasterlistState extends State<AccountsMasterlist> {
  Future<void> _deleteAccount(int accountId) async {
    try {
      await accountsDatabase.instance.delete(accountId);
      setState(() {});
    } catch (e) {
      print('Error deleting account: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts List'),
      ),
      body: FutureBuilder<List<account>>(
        future: accountsDatabase.instance.getAllAccounts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<account> accounts = snapshot.data!;
            return ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                String authenticatedStatus = accounts[index].isAuthenticated ? 'Authenticated' : 'Not Authenticated';
                return ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${accounts[index].id}'),
                      Text('${accounts[index].dispname}'),
                      Text(authenticatedStatus),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${accounts[index].firstname} ${accounts[index].lastname}'),
                      Text('Definitely not the password: ${accounts[index].password}'),
                      Text('Account Creation Date: ${accounts[index].timeCreated}'),
                      Text('Last Seen Location: ${accounts[index].lastSeenLocation}'),
                      Text('Last Seen Time: ${accounts[index].lastSeenTime}'),
                      Text(accounts[index].needsHelp ? 'Inactive' : 'Needs Help'),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              bool newAuthStatus = !accounts[index].isAuthenticated;
                              accountsDatabase.instance.updateAuthenticationStatus(accounts[index].id!, newAuthStatus);
                              setState(() {
                                accounts[index].isAuthenticated = newAuthStatus;
                              });
                            },
                            child: Text(accounts[index].isAuthenticated ? 'Deauthenticate' : 'Authenticate'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AccountEditScreen(accountToEdit: accounts[index])));
                          if (result == true) {
                            setState(() {});
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteAccount(accounts[index].id!);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
