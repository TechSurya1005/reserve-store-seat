class NavigationModel {
  final String route;
  final Map<String, dynamic>? params;
  final bool clearStack;

  NavigationModel({
    required this.route,
    this.params,
    this.clearStack = false,
  });

  NavigationModel copyWith({
    String? route,
    Map<String, dynamic>? params,
    bool? clearStack,
  }) {
    return NavigationModel(
      route: route ?? this.route,
      params: params ?? this.params,
      clearStack: clearStack ?? this.clearStack,
    );
  }
}
