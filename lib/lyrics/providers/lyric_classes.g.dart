// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyric_classes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LyricLineAdapter extends TypeAdapter<LyricLine> {
  @override
  final typeId = 1;

  @override
  LyricLine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LyricLine(
      line: fields[1] as String,
      timestamp: fields[0] as Duration,
    );
  }

  @override
  void write(BinaryWriter writer, LyricLine obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.line);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LyricLineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
