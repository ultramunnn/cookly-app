import 'package:cookly_app/data/repository/user_repository.dart';
import 'package:cookly_app/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:cookly_app/theme/app_color.dart';
import 'package:cookly_app/widgets/components/custom_text.dart';
import 'package:cookly_app/widgets/components/custom_navbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cookly_app/data/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _supabase = Supabase.instance.client;
  final _repo = UserRepository();

  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        debugPrint('No authenticated user found');
        if (mounted) {
          setState(() => _isLoading = false);
        }
        return;
      }

      debugPrint('Loading profile for user ID: ${currentUser.id}');

      // langsung gunakan string ID (UUID)
      final user = await _repo.getProfileById(currentUser.id);

      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await _supabase.auth.signOut();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      _showErrorDialog(context, 'Logout failed: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const CustomText(
          text: 'Error',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        content: CustomText(
          text: message,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey[800]!,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CustomText(
              text: 'Close',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEditProfile() {
    // TODO: Implement edit profile navigation
    debugPrint('Navigate to edit profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Navbar
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: CustomNavbar(),
        ),
        const SizedBox(height: 24),

        // Profile Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildProfileHeader(),
                const SizedBox(height: 32),

                // Profile Info Section
                _buildProfileInfo(),
                const SizedBox(height: 32),

                // Action Buttons
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          // Profile Avatar
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: const Icon(Icons.person, color: AppColors.primary, size: 50),
          ),
          const SizedBox(height: 16),

          // Title
          const CustomText(
            text: "My Profile",
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          const SizedBox(height: 8),

          // Subtitle
          const CustomText(
            text: "Manage your personal data",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        _buildProfileItem(label: "Full Name", value: _user?.name ?? '-'),
        const SizedBox(height: 16),
        _buildProfileItem(label: "Username", value: _user?.username ?? '-'),
        const SizedBox(height: 16),
        _buildProfileItem(
          label: "Email",
          value: _supabase.auth.currentUser?.email ?? '-',
        ),
      ],
    );
  }

  Widget _buildProfileItem({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
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
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        const Divider(color: Color(0xFFF1F1F1)),
        const SizedBox(height: 24),

        // Buttons
        Row(
          children: [
            // Edit Profile Button
            Expanded(
              child: ElevatedButton(
                onPressed: _navigateToEditProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                child: const CustomText(
                  text: 'Edit Profile',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Logout Button
            Expanded(
              child: ElevatedButton(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
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
    );
  }
}
