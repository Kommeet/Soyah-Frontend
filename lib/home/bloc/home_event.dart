// abstract class HomeEvent {}

// class LoadHomeData extends HomeEvent {}

// class ChangeTab extends HomeEvent {
//   final int index;
//   ChangeTab(this.index);
// }

// class ChangeOption extends HomeEvent {
//   final int index;
//   ChangeOption(this.index);
// }



















abstract class HomeEvent {}

class LoadHomeData extends HomeEvent {}

class ChangeTab extends HomeEvent {
  final int index;
  ChangeTab(this.index);
}

class ChangeOption extends HomeEvent {
  final int index;
  ChangeOption(this.index);
}