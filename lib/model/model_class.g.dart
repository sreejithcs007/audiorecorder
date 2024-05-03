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
      name: fields[0] as String?,
      location: fields[1] as String?,
      date: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Modelclasss obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.location)
      ..writeByte(2)
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
