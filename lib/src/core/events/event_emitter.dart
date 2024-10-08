import 'dart:async';

typedef EventEmitterObserver<T> = Function(T value);

class EventEmitter<T> {
  StreamSubscription? _streamSubscription;
  final _observers = List<EventEmitterObserver<T>>.empty(growable: true);
  final _controller = StreamController<T>();

  EventEmitter() {
    _streamSubscription = result.listen((T event) {
      _listen(event);
    });
  }

  void _listen(T event) {
    for (final observer in _observers) {
      observer(event);
    }
  }

  Stream<T> get result async* {
    yield* _controller.stream;
  }

  void emit(T Function() function) {
    _controller.add(function.call());
  }

  Future<void> emitAsync(Future<T> Function() function) async {
    _controller.add(await function.call());
  }

  void emitValue(T value) {
    _controller.add(value);
  }

  Future<void> emitAsyncValue(Future<T> value) async {
    _controller.add(await value);
  }

  void observe(EventEmitterObserver<T> callback) {
    _observers.add(callback);
  }

  void dispose() {
    _streamSubscription?.cancel();
  }
}