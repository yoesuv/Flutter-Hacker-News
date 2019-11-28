import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class StoriesBloc{

    final _repository = Repository();
    final _topIds = PublishSubject<List<int>>();

    Observable<List<int>> get topIds => _topIds.stream;

    fetchTopIds() async {
        final ids = await _repository.fetchTopIds();
        _topIds.sink.add(ids);
    }

    _itemTransformer() {
        return ScanStreamTransformer(
            (Map<int, Future<ItemModel>> cache, int id, index) {
                cache[id] = _repository.fetchItem(id);
                return cache;
            },
            <int, Future<ItemModel>>{}
        );
    }

    dispose() {
        _topIds.close();
    }

}
