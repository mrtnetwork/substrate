import 'package:blockchain_utils/utils/utils.dart';

typedef DynamicVoid = void Function();

typedef ObjectVoid = void Function(Object?);
typedef StringVoid = void Function(String);
typedef StringFunc = String Function();
typedef NullStringString = String? Function(String?);
typedef NullStringT<T> = String? Function(T?);
typedef NullBoolVoid = void Function(bool?);
typedef BoolVoid = void Function(bool);

typedef FutureVoid = Future<void> Function();
typedef FutureT<T> = Future<T> Function();
typedef VoidSetT<T> = Function(Set<T>);
typedef FuncBool<T> = bool Function(T);

typedef FuncBoolString = bool Function(String);
typedef FuncFutureBoolString = Future<bool> Function(String);
typedef FuncFutureNullableBoold = Future<bool?> Function();
typedef IntVoid = void Function(int);
typedef BigIntVoid = void Function(BigInt);
typedef BigIntRationalVoid = void Function(BigRational);

typedef FuncVoidNullT<T> = void Function(T);

typedef FutureNullString = Future<String?> Function();

typedef FuncTResult<T> = T? Function(T?);

abstract class _Live<T> extends LiveListenable<T> {
  @override
  String toString() => value.toString();

  @override
  bool operator ==(Object o) {
    if (o is T) return value == o;
    if (o is LiveListenable<T>) return value == o.value;
    return false;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  set value(T val) {
    super.value = val;
  }

  _Live(super.initial);
}

class Live<T> extends _Live<T> {
  Live(super.initial);
}

mixin _LiveListenable {
  final Set<DynamicVoid> _noneIdsListeners = {};

  void addListener(DynamicVoid callBack) {
    _noneIdsListeners.add(callBack);
  }

  void removeListener(DynamicVoid callBack) {
    _noneIdsListeners.remove(callBack);
  }

  void notify() {
    for (final i in [..._noneIdsListeners]) {
      i();
    }
  }
}

class LiveListenable<T> with _LiveListenable {
  LiveListenable(T val) : _value = val;

  static DynamicVoid? listener;

  static void _addListener(_LiveListenable listen) {
    final listenable = listener;
    if (listenable != null) {
      listen.addListener(listenable);
    }
  }

  void dispose() {
    _noneIdsListeners.clear();
  }

  T _value;

  T get value {
    _addListener(this);
    return _value;
  }

  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notify();
  }
}
