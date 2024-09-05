import 'package:flutterx_live_data/flutterx_live_data.dart';

extension MutableLiveDataUtils<T> on T {
  /// create new [MutableLiveData] instance with initialValue from passed variable value
  MutableLiveData<T> get liveData => MutableLiveData<T>(value: this);

  /// create new [LiveResult] instance with initialValue [ResultState.idle]
  LiveResult<T> get liveResult => LiveResult();

  /// create new [MediatorMutableLiveData] instance with initialValue from passed variable value
  MediatorMutableLiveData<T> get mediatorLiveData => MediatorMutableLiveData<T>(value: this);

  /// create new [LiveEvent] instance with initialValue from passed variable value
  LiveEvent<T> get liveEvent => LiveEvent<T>();
}