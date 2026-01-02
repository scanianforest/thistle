@abstract
class_name SaveData extends RefCounted

@abstract func get_save_path() -> String
@abstract func get_name() -> String
@abstract func get_metadata() -> SaveMetadata
@abstract func get_display_lines() -> PackedStringArray
