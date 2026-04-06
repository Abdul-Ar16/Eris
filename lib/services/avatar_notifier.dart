import 'package:flutter/foundation.dart';

/// A single app-wide notifier for the user's profile avatar path.
///
/// Write to [avatarNotifier] whenever the avatar changes; any widget that
/// calls [ValueListenableBuilder] (or adds a listener) will rebuild instantly.
///
/// `null`  → no custom photo, show initials.
/// non-null → absolute path to the saved image file.
final ValueNotifier<String?> avatarNotifier = ValueNotifier<String?>(null);
