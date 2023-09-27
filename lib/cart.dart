
import 'package:play_connect/models/playAreas.dart';
import 'package:play_connect/store.dart';
import 'package:velocity_x/velocity_x.dart';

class CartModel{



  late CatalogModel _catalog;

  //Collections of IDs - store ids of each item, u can avoid get and set by keeping _catalog as publuc by remove _ just catalog
  final List<int> _playAreaIds=[];

  CatalogModel get catalog => _catalog;
  set catalog(CatalogModel newCatalog){
    assert(newCatalog != null);
    _catalog = newCatalog;
  }

  //Get items in cart

  List<PlayArea> get playAreas => _playAreaIds.map((id)=>_catalog.getById(id)).toList();

  //Get total price
  num get totalPrice =>playAreas.fold(0, (total, current) => total+current.playAreaPrice);



}

class AddMutation extends VxMutation<MyStore>{
  final PlayArea playArea;

  AddMutation(this.playArea);
  @override
  perform() {
    store!.cart._playAreaIds.add(playArea.id);
  }

}

class RemoveMutation extends VxMutation<MyStore>{
  final PlayArea playArea;

  RemoveMutation(this.playArea);
  @override
  perform() {
    store!.cart._playAreaIds.remove(playArea.id);
  }

}