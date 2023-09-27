import 'package:play_connect/cart.dart';
import 'package:play_connect/models/playAreas.dart';
import 'package:velocity_x/velocity_x.dart';

class MyStore extends VxStore{
  CatalogModel catalog=CatalogModel();
  CartModel cart=CartModel();

  MyStore() {
    catalog=CatalogModel();
    cart=CartModel();
    cart.catalog=catalog;

  }

}