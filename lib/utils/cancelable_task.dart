import 'package:async/async.dart';

class CancelableTask {

  final Map<String, CancelableOperation> _task = {};

  CancelableOperation<T> run<T>(String id, Future<T> future) {

    this._task[id]?.cancel();
    this._task[id] = CancelableOperation.fromFuture(future);

    return this._task[id] as CancelableOperation<T>;

  }

  void cancel() {

    this._task.forEach((String id, CancelableOperation task) {

      task.cancel();

    });

  }

}
