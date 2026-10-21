import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'ventus_icon_data.dart';

/// Icon set: Phosphor (MIT) Light by default, Regular for emphasis, Fill for
/// active/selected states. Glyph data lives in `ventus_icon_data.dart`;
/// google/apple brand marks keep their own colours.
///
/// Usage: `VentusIcon(VentusIcons.search, size: 22, color: context.colors.ink)`.
class VentusIcon extends StatelessWidget {
  const VentusIcon(
    this.name, {
    super.key,
    this.size = 22,
    this.stroke = 1.6,
    this.filled = false,
    this.color = const Color(0xFF000000),
  });

  final String name;
  final double size;

  /// Weight hint kept from the old stroke API: >= 2.0 picks the Regular
  /// weight, anything lighter the Light weight.
  final double stroke;

  /// Use the solid variant (active tab, saved heart, ...) when one exists.
  final bool filled;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final brand = _brandIcons[name];
    if (brand != null) {
      return SvgPicture.string(
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" '
        'fill="none" stroke="currentColor" stroke-width="$stroke" '
        'stroke-linecap="round" stroke-linejoin="round">$brand</svg>',
        width: size,
        height: size,
        theme: SvgTheme(currentColor: color),
      );
    }

    final base = name.endsWith('-fill')
        ? name.substring(0, name.length - 5)
        : name;
    final wantFill = filled || base != name;
    final inner =
        (wantFill ? kIconFill[base] : null) ??
        (stroke >= 2.0 ? kIconRegular[base] : kIconLight[base]);
    if (inner == null) {
      return SizedBox(width: size, height: size);
    }
    return SvgPicture.string(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" '
      'fill="currentColor">$inner</svg>',
      width: size,
      height: size,
      theme: SvgTheme(currentColor: color),
    );
  }
}

/// String constants for every available icon — gives autocompletion and guards
/// against typos while keeping the underlying lookup a simple map.
abstract final class VentusIcons {
  static const arrowLeft = 'arrow-left';
  static const arrowRight = 'arrow-right';
  static const chevronRight = 'chevron-right';
  static const chevronDown = 'chevron-down';
  static const close = 'close';
  static const search = 'search';
  static const plus = 'plus';
  static const minus = 'minus';
  static const check = 'check';
  static const bell = 'bell';
  static const user = 'user';
  static const users = 'users';
  static const userPlus = 'user-plus';
  static const home = 'home';
  static const mapPin = 'map-pin';
  static const compass = 'compass';
  static const grid = 'grid';
  static const calendar = 'calendar';
  static const wallet = 'wallet';
  static const ticket = 'ticket';
  static const bed = 'bed';
  static const plane = 'plane';
  static const route = 'route';
  static const sparkle = 'sparkle';
  static const eye = 'eye';
  static const eyeOff = 'eye-off';
  static const lock = 'lock';
  static const mail = 'mail';
  static const star = 'star';
  static const starFill = 'star-fill';
  static const settings = 'settings';
  static const camera = 'camera';
  static const document = 'document';
  static const listCheck = 'list-check';
  static const note = 'note';
  static const clock = 'clock';
  static const globe = 'globe';
  static const heart = 'heart';
  static const heartFill = 'heart-fill';
  static const filter = 'filter';
  static const edit = 'edit';
  static const more = 'more';
  static const share = 'share';
  static const sun = 'sun';
  static const moon = 'moon';
  static const cloud = 'cloud';
  static const cloudRain = 'cloud-rain';
  static const cloudSnow = 'cloud-snow';
  static const cloudLightning = 'cloud-lightning';
  static const logout = 'logout';
  static const crown = 'crown';
  static const cup = 'cup';
  static const car = 'car';
  static const cart = 'cart';
  static const tag = 'tag';
  static const trendUp = 'trend-up';
  static const download = 'download';
  static const trash = 'trash';
  static const folder = 'folder';
  static const image = 'image';
  static const link = 'link';
  static const copy = 'copy';
  static const shield = 'shield';
  static const google = 'google';
  static const apple = 'apple';
  static const briefcase = 'briefcase';
  static const swap = 'swap';

  /// All icon names, handy for the design gallery.
  static const all = <String>[
    arrowLeft,
    arrowRight,
    chevronRight,
    chevronDown,
    close,
    search,
    plus,
    check,
    bell,
    user,
    home,
    mapPin,
    compass,
    grid,
    calendar,
    wallet,
    ticket,
    bed,
    plane,
    route,
    users,
    userPlus,
    sparkle,
    eye,
    eyeOff,
    lock,
    mail,
    star,
    starFill,
    settings,
    camera,
    document,
    listCheck,
    note,
    clock,
    globe,
    heart,
    heartFill,
    filter,
    edit,
    more,
    share,
    sun,
    moon,
    cloud,
    cloudRain,
    cloudSnow,
    cloudLightning,
    logout,
    crown,
    cup,
    car,
    cart,
    tag,
    trendUp,
    download,
    trash,
    folder,
    image,
    link,
    copy,
    shield,
    google,
    apple,
    briefcase,
    swap,
  ];
}

/// Multi-colour / filled brand marks. Kept in the original 24x24 stroke setup
/// since Phosphor has no equivalent.
const Map<String, String> _brandIcons = {
  'google':
      '<g stroke="none">'
      '<path d="M21 12.2c0-.6-.05-1.2-.16-1.8H12v3.4h5.05a4.3 4.3 0 01-1.87 2.82v2.33h3.02C19.96 17.3 21 15 21 12.2z" fill="#4285F4"/>'
      '<path d="M12 21c2.52 0 4.64-.83 6.19-2.25l-3.02-2.33c-.84.56-1.92.89-3.17.89-2.44 0-4.5-1.64-5.24-3.85H3.64v2.41A9 9 0 0012 21z" fill="#34A853"/>'
      '<path d="M6.76 13.46a5.4 5.4 0 010-3.42V7.63H3.64a9 9 0 000 8.07z" fill="#FBBC05"/>'
      '<path d="M12 6.18c1.37 0 2.6.47 3.57 1.4l2.67-2.67C16.63 3.4 14.51 2.5 12 2.5A9 9 0 003.64 7.63l3.12 2.41C7.5 7.82 9.56 6.18 12 6.18z" fill="#EA4335"/>'
      '</g>',
  'apple':
      '<path d="M16.4 12.6c0-2.2 1.8-3.3 1.9-3.3-1-1.5-2.6-1.7-3.2-1.7-1.4-.1-2.7.8-3.3.8-.7 0-1.7-.8-2.8-.8-1.4 0-2.8.8-3.5 2.1-1.5 2.6-.4 6.5 1.1 8.6.7 1 1.6 2.2 2.7 2.1 1.1 0 1.5-.7 2.8-.7s1.6.7 2.8.7c1.1 0 1.9-1 2.6-2.1.8-1.2 1.2-2.4 1.2-2.4s-2.2-.9-2.3-3.3zM14.3 6.3c.6-.7 1-1.7.9-2.8-.8 0-1.9.6-2.5 1.3-.5.6-1 1.6-.9 2.6.9.1 1.8-.5 2.5-1.1z" fill="currentColor" stroke="none"/>',
};
