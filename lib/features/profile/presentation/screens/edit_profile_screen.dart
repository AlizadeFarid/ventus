import '../../../../core/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../application/profile_controller.dart';
import '../../application/profile_providers.dart';
import '../../data/avatar_picker.dart';
import '../../domain/profile_repository.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_typography.dart';

/// Teal→amber avatar gradient — mirrors `AppColors.gradientHero` (shared with
/// the Profile hub).
const _avatarGradient = AppColors.heroGradient;

/// Edit display name + avatar, reached from the Profile hub "Edit" button.
///
/// Name is written to Supabase auth metadata; the avatar image is uploaded to
/// the owner-scoped `avatars` bucket and its path stored alongside the name.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _name;

  /// A freshly picked image awaiting save, if any.
  PickedAvatar? _picked;

  /// Whether the user chose to remove the existing avatar.
  bool _removed = false;

  /// Shown under the name field after a failed save with an empty name.
  bool _nameError = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: ref.read(profileProvider).name);
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final profile = ref.watch(profileProvider);
    final saving = ref.watch(profileControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: VentusAppBar(title: l10n.editProfileTitle),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  8,
                  AppSpacing.screen,
                  24,
                ),
                child: Column(
                  children: [
                    Center(
                      child: _AvatarEditor(
                        profile: profile,
                        picked: _picked,
                        removed: _removed,
                        onEdit: saving ? null : _pickPhoto,
                      ),
                    ),
                    const SizedBox(height: 8),
                    VentusTap(
                      onTap: saving ? null : _pickPhoto,
                      child: Text(
                        l10n.changePhoto,
                        style: TextStyle(
                          fontSize: AppFontSize.sm,
                          fontWeight: FontWeight.w700,
                          color: context.primaryFill,
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    VentusTextField(
                      label: l10n.fullNameLabel,
                      hintText: l10n.fullNameHint,
                      controller: _name,
                      icon: VentusIcons.user,
                      textInputAction: TextInputAction.done,
                      errorText: _nameError ? l10n.nameRequired : null,
                      onChanged: (_) {
                        if (_nameError) setState(() => _nameError = false);
                      },
                    ),
                    const SizedBox(height: 16),
                    _ReadonlyField(
                      label: l10n.emailLabel,
                      value: profile.email,
                      helper: l10n.emailReadonlyNote,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                8,
                AppSpacing.screen,
                24,
              ),
              child: VentusButton(
                label: l10n.save,
                full: true,
                loading: saving,
                onPressed: saving ? null : _save,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPhoto() async {
    final profile = ref.read(profileProvider);
    final hasAvatar =
        _picked != null || (!_removed && profile.avatarPath != null);
    final action = await showVentusSheet<_PhotoAction>(
      context,
      isScrollControlled: false,
      builder: (_) => _PhotoSourceSheet(canRemove: hasAvatar),
    );
    if (action == null || !mounted) return;

    switch (action) {
      case _PhotoAction.camera:
      case _PhotoAction.gallery:
        final picked = action == _PhotoAction.camera
            ? await AvatarPicker.fromCamera()
            : await AvatarPicker.fromGallery();
        if (picked == null || !mounted) return;
        setState(() {
          _picked = picked;
          _removed = false;
        });
      case _PhotoAction.remove:
        setState(() {
          _picked = null;
          _removed = true;
        });
    }
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = true);
      return;
    }
    final navigator = Navigator.of(context);
    final l10n = context.l10n;

    final error = await ref
        .read(profileControllerProvider.notifier)
        .save(name: name, newAvatar: _picked, removeAvatar: _removed);
    if (!mounted) return;

    if (error == null) {
      showVentusSuccess(context, l10n.profileSaved);
      navigator.pop();
    } else {
      showVentusError(context, _errorMessage(l10n, error), onRetry: _save);
    }
  }

  String _errorMessage(AppLocalizations l10n, ProfileErrorCode code) {
    switch (code) {
      case ProfileErrorCode.notConfigured:
        return l10n.profileEditUnavailable;
      case ProfileErrorCode.network:
        return l10n.profileSaveFailed;
      case ProfileErrorCode.unknown:
        return l10n.somethingWentWrong;
    }
  }
}

enum _PhotoAction { camera, gallery, remove }

/// Round avatar showing the picked image / current avatar / initials, with a
/// camera badge to invite editing.
class _AvatarEditor extends StatelessWidget {
  const _AvatarEditor({
    required this.profile,
    required this.picked,
    required this.removed,
    required this.onEdit,
  });

  final ProfileInfo profile;
  final PickedAvatar? picked;
  final bool removed;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const size = 104.0;

    ImageProvider? image;
    if (picked != null) {
      image = MemoryImage(picked!.bytes);
    } else if (!removed && profile.avatarUrl != null) {
      image = CachedNetworkImageProvider(profile.avatarUrl!);
    }

    return VentusTap(
      onTap: onEdit,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: image == null ? _avatarGradient : null,
                image: image == null
                    ? null
                    : DecorationImage(image: image, fit: BoxFit.cover),
              ),
              child: image == null
                  ? Text(
                      profile.initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: AppFontSize.hero,
                      ),
                    )
                  : null,
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.bg, width: 3),
                ),
                child: const VentusIcon(
                  VentusIcons.camera,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Read-only field that mirrors [VentusTextField]'s look for a value the user
/// can't edit here (email).
class _ReadonlyField extends StatelessWidget {
  const _ReadonlyField({required this.label, required this.value, this.helper});

  final String label;
  final String value;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.typography;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: type.sm.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.ink2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: AppSizes.controlLg,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: colors.surfaceSand,
            borderRadius: AppRadius.brMd,
          ),
          child: Row(
            children: [
              VentusIcon(VentusIcons.user, size: 20, color: colors.muted),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value.isEmpty ? '—' : value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: type.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colors.muted,
                  ),
                ),
              ),
              VentusIcon(VentusIcons.shield, size: 17, color: colors.muted),
            ],
          ),
        ),
        if (helper != null) ...[
          const SizedBox(height: 7),
          Text(helper!, style: type.caption.copyWith(color: colors.muted)),
        ],
      ],
    );
  }
}

/// Bottom sheet offering Camera / Library / (optional) Remove.
class _PhotoSourceSheet extends StatelessWidget {
  const _PhotoSourceSheet({required this.canRemove});

  final bool canRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VentusSheetHandle(),
            _SheetRow(
              icon: VentusIcons.camera,
              label: l10n.avatarTakePhoto,
              onTap: () => Navigator.of(context).pop(_PhotoAction.camera),
            ),
            _SheetRow(
              icon: VentusIcons.image,
              label: l10n.avatarChooseLibrary,
              onTap: () => Navigator.of(context).pop(_PhotoAction.gallery),
            ),
            if (canRemove) ...[
              _SheetRow(
                icon: VentusIcons.trash,
                label: l10n.avatarRemove,
                danger: true,
                onTap: () => Navigator.of(context).pop(_PhotoAction.remove),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fg = danger ? colors.danger : colors.ink;
    return VentusTap(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            VentusIcon(icon, size: 20, color: fg),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: AppFontSize.body,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
