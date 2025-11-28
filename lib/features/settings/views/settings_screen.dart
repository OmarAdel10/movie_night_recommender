import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:movie_night_recommender/l10n/arb/app_localizations.dart';
import '../view_models/settings_bloc.dart';
import '../../auth/view_models/auth_bloc.dart';
import '../../auth/views/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(context, l10n),
            const SizedBox(height: 24),
            _buildLanguageSection(context, l10n),
            const SizedBox(height: 24),
            _buildThemeSection(context, l10n),
            const SizedBox(height: 24),
            _buildSecuritySection(context, l10n),
            const SizedBox(height: 24),
            _buildAboutSection(context, l10n),
            const SizedBox(height: 24),
            _buildLogoutButton(context, l10n),
            const SizedBox(height: 80), // Bottom padding for floating nav bar
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, AppLocalizations l10n) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;
        final username = user?.displayName ?? l10n.username;
        final email = user?.email ?? l10n.email;
        final photoUrl = user?.photoURL;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, l10n.profile),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                    child: photoUrl == null
                        ? Text(username.isNotEmpty ? username[0].toUpperCase() : 'U')
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // TODO: Implement edit profile
                    },
                    tooltip: l10n.editProfile,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, l10n.language),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('English'),
                    value: 'en',
                    groupValue: state.settings.locale.languageCode,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<SettingsBloc>().add(SettingsLocaleChanged(Locale(value)));
                      }
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('العربية'),
                    value: 'ar',
                    groupValue: state.settings.locale.languageCode,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<SettingsBloc>().add(SettingsLocaleChanged(Locale(value)));
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildThemeSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, l10n.theme),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: Text(l10n.systemTheme),
                    value: ThemeMode.system,
                    groupValue: state.settings.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<SettingsBloc>().add(SettingsThemeChanged(value));
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(l10n.lightTheme),
                    value: ThemeMode.light,
                    groupValue: state.settings.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<SettingsBloc>().add(SettingsThemeChanged(value));
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(l10n.darkTheme),
                    value: ThemeMode.dark,
                    groupValue: state.settings.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<SettingsBloc>().add(SettingsThemeChanged(value));
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSecuritySection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, l10n.security),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: Text(l10n.biometricAuth),
                subtitle: Text(l10n.enableBiometrics),
                value: state.settings.isLocalAuthEnabled,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(SettingsLocalAuthChanged(value));
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, l10n.about),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.version),
                trailing: const Text('1.0.0'),
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.contactDeveloper),
                subtitle: const Text('omaradel1.dev@gmail.com'),
                trailing: IconButton(
                  icon: const Icon(Icons.email),
                  onPressed: () => _launchUrl(Uri.parse('mailto:omaradel1.dev@gmail.com')),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.linkedInProfile),
                subtitle: const Text('Omar Adel'),
                trailing: IconButton(
                  icon: const Icon(Icons.link), // Using generic link icon as LinkedIn logo might not be in default icons
                  onPressed: () => _launchUrl(Uri.parse('https://www.linkedin.com/in/omaradel10')),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.error,
          foregroundColor: Theme.of(context).colorScheme.onError,
        ),
        onPressed: () {
          context.read<AuthBloc>().add(AuthLogoutRequested());
        },
        child: Text(l10n.logout),
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
