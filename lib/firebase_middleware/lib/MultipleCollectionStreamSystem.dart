import 'dart:async';

/// You should call the `dispose()` method from this class within your method `dispose()` in your Widget or State.
class MultipleCollectionStreamSystem<K, V> {
  final Map<K, V> _currentValues = Map<K, V>();

  final StreamController<Map<K, V>> _streamController =
      StreamController.broadcast();

  Stream<Map<K, V>> get stream => _streamController.stream;

  final Map<K, Stream<V>> _streams =
      Map<K, Stream<V>>();

  MultipleCollectionStreamSystem([Map<K, Stream<V>> streams]) {
    streams?.forEach(add);
  }

  void add(K key, Stream<V> stream) {
    _streams[key] = stream;
    stream.listen((value) => _updateValue(key, value));
  }

  void _updateValue(K key, V value) {
    // Replaces the element from the map with the new one
    _currentValues[key] = value;

    // Updates the stream, passing the updated values through it
    _streamController.add(_currentValues);
  }

  void dispose() {
    _streamController.close();
  }
}
