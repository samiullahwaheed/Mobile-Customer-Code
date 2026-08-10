/// Bottom navigation destinations. Use enum values instead of stack indices
/// so tab order can change without breaking navigation call sites.
enum NavigationTab {
  home,
  merchants,
  wallet,
  profile;

  String get title {
    switch (this) {
      case NavigationTab.home:
        return 'Home';
      case NavigationTab.merchants:
        return 'Merchants';
      case NavigationTab.wallet:
        return 'Wallet';
      case NavigationTab.profile:
        return 'Profile';
    }
  }

  int get stackIndex => NavigationTab.values.indexOf(this);
}
