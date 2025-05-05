import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'place_profile_state.dart';

class PlaceProfileCubit extends Cubit<PlaceProfileState> {
  PlaceProfileCubit() : super(PlaceProfileInitial());
}
