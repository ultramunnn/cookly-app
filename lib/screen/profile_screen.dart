import 'package:cookly_app/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:cookly_app/theme/app_color.dart';
import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:cookly_app/widgets/components/custom_navbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final supabase = Supabase.instance.client;
  Map<String, dynamic>? profileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      setState(() {
        profileData = response;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error load profile: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await supabase.auth.signOut();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      _showErrorDialog(context, 'Gagal logout: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Terjadi Kesalahan'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomNavbar(),
                      const SizedBox(height: 24),

                      // 🔹 Header
                      Center(
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: AppColors.primary,
                                size: 50,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const CustomText(
                              text: "Profil Saya",
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                            const SizedBox(height: 8),
                            const CustomText(
                              text: "Kelola data pribadi Anda",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      ProfileItem(
                        label: "Nama Lengkap",
                        value: profileData?['nama'] ?? '-',
                      ),
                      const SizedBox(height: 16),
                      ProfileItem(
                        label: "Username",
                        value: profileData?['username'] ?? '-',
                      ),
                      const SizedBox(height: 16),
                      ProfileItem(
                        label: "Email",
                        value: supabase.auth.currentUser?.email ?? '-',
                      ),

                      const SizedBox(height: 32),
                      const Divider(color: Color(0xFFF1F1F1)),
                      const SizedBox(height: 24),

                      // 🔹 Tombol Aksi
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              onPressed: () {
                                // TODO: Navigasi ke Edit Profile
                              },
                              child: const CustomText(
                                text: 'Edit Profil',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              onPressed: () => _logout(context),
                              child: const CustomText(
                                text: 'Logout',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String label;
  final String value;

  const ProfileItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: label,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          Flexible(
            child: CustomText(
              text: value,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800]!,
            ),
          ),
        ],
      ),
    );
  }
}
