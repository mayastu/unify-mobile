import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_theme_controller.dart';
import '../../../../core/widgets/academic_page_header.dart';
import '../../../../core/widgets/app_empty.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

import '../cubit/student_cubit.dart';
import '../cubit/student_state.dart';
import '../widgets/profile_info_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _editedFirstName;
  String? _editedLastName;
  String? _editedPhone;
  String? _editedUsername;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppThemeController.instance,
      builder: (context, isDark, _) {
        final palette =
        isDark ? AppPalette.dark : AppPalette.light;

        return BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              context.go('/login');
            }

            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(state.message),
                ),
              );
            }
          },
          child: Scaffold(
            backgroundColor: palette.background,
            body: SafeArea(
              bottom: false,
              child: BlocBuilder<StudentCubit, StudentState>(
                builder: (context, state) {
                  if (state is StudentLoading ||
                      state is StudentInitial) {
                    return _ProfileLoading(
                      palette: palette,
                    );
                  }

                  if (state is StudentFailure) {
                    return AppEmpty(
                      icon: Icons.wifi_off_rounded,
                      message: state.message,
                      actionText: 'Retry',
                      onAction: () => context
                          .read<StudentCubit>()
                          .getProfile(),
                    );
                  }

                  final student =
                      (state as StudentSuccess).student;

                  final user = student.user;

                  final firstName =
                      _editedFirstName ?? user.firstName;

                  final lastName =
                      _editedLastName ?? user.lastName;

                  final phone =
                      _editedPhone ?? user.phone ?? '';

                  final username =
                      _editedUsername ?? user.username;

                  final fullName =
                  '$firstName $lastName'.trim();

                  final initials =
                  firstName.isNotEmpty
                      ? firstName[0].toUpperCase()
                      : 'S';

                  return RefreshIndicator(
                    color: palette.primary,
                    onRefresh: () async {
                      setState(() {
                        _editedFirstName = null;
                        _editedLastName = null;
                        _editedPhone = null;
                        _editedUsername = null;
                      });

                      await context
                          .read<StudentCubit>()
                          .getProfile();
                    },
                    child: CustomScrollView(
                      physics:
                      const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: AcademicPageHeader(
                            palette: palette,
                            title: 'Profile',
                            subtitle:
                            'Manage your academic account.',
                            badgeText:
                            student.studentNumber,
                            metaText: 'Student',
                            icon: Icons.person_rounded,
                          ),
                        ),

                        SliverToBoxAdapter(
                          child: Padding(
                            padding:
                            const EdgeInsets.fromLTRB(
                              20,
                              22,
                              20,
                              0,
                            ),
                            child: _ProfileIdentityCard(
                              palette: palette,
                              initials: initials,
                              fullName: fullName,
                              department:
                              student.department.name,
                              studentNumber:
                              student.studentNumber,
                              onEdit: () {
                                _openEditProfile(
                                  context,
                                  palette,
                                  firstName,
                                  lastName,
                                  phone,
                                  username,
                                );
                              },
                            ),
                          ),
                        ),

                        SliverToBoxAdapter(
                          child: Padding(
                            padding:
                            const EdgeInsets.fromLTRB(
                              20,
                              28,
                              20,
                              12,
                            ),
                            child: _SectionTitle(
                              title: 'Personal information',
                              subtitle:
                              'Your account contact details',
                              palette: palette,
                            ),
                          ),
                        ),

                        SliverPadding(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          sliver: SliverList(
                            delegate:
                            SliverChildListDelegate(
                              [
                                ProfileInfoTile(
                                  icon:
                                  Icons.email_outlined,
                                  label: 'Email',
                                  value: user.email,
                                ),
                                const SizedBox(height: 10),

                                _EditableProfileTile(
                                  palette: palette,
                                  icon:
                                  Icons.phone_outlined,
                                  label: 'Phone',
                                  value: phone.isEmpty
                                      ? 'Not provided'
                                      : phone,
                                  onTap: () {
                                    _openEditProfile(
                                      context,
                                      palette,
                                      firstName,
                                      lastName,
                                      phone,
                                      username,
                                      initialField:
                                      'phone',
                                    );
                                  },
                                ),

                                const SizedBox(height: 10),

                                _EditableProfileTile(
                                  palette: palette,
                                  icon:
                                  Icons.badge_outlined,
                                  label: 'Username',
                                  value: username,
                                  onTap: () {
                                    _openEditProfile(
                                      context,
                                      palette,
                                      firstName,
                                      lastName,
                                      phone,
                                      username,
                                      initialField:
                                      'username',
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        SliverToBoxAdapter(
                          child: Padding(
                            padding:
                            const EdgeInsets.fromLTRB(
                              20,
                              28,
                              20,
                              12,
                            ),
                            child: _SectionTitle(
                              title: 'Academic information',
                              subtitle:
                              'Information managed by your university',
                              palette: palette,
                            ),
                          ),
                        ),

                        SliverPadding(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          sliver: SliverList(
                            delegate:
                            SliverChildListDelegate(
                              [
                                _ReadOnlyProfileTile(
                                  palette: palette,
                                  icon:
                                  Icons.confirmation_number_outlined,
                                  label: 'Student number',
                                  value:
                                  student.studentNumber,
                                ),
                                const SizedBox(height: 10),

                                _ReadOnlyProfileTile(
                                  palette: palette,
                                  icon:
                                  Icons.apartment_rounded,
                                  label: 'Department',
                                  value:
                                  '${student.department.name} (${student.department.code})',
                                ),
                              ],
                            ),
                          ),
                        ),

                        SliverToBoxAdapter(
                          child: Padding(
                            padding:
                            const EdgeInsets.fromLTRB(
                              20,
                              30,
                              20,
                              120,
                            ),
                            child: _LogoutButton(
                              palette: palette,
                              onPressed: () =>
                                  _confirmLogout(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openEditProfile(
      BuildContext context,
      AppPalette palette,
      String firstName,
      String lastName,
      String phone,
      String username, {
        String? initialField,
      }) async {
    final result =
    await showModalBottomSheet<_ProfileEditResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _EditProfileSheet(
          palette: palette,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          username: username,
          initialField: initialField,
        );
      },
    );

    if (result == null || !mounted) return;

    setState(() {
      _editedFirstName = result.firstName;
      _editedLastName = result.lastName;
      _editedPhone = result.phone;
      _editedUsername = result.username;
    });

    /*
     * IMPORTANT:
     *
     * هون المكان المناسب لربط API التعديل لاحقاً.
     *
     * مثال:
     *
     * context.read<StudentCubit>().updateProfile(
     *   firstName: result.firstName,
     *   lastName: result.lastName,
     *   phone: result.phone,
     *   username: result.username,
     * );
     *
     * ما حطيت هذا السطر لأن method
     * updateProfile غير موجودة بالكود اللي بعثته.
     */

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: palette.primary,
        content: const Text(
          'Profile updated locally.',
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
          Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Log out',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out?',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                authCubit.logout();
              },
              style: FilledButton.styleFrom(
                backgroundColor:
                Theme.of(context).colorScheme.error,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('Log out'),
            ),
          ],
        );
      },
    );
  }
}

/* -------------------------------------------------------------------------- */
/* PROFILE IDENTITY CARD                                                      */
/* -------------------------------------------------------------------------- */

class _ProfileIdentityCard extends StatelessWidget {
  const _ProfileIdentityCard({
    required this.palette,
    required this.initials,
    required this.fullName,
    required this.department,
    required this.studentNumber,
    required this.onEdit,
  });

  final AppPalette palette;
  final String initials;
  final String fullName;
  final String department;
  final String studentNumber;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: palette.border,
        ),
        boxShadow: [
          BoxShadow(
            color: palette.primary.withOpacity(0.06),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      palette.primary,
                      Color.lerp(
                        palette.primary,
                        palette.waveBlue,
                        0.45,
                      ) ??
                          palette.primary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: palette.textPrimary,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      department,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 9),

                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: palette.waveBlue,
                        borderRadius:
                        BorderRadius.circular(9),
                      ),
                      child: Text(
                        studentNumber,
                        style: TextStyle(
                          color: palette.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              onPressed: onEdit,
              icon: const Icon(
                Icons.edit_rounded,
                size: 18,
              ),
              label: const Text(
                'Edit profile',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: palette.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/* SECTION TITLE                                                              */
/* -------------------------------------------------------------------------- */

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
    required this.palette,
  });

  final String title;
  final String subtitle;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: palette.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 11.5,
            color: palette.textSecondary,
          ),
        ),
      ],
    );
  }
}

/* -------------------------------------------------------------------------- */
/* EDITABLE TILE                                                              */
/* -------------------------------------------------------------------------- */

class _EditableProfileTile extends StatelessWidget {
  const _EditableProfileTile({
    required this.palette,
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final AppPalette palette;
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: palette.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: palette.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: palette.waveBlue,
                  borderRadius:
                  BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: palette.primary,
                  size: 20,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color:
                        palette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: palette.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.edit_outlined,
                size: 18,
                color: palette.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/* READ ONLY TILE                                                             */
/* -------------------------------------------------------------------------- */

class _ReadOnlyProfileTile extends StatelessWidget {
  const _ReadOnlyProfileTile({
    required this.palette,
    required this.icon,
    required this.label,
    required this.value,
  });

  final AppPalette palette;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: palette.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: palette.surfaceElevated,
              borderRadius:
              BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: palette.textSecondary,
              size: 20,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.lock_outline_rounded,
            size: 16,
            color: palette.textSecondary
                .withOpacity(0.55),
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/* LOGOUT BUTTON                                                              */
/* -------------------------------------------------------------------------- */

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({
    required this.palette,
    required this.onPressed,
  });

  final AppPalette palette;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: palette.border,
        ),
      ),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(
          Icons.logout_rounded,
          size: 19,
        ),
        label: const Text(
          'Log out',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor:
          Theme.of(context).colorScheme.error,
          side: BorderSide.none,
          padding:
          const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/* EDIT PROFILE SHEET                                                         */
/* -------------------------------------------------------------------------- */

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet({
    required this.palette,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.username,
    this.initialField,
  });

  final AppPalette palette;
  final String firstName;
  final String lastName;
  final String phone;
  final String username;
  final String? initialField;

  @override
  State<_EditProfileSheet> createState() =>
      _EditProfileSheetState();
}

class _EditProfileSheetState
    extends State<_EditProfileSheet> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();

    _firstNameController =
        TextEditingController(text: widget.firstName);

    _lastNameController =
        TextEditingController(text: widget.lastName);

    _phoneController =
        TextEditingController(text: widget.phone);

    _usernameController =
        TextEditingController(text: widget.username);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (widget.initialField == 'phone') {
        FocusScope.of(context).requestFocus(
          _phoneFocus,
        );
      }

      if (widget.initialField == 'username') {
        FocusScope.of(context).requestFocus(
          _usernameFocus,
        );
      }
    });
  }

  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();

    _phoneFocus.dispose();
    _usernameFocus.dispose();

    super.dispose();
  }

  void _save() {
    final firstName =
    _firstNameController.text.trim();

    final lastName =
    _lastNameController.text.trim();

    final phone =
    _phoneController.text.trim();

    final username =
    _usernameController.text.trim();

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Please fill in all required fields.',
          ),
        ),
      );

      return;
    }

    Navigator.of(context).pop(
      _ProfileEditResult(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        username: username,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom =
        MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        decoration: BoxDecoration(
          color: widget.palette.background,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              20,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color:
                      widget.palette.border,
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color:
                        widget.palette.waveBlue,
                        borderRadius:
                        BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.edit_rounded,
                        color:
                        widget.palette.primary,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edit profile',
                            style: TextStyle(
                              color: widget
                                  .palette
                                  .textPrimary,
                              fontSize: 20,
                              fontWeight:
                              FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Update your personal information.',
                            style: TextStyle(
                              color: widget
                                  .palette
                                  .textSecondary,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _EditField(
                  controller:
                  _firstNameController,
                  label: 'First name',
                  icon:
                  Icons.person_outline_rounded,
                  palette: widget.palette,
                ),

                const SizedBox(height: 12),

                _EditField(
                  controller:
                  _lastNameController,
                  label: 'Last name',
                  icon:
                  Icons.person_outline_rounded,
                  palette: widget.palette,
                ),

                const SizedBox(height: 12),

                _EditField(
                  controller:
                  _phoneController,
                  label: 'Phone',
                  icon:
                  Icons.phone_outlined,
                  keyboardType:
                  TextInputType.phone,
                  focusNode: _phoneFocus,
                  palette: widget.palette,
                ),

                const SizedBox(height: 12),

                _EditField(
                  controller:
                  _usernameController,
                  label: 'Username',
                  icon:
                  Icons.badge_outlined,
                  focusNode: _usernameFocus,
                  palette: widget.palette,
                ),

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: _save,
                    style: FilledButton.styleFrom(
                      backgroundColor:
                      widget.palette.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Save changes',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color:
                        widget.palette.textSecondary,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/* EDIT FIELD                                                                 */
/* -------------------------------------------------------------------------- */

class _EditField extends StatelessWidget {
  const _EditField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.palette,
    this.keyboardType,
    this.focusNode,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final AppPalette palette;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      style: TextStyle(
        color: palette.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: palette.textSecondary,
          size: 20,
        ),
        filled: true,
        fillColor: palette.surface,
        labelStyle: TextStyle(
          color: palette.textSecondary,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(16),
          borderSide: BorderSide(
            color: palette.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(16),
          borderSide: BorderSide(
            color: palette.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/* RESULT                                                                     */
/* -------------------------------------------------------------------------- */

class _ProfileEditResult {
  const _ProfileEditResult({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.username,
  });

  final String firstName;
  final String lastName;
  final String phone;
  final String username;
}

/* -------------------------------------------------------------------------- */
/* LOADING                                                                    */
/* -------------------------------------------------------------------------- */

class _ProfileLoading extends StatelessWidget {
  const _ProfileLoading({
    required this.palette,
  });

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AcademicPageHeader(
          palette: palette,
          title: 'Profile',
          subtitle:
          'Manage your academic account.',
          badgeText: 'Loading',
          metaText: 'Student',
          icon: Icons.person_rounded,
        ),

        const SizedBox(height: 30),

        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color:
            palette.primary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(16),
          child: CircularProgressIndicator(
            color: palette.primary,
            strokeWidth: 2.5,
          ),
        ),
      ],
    );
  }
}