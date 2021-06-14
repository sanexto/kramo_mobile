class DeepMap {

  final Map<String, dynamic> map;

  DeepMap(this.map);

  void setValue(String key, dynamic value) {

    final List<String> k = key.split('.');

    if (k.isNotEmpty) {

      if (k.length == 1) {
        
        if (this.map.containsKey(k.last)) {
          
          this.map[k.last] = value;
          
        }

      } else {

        Map<String, dynamic> map = this.map;

        for (int i = 0; i < k.length - 1; i++) {

          if (map.containsKey(k[i]) && map[k[i]] is Map<String, dynamic>) {

            map = map[k[i]];

          } else {

            return;

          }

        }

        if (map.containsKey(k.last)) {

          map[k.last] = value;

        }

      }

    }

  }

  dynamic getValue(String key) {

    final List<String> k = key.split('.');

    if (k.isNotEmpty) {

      if (k.length == 1) {

        if (this.map.containsKey(k.last)) {

          return this.map[k.last];

        } else {

          return null;

        }

      } else {

        Map<String, dynamic> map = this.map;

        for (int i = 0; i < k.length - 1; i++) {

          if (map.containsKey(k[i]) && map[k[i]] is Map<String, dynamic>) {

            map = map[k[i]];

          } else {

            return null;

          }

        }

        if (map.containsKey(k.last)) {

          return map[k.last];

        } else {

          return null;

        }

      }

    } else {

      return null;

    }

  }

  bool? getBool(String key) {

    final dynamic value = this.getValue(key);

    if (value is bool) {

      return value;

    }

    return null;

  }

  int? getInt(String key) {

    final dynamic value = this.getValue(key);

    if (value is int) {

      return value;

    }

    return null;

  }

  double? getDouble(String key) {

    final dynamic value = this.getValue(key);

    if (value is double) {

      return value;

    }

    return null;

  }

  String? getString(String key) {

    final dynamic value = this.getValue(key);

    if (value != null) {

      return value.toString();

    }

    return null;

  }

  List<T> getList<T>(String key) {

    final dynamic value = this.getValue(key);

    if (value is List) {

      List<T>? list;

      try {

        list = value.cast<T>().toList();

      } catch (_) {}

      if (list != null) {

        return list;

      }

    }

    return [].cast<T>().toList();

  }

  Map<K, V> getMap<K, V>(String key) {

    final dynamic value = this.getValue(key);

    if (value is Map) {

      Map<K, V>? map;

      try {

        map = value.cast<K, V>().map((key, value) => MapEntry(key, value));

      } catch (_) {}

      if (map != null) {

        return map;

      }

    }

    return Map().cast<K, V>().map((key, value) => MapEntry(key, value));

  }

}
