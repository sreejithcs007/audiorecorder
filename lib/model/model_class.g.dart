// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelclasssAdapter extends TypeAdapter<Modelclasss> {
  @override
  final int typeId = 1;

  @override
  Modelclasss read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Modelclasss(
      name: fields[1] as String?,
      location: fields[2] as String?,
      date: fields[3] as String?,
      key: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Modelclasss obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelclasssAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
