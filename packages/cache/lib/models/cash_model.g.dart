// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CashDataAdapter extends TypeAdapter<CashData> {
  @override
  final int typeId = 0;

  @override
  CashData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CashData(
      key: fields[1] as String,
      object: fields[2] as Object,
    );
  }

  @override
  void write(BinaryWriter writer, CashData obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.key)
      ..writeByte(2)
      ..write(obj.object);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CashDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
