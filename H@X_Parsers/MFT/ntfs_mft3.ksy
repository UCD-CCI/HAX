meta:
  id: ntfs_mft_record
  endian: le
seq:
  - id: ntfs_file_system
    type: mft_record_header
types:
  mft_record_header:
    seq:
      - id: signature
        size: 4
        type: str
        encoding: UTF-8
      - id: fixup_array_offset
        type: u2
      - id: num_fixup_array_entries
        type: u2
      - id: logfile_update_seq_number
        type: u8
      - id: seq_count
        type: u2
      - id: file_name_count
        type: u2
      - id: offset_first_attribute
        type: u2
      - id: allocation_status
        type: u2 
        enum: allocation
      - id: logical_size_file_records
        type: u4
      - id: physical_size_file_records
        type: u4
      - id: base_record
        type: u8
      - id: next_attribute_i_d
        type: u2
      - id: mft_entry_id
        size: 6
        -hax-interpreter:
          output: 
            decode: integers(uint48)
      - id: fix_up_array
        size: 2
      - id: fix_up_value_1
        size: 2
      - id: fix_up_value_2
        size: 2
      - id: fix_up_value_3
        size: 2
      - id: attributes_list
        type: attributes
     #   repeat: eos
 #   instances:
 #     attributes_parsed:
 #       pos: offset_first_attribute
 #       type: attributes
       # size: logical_size_file_records - offset_first_attribute
        repeat: until
      #  repeat-expr: next_attribute_i_d
        repeat-until: _.attribute == attribute_types::end_of_mft_entry
    enums:
      allocation:
        0x00: "file_deleted"
        0x01: "file_allocated"
        0x02: "folder_deleted"
        0x03: "folder_allocated"
  attributes:
    seq:
      - id: attribute
        type: u4
        enum: attribute_types
      - id: length
        type: u4 
        if: attribute != attribute_types::end_of_mft_entry
      - id: resident_flag
        type: u1
        enum: resident_flag    
        if: attribute != attribute_types::end_of_mft_entry
      - id: length_of_attribute_stream_name
        type: u1
        if: attribute != attribute_types::end_of_mft_entry
      - id: offset_to_attribute_stream_name
        type: u2
        if: attribute != attribute_types::end_of_mft_entry
      - id: attribute_flags
        type: u2
        if: attribute != attribute_types::end_of_mft_entry
      - id: attribute_i_d
        type: u2
        if: attribute != attribute_types::end_of_mft_entry
      - id: attribute_parse
        if: attribute != attribute_types::end_of_mft_entry
        size: length - 16
        type: 
          switch-on: resident_flag
          cases:
            'resident_flag::resident': resident
            'resident_flag::non_resident': non_resident       
    enums:
      resident_flag:
        0x00: "resident"
        0x01: "non_resident"
  resident:
    seq:
      - id: length_of_attribute
        type: u4
      - id: offset_to_attribute
        type: u2
      - id: indexed_flag
        type: u1
      - id: padding
        type: u1
      - id: attribute_content_parse
        size: _parent.length - offset_to_attribute
        type: 
          switch-on: _parent.attribute
          cases:
            'attribute_types::standard_information': standard_information
            'attribute_types::attribute_list': attribute_list       
            'attribute_types::file_name': file_name
            'attribute_types::object_id': object_id
            'attribute_types::security_descriptor': security_descriptor
            'attribute_types::volume_name': volume_name
            'attribute_types::volume_information': volume_information
            'attribute_types::data': data
            'attribute_types::index_root': index_root
            'attribute_types::index_bitmap': index_bitmap       
  non_resident:
    seq:  
      - id: startcluster_virt_runlist
        type: u8
      - id: endcluster_virt_runlist
        type: u8  
      - id: offset_runlist
        type: u2
      - id: compressed_size
        type: u2
      - id: reserved
        type: u4
      - id: physical_size
        type: u8
      - id: logical_size
        type: u8
      - id: initiated_size
        type: u8
      - id: attribute_content_parse
        size: _parent.length - offset_runlist
        type: 
          switch-on: _parent.attribute
          cases:
            'attribute_types::attribute_list': attribute_list       
            'attribute_types::security_descriptor': security_descriptor
            'attribute_types::data': data
            'attribute_types::index_allocation': index_allocation
            'attribute_types::index_bitmap': index_bitmap       
  standard_information:
    seq:
      - id: c_time
        type: u8
      - id: a_time
        type: u8
      - id: m_time
        type: u8
      - id: r_time
        type: u8
      - id: d_o_s_file_permissions
        type: u4
      - id: max_num_of_versions
        type: u4
      - id: version_number
        type: u4
  attribute_list:
    seq:
      - id: attribute_list_content
        size-eos: true
  file_name:
    seq:
      - id: m_f_t_reference_to_the_parent_directory
        size: 6
      - id: seq_num_of_parent_directory
        type: u2
      - id: c_time
        type: u8
      - id: a_time
        type: u8
      - id: m_time
        type: u8
      - id: r_time
        type: u8
      - id: allocated_size_of_file
        type: u8
      - id: real_size_of_file
        type: u8
      - id: flags
        type: u4
      - id: used_by_e_a_and_reparse
        type: u4
      - id: filename_length_in_charcters
        type: u1
      - id: filename_namespace
        type: u1
      - id: file_name_in_unicode
        type: str
        encoding: UTF-8
        size-eos: true
  object_id:
    seq:
      - id: object_id_content
        size-eos: true
  security_descriptor:
    seq:
      - id: sec_desc
        size-eos: true
  volume_name:
    seq:
      - id: volume_name_content
        size-eos: true
  volume_information:
    seq:
      - id: volume_information_content
        size-eos: true
  data:
    seq:
      - id: data_or_data_run
        size-eos: true
  index_root:
    seq:
      - id: index_root_content
        size-eos: true
  index_allocation:
    seq:
      - id: index_allocation_content
        size-eos: true
  index_bitmap:
    seq:
      - id: index_bitmap_content
        size-eos: true
  reparse_point:
    seq:
      - id: reparse_point_content
        size-eos: true
  e_a_information:
    seq:
      - id: e_a_information_content
        size-eos: true
  e_a:
    seq:
      - id: e_a_content
        size-eos: true
  property_set:
    seq:
      - id: property_set_content
        size-eos: true
  logged_utility_stream:
    seq:
      - id: logged_utility_stream_content
        size-eos: true
enums:
  attribute_types:
      0x00000010: "standard_information"
      0x00000020: "attribute_list"
      0x00000030: "file_name"
      0x00000040: "object_id" ###Need to disern ntfs version####
      0x00000050: "security_descriptor"
      0x00000060: "volume_name"
      0x00000070: "volume_information"
      0x00000080: "data"
      0x00000090: "index_root"
      0x000000a0: "index_allocation"
      0x000000b0: "index_bitmap"
      0x000000c0: "reparse_point"
      0x000000d0: "e_a_information"
      0x000000e0: "e_a"
      0x000000f0: "property_set"
      0x00000001: "logged_utility_stream"
      0xffffffff: "end_of_mft_entry"