 
meta:
  id: exfat
  endian: le
  imports:
    - root_dir
seq: 
  - id: boot_sector
    type: boot_sector
instances:
  root_directory:
    pos: boot_sector.root_dir_offset
    size: boot_sector.root_dir_size
    type: exfat_root_dir

types:
  boot_sector:
    seq:
      - id: jump_inst
        size: 3
      - id: oem_name
        type: u8
      - id: must_be_zero
        size: 53
        doc:  | 
            The valid value for this field is 0,
            which helps to prevent FAT12/16/32 implementations
            from mistakenly mounting an exFAT volume.
      - id: partition_offset
        type: u8
      - id: volume_length
        type: u8
      - id: fat_off_set
        type: u4
      - id: fat_length
        type: u4
      - id: cluster_heap_offset
        type: u4
      - id: cluster_count
        type: u4
      - id: first_cluster_root_dir
        type: u4
      - id: vol_serial_number
        type: u4
      - id: file_system_revision
        type: u2
      - id: volume_flags
        type: u2
      - id: bytes_per_sector_shift
        type: u1
      - id: sectors_per_cluster_shift
        type: u1
      - id: number_of_fats
        type: u1
      - id: dirve_select
        type: u1
      - id: percent_in_use
        type: u1
      - id: reserved
        size: 7 
      - id: boot_code
        size: 390
      - id: boot_signature
        type: u2
    instances:
      bytes_per_sector:
        value: 2 ** bytes_per_sector_shift
      sectors_per_cluster:
        value: 2 ** sectors_per_cluster_shift
      root_dir_offset:
        value: ((fat_off_set + fat_length) + ((first_cluster_root_dir -2) * sectors_per_cluster)) * bytes_per_sector
      root_dir_size:
        value: bytes_per_sector * sectors_per_cluster


