meta:
  id: mbr_partition_table
  title: MBR (Master Boot Record) partition table
  xref:
    wikidata: Q624752
  license: CC0-1.0
  endian: le
doc: |
  MBR (Master Boot Record) partition table is a traditional way of
  MS-DOS to partition larger hard disc drives into distinct
  partitions.

  This table is stored in the end of the boot sector (first sector) of
  the drive, after the bootstrap code. Original DOS 2.0 specification
  allowed only 4 partitions per disc, but DOS 3.2 introduced concept
  of "extended partitions", which work as nested extra "boot records"
  which are pointed to by original ("primary") partitions in MBR.
seq:
  - id: bootstrap_code
    size: 440
  - id: disk_signature
    type: u4
  - id: copy_protected
    type: u2
    enum: copy_protected_lookup
  - id: partition
    type: partition_entry
    repeat: expr
    repeat-expr: 4
    -hax-interpreter:
      generate:
        partition:
          if: _.num_sectors > 0
          start: _.lba_start * 512
          length: _.num_sectors * 512
    
  - id: boot_signature
    contents: [0x55, 0xaa]
types:
  extended_entry:
    seq:
      - id: extended_logical_partition
        type: extended_partition_entry
      - id: extended_partition
        type: extended_partition_entry
    instances:
      next_extended_partition:
        io: _root._io
        if: extended_partition.partition_id == partition_type::extended
        pos: lba_start_bytes +(extended_partition.ex_lba_start * 512) + 446
        type: extended_entry

  extended_partition_entry:
    seq:
      - id: status
        type: u1
      - id: chs_start
        type: chs_s
      - id: partition_id
        type: u1
        enum: partition_type
      - id: chs_end
        type: chs_e
      - id: ex_lba_start
        type: u4
      - id: ex_num_sectors
        type: u4
    instances:
      ex_lba_start_bytes:
       value: (ex_lba_start * 512)
      ex_partition_size:
       value: (ex_num_sectors * 512)

  partition_entry:
    seq:
      - id: status
        type: u1
      - id: chs_start
        type: chs_s
      - id: partition_id
        type: u1
        enum: partition_type
      - id: chs_end
        type: chs_e
      - id: lba_start
        type: u4
      - id: num_sectors
        type: u4
    instances:
      lba_start_bytes:
        value: (lba_start * 512)
      partition_size:
        value: (num_sectors * 512)
      ex_part:
        io: _root._io
        if: partition_id == partition_type::extended
        pos: lba_start_bytes + 446
        type: extended_entry
        
  chs_s:
    meta: 
      bit-endian: be
    seq:
      - id: head
        type: u1
      - id: b2
        type: u1
      - id: b3
        type: u1
    instances:
      sector:
        value: 'b2 & 0b111111'
      cylinder:
        value: b3 + ((b2 & 0b11000000) << 2)
      c_h_s_start:
        value: head * sector * cylinder
  chs_e:
    meta: 
      bit-endian: le
    seq:
      - id: head
        type: u1
      - id: b2
        type: u1
      - id: b3
        type: u1
    instances:
      sector:
        value: 'b2 & 0b111111'
      cylinder:
        value: '((b2 & 0b11000000) << 2) + b3'
      c_h_s_end:
        value: head * sector * cylinder
enums:
  copy_protected_lookup:
    0x5a5a: protected
    0x0000: not_protected
  partition_type:
    0x00: empty
    0x01: fat12
    0x02: xenix_root
    0x03: xenix_usr
    0x04: fat16_32m
    0x05: extended
    0x06: fat16
    0x07: hpfs_ntfs_exfat_refs
    0x08: aix
    0x09: aix_bootable
    0x0a: os_2_boot_manag
    0x0b: w95_fat32
    0x0c: w95_fat32_lba
    0x0e: w95_fat16_lba
    0x0f: w95_extd_lba
    0x10: opus
    0x11: hidden_fat12
    0x12: compaq_diagnost
    0x14: hidden_fat16_3
    0x16: hidden_fat16
    0x17: hidden_hpfs_ntf
    0x18: ast_smartsleep
    0x1b: hidden_w95_fat3
    0x1c: hidden_w95_fat2
    0x1e: hidden_w95_fat1
    0x24: nec_dos
    0x27: hidden_ntfs_win
    0x39: plan_9
    0x3c: partitionmagic
    0x40: venix_80286
    0x41: ppc_prep_boot
    0x42: sfs
    0x4d: qnx4_x
    0x4e: qnx4_x2nd_part
    0x4f: qnx4_x_3rd_part
    0x50: ontrack_dm
    0x51: ontrack_dm6_aux
    0x52: cp_m
    0x53: ontrack_dm6_aux1
    0x54: ontrackdm6
    0x55: ez_drive
    0x56: golden_bow
    0x5c: priam_edisk
    0x61: speedstor
    0x63: gnu_hurd_or_sys
    0x64: novell_netware1
    0x65: novell_netware
    0x70: disksecure_mult
    0x75: pc_ix
    0x80: old_minix
    0xbf: solaris
    0x82: linux_swap_so
    0x83: linux
    0x84: os_2_hidden_c
    0x85: linux_extended
    0x86: ntfs_volume_set1
    0x87: ntfs_volume_set
    0x88: linux_plaintext
    0x8e: linux_lvm
    0x93: amoeba
    0x94: amoeba_bbt
    0x9f: bsd_os
    0xa0: ibm_thinkpad_hi
    0xa5: freebsd
    0xa6: openbsd
    0xa7: nextstep
    0xa8: darwin_ufs
    0xa9: netbsd
    0xab: darwin_boot
    0xaf: hfs_hfs_plus
    0xb7: bsdi_fs
    0xb8: bsdi_swap
    0xbb: boot_wizard_hid
    0xbe: solaris_boot
    0xc1: secured_fs_fat12
    0xc4: secured_fs_fat16
    0xc6: secured_fs
    0xc7: syrinx
    0xda: non_fs_data
    0xdb: cp_m_ctos
    0xde: dell_utility
    0xdf: bootit
    0xe1: dos_access
    0xe3: dos_r_o
    0xe4: speedstor_fat16_less32mb
    0xeb: beos_fs
    0xee: gpt
    0xef: efi_fat_12_16
    0xf0: linux_pa_risc_b
    0xf1: speedstor_fatb1
    0xf4: speedstor_fatb2
    0xf2: dos_secondary
    0xfb: vmware_vmfs
    0xfc: vmware_vmkcore
    0xfd: linux_raid_auto
    0xfe: lanstep
    0xff: bbt