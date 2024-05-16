meta:
  id: exfat_root_dir
  endian: le
doc-ref: http://www.ntfs.com/exfat-file-directory-entry.htm, http://active-undelete.com/xfat_entries.htm#section_pht_555_b3

seq:
  - id: entries
    type: records
    size: 32
    repeat: until
    repeat-until: _.entry_type == 0x00

types:
  records:
    seq:
    - id: entry_type
      type: u1
      enum: directory_entry
    - id: records
      type:
        switch-on: entry_type
        cases:
          'directory_entry::allocation_bitmap': allocation_bitmap
          'directory_entry::up_case_table': up_case_table
          'directory_entry::volume_label': volume_label
          'directory_entry::file': file_dir_entry
          'directory_entry::volume_guid': volume_g_u_i_d_entry
          'directory_entry::texfat_padding': t_ex_fat_padding
          'directory_entry::windows_ce_access_control_table': windows_c_e_access_control
          'directory_entry::stream_extension': stream_extension
          'directory_entry::file_name': file_name

  allocation_bitmap:
    seq:
      - id: bitmap_flag
        type: b1
        enum: bitmap_flags
        doc: Indicates which Allocation Bitmap the given entry describes
      - id: reserved1
        type: b7
      - id: reserved2
        size: 18
      - id: first_cluster
        type: u4
      - id: data_length
        type: u8

  up_case_table:
    seq:
      - id: reserved1
        size: 3
      - id: table_check_sum
        type: u4
      - id: reserved2
        size: 12
      - id: first_cluster
        type: u4
      - id: data_length
        type: u8

  volume_label:
    seq:
      - id: character_count
        type: u1
      - id: volume_label
        size: 22
        type: str
        encoding: ascii
      - id: reserved
        type: u8

  file_dir_entry:
    seq:
      - id: secondary_count
        type: u1
      - id: set_check_sum
        type: u2
      - id: file_attributes
        type: u2
        enum: file_attrib
      - id: reserved1
        type: u2
      - id: create_time_stamp
        type: u4
      - id: last_mod_time
        type: u4
      - id: last_accessed_time
        type: u4
      - id: create_10ms_time_stamp
        type: u1
        doc: 0..199
      - id: last_mod_10ms_time_stamp
        type: u1
        doc: 0..199
      - id: create_time_zone
        type: u1
        doc: Offset from UTC in 15 min increments
      - id: last_mod_10ms_time_zone
        type: u1
        doc: Offset from UTC in 15 min increments
      - id: last_accessed_time_zone
        type: u1
        doc: Offset from UTC in 15 min increments
      - id: reserved2
        size: 7

  volume_g_u_i_d_entry:
    seq:
      - id: secondary_count
        type: u1
        doc: Must be 0x00
      - id: set_check_sum
        type: u2
      - id: general_primary_flags
        type: u2
        doc: Must be Zero
      - id: volume_guid
        size: 16
      - id: reserved
        size: 10

  t_ex_fat_padding:
    seq:
      - id: reserved
        size: 31

  windows_c_e_access_control:
    seq:
      - id: reserved
        size: 31

  stream_extension:
    seq:
      - id: general_secondary_flags
        type: u1
        doc: Must be one
      - id: reserved1
        type: u1
      - id: name_len
        type: u1
        doc: Length of Unicode name contained in subsequent File Name directory entries
      - id: name_hash
        type: u2
        doc: Hash of up-cased file name
      - id: reserved2
        type: u2
      - id: valid_data_length
        type: u8
        doc: Must be between 0 and DataLength
      - id: reserved3
        type: u4
      - id: first_cluster
        type: u4
      - id: data_length
        type: u8
        doc: For directories maximum 256 MB

  file_name:
    seq:
      - id: general_secondary_flags
        type: u1
        doc: Must be zero
      - id: file_name
        size: 30
        type: str
        encoding: ascii

enums:
  bitmap_flags:
    0: "first_bit_map"
    1: "second_bit_map"
  directory_entry:
    0x00: "end"
    0x81: "allocation_bitmap"
    0x82: "up_case_table"
    0x83: "volume_label"
    0x85: "file"
    0xA0: "volume_guid"
    0xA1: "texfat_padding"
    0xA2: "windows_ce_access_control_table"
    0xC0: "stream_extension"
    0xC1: "file_name"
  file_attrib:
    0x01: "read_only"
    0x02: "hidden_file"
    0x04: "system_file"
    0x08: "disk_volume_label"
    0x0f: "long_file_name"
    0x10: "subdirectory"
    0x20: "archive"
