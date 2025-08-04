import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text('User Profile'),
              subtitle: Text('Manage your profile information'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Navigate to profile screen
              },
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notifications'),
                  subtitle: Text('Manage notification preferences'),
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // TODO: Handle notification toggle
                    },
                  ),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.dark_mode),
                  title: Text('Dark Mode'),
                  subtitle: Text('Toggle dark/light theme'),
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {
                      // TODO: Handle theme toggle
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text('Help & Support'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to help screen
                  },
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('About'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to about screen
                  },
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined),
                  title: Text('Privacy Policy'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to privacy policy
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                // TODO: Handle logout
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Logout'),
                    content: Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // TODO: Implement logout
                        },
                        child:
                            Text('Logout', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
