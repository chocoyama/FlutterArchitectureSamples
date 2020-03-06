import 'package:flutterarchitecturesample/redux/action.dart';
import 'package:flutterarchitecturesample/redux/state.dart';
import 'package:redux/redux.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
    isLoading: loadingReducer(state.isLoading, action),
    counter: counterReducer(state.counter, action),
  );
}

final loadingReducer = combineReducers<bool>([
  TypedReducer<bool, LoadingAction>((state, action) => true),
  TypedReducer<bool, LoadCompleteAction>((state, action) => false),
]);

final counterReducer = combineReducers<int>([
  TypedReducer<int, CountUpSucceededAction>((state, action) {
    int increaseCount = action.increaseCount;
    return state + increaseCount;
  }),
]);