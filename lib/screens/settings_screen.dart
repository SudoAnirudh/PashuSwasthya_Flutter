import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pashu_swasthya/utils/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _saveUserInfo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: AppTheme.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('General'),
            const SizedBox(height: 10),
            _buildSettingsTile(
              icon: Icons.language,
              title: 'Language',
              trailing: 'English',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.notifications,
              title: 'Notifications',
              trailingWidget: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.account_circle,
              title: 'Account',
              onTap: () {},
            ),
            const SizedBox(height: 30),
            _buildSectionTitle('Data & Offline'),
            const SizedBox(height: 10),
            _buildSettingsTile(
              icon: Icons.sync,
              title: 'Offline Data Update',
              subtitle: 'Last sync: 2 hours ago',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.save,
              title: 'Save User Info',
              trailingWidget: Switch(
                value: _saveUserInfo,
                onChanged: (value) {
                  setState(() {
                    _saveUserInfo = value;
                  });
                },
              ),
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.delete,
              title: 'Clear Cache',
              onTap: _showClearCacheDialog,
            ),
            const SizedBox(height: 30),
            _buildSectionTitle('About'),
            const SizedBox(height: 10),
            _buildSettingsTile(
              icon: Icons.info,
              title: 'About PashuSwasthya',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.help,
              title: 'Help & Support',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    String? trailing,
    Widget? trailingWidget,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryGreen),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              )
            : null,
        trailing: trailingWidget ??
            (trailing != null
                ? Text(
                    trailing,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  )
                : Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textSecondary)),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppTheme.textSecondary,
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear the cache?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement cache clearing logic
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
