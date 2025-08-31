part of 'inventory_cubit.dart';

@immutable
abstract class InventoryState {}

class InventoryInitial extends InventoryState {}

class InventoryFilterChanged extends InventoryState {}
