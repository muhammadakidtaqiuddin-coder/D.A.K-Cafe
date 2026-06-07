import 'package:flutter/material.dart';
import 'package:dak_cafe/login.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _name;
  late String _email;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _name = (widget.user['name'] as String?)?.isNotEmpty == true
        ? widget.user['name'] as String
        : widget.user['username'] as String;
    _email = (widget.user['email'] as String?)?.isNotEmpty == true
        ? widget.user['email'] as String
        : '';
  }

  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _name);
    final emailCtrl = TextEditingController(text: _email);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Profile', style: TextStyle(color: Color(0xFF1E2A78), fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF1E2A78)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF1E2A78)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _name = nameCtrl.text.trim().isEmpty ? _name : nameCtrl.text.trim();
                _email = emailCtrl.text.trim().isEmpty ? _email : emailCtrl.text.trim();
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated!'), behavior: SnackBarBehavior.floating),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E2A78), foregroundColor: Colors.white),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    bool obscureOld = true, obscureNew = true, obscureConfirm = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Change Password', style: TextStyle(color: Color(0xFF1E2A78), fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldCtrl,
                obscureText: obscureOld,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF1E2A78)),
                  suffixIcon: IconButton(
                    icon: Icon(obscureOld ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setDlgState(() => obscureOld = !obscureOld),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newCtrl,
                obscureText: obscureNew,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF1E2A78)),
                  suffixIcon: IconButton(
                    icon: Icon(obscureNew ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setDlgState(() => obscureNew = !obscureNew),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmCtrl,
                obscureText: obscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF1E2A78)),
                  suffixIcon: IconButton(
                    icon: Icon(obscureConfirm ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setDlgState(() => obscureConfirm = !obscureConfirm),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (newCtrl.text != confirmCtrl.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match!'), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating),
                  );
                  return;
                }
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password changed successfully!'), behavior: SnackBarBehavior.floating),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E2A78), foregroundColor: Colors.white),
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker() {
    final languages = ['English', 'Bahasa Malaysia', '中文', 'Tamil'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Select Language', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E2A78))),
          ),
          ...languages.map((lang) => ListTile(
            title: Text(lang),
            trailing: _selectedLanguage == lang
                ? const Icon(Icons.check, color: Color(0xFF1E2A78))
                : null,
            onTap: () {
              setState(() => _selectedLanguage = lang);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Language set to $lang'), behavior: SnackBarBehavior.floating),
              );
            },
          )),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: const Text('Account',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2A78))),
              ),

              // PROFILE CARD
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: Color(0xFF1E2A78),
                      child: Icon(Icons.person, color: Colors.white, size: 36),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1E2A78))),
                        const SizedBox(height: 4),
                        Text(_email, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _showEditProfileDialog,
                      child: const Icon(Icons.edit_outlined, color: Color(0xFF1E2A78)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // REWARDS CARD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF1E2A78), Color(0xFF3B4FCC)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DAK Rewards', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          SizedBox(height: 6),
                          Text('1,250 pts',
                              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('Gold Member', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.workspace_premium, color: Colors.amber, size: 48),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // MY ACCOUNT
              _SectionHeader(title: 'My Account'),
              _MenuItem(icon: Icons.shopping_bag_outlined, label: 'My Orders', onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No orders yet.'), behavior: SnackBarBehavior.floating),
                );
              }),
              _MenuItem(icon: Icons.favorite_border, label: 'Favourites', onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Favourite items here.'), behavior: SnackBarBehavior.floating),
                );
              }),
              _MenuItem(icon: Icons.location_on_outlined, label: 'Saved Addresses', onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No saved addresses.'), behavior: SnackBarBehavior.floating),
                );
              }),
              _MenuItem(icon: Icons.payment_outlined, label: 'Payment Methods', onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No payment methods saved.'), behavior: SnackBarBehavior.floating),
                );
              }),

              const SizedBox(height: 12),

              // SETTINGS
              _SectionHeader(title: 'Settings'),
              // Notifications toggle
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  leading: const Icon(Icons.notifications_none, color: Color(0xFF1E2A78)),
                  title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w500)),
                  trailing: Switch(
                    value: _notificationsEnabled,
                    activeThumbColor: const Color(0xFF1E2A78),
                    onChanged: (val) {
                      setState(() => _notificationsEnabled = val);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(val ? 'Notifications enabled' : 'Notifications disabled'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ),
              _MenuItem(icon: Icons.language, label: 'Language ($_selectedLanguage)', onTap: _showLanguagePicker),
              _MenuItem(icon: Icons.lock_outline, label: 'Change Password', onTap: _showChangePasswordDialog),

              const SizedBox(height: 12),

              // SUPPORT
              _SectionHeader(title: 'Support'),
              _MenuItem(icon: Icons.help_outline, label: 'Help & FAQ', onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening Help & FAQ...'), behavior: SnackBarBehavior.floating),
                );
              }),
              _MenuItem(icon: Icons.info_outline, label: 'About DAK Coffee', onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'DAK Coffee',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2024 DAK Coffee. All rights reserved.',
                );
              }),

              const SizedBox(height: 12),

              // LOGOUT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: _confirmLogout,
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    label: const Text('Log Out',
                        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title,
            style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF1E2A78)),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}