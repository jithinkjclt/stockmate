import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bottombar_state.dart';

class BottombarCubit extends Cubit<BottombarState> {
  BottombarCubit() : super(BottombarInitial());

  int index = 0;

  changeIndex(int i) {
    index = i;
    emit(BottombarInitial());
  }
}
