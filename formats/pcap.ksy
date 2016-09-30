meta:
  id: pcap
  endian: le
seq:
  - id: header
    type: header
  - id: packets
    type: packet
    repeat: eos
types:
  header:
    seq:
      # https://wiki.wireshark.org/Development/LibpcapFileFormat#Global_Header
      - id: magic_number
        contents: [0xd4, 0xc3, 0xb2, 0xa1]
      - id: version_major
        type: u2
      - id: version_minor
        type: u2
      - id: thiszone
        type: s4
      - id: sigfigs
        type: u4
      - id: snaplen
        type: u4
      - id: network
        type: u4
        enum: linktype
  packet:
    seq:
      # https://wiki.wireshark.org/Development/LibpcapFileFormat#Record_.28Packet.29_Header
      - id: ts_sec
        type: u4
      - id: ts_usec
        type: u4
      - id: incl_len
        type: u4
      - id: orig_len
        type: u4
      # https://wiki.wireshark.org/Development/LibpcapFileFormat#Packet_Data
      - id: body
        size: incl_len
        if: '_root.header.network != linktype::ppi and _root.header.network != linktype::ethernet'
      - id: ppi_body
        type: packet_ppi
        size: incl_len
        if: '_root.header.network == linktype::ppi'
      - id: ethernet_body
        type: ethernet_frame
        size: incl_len
        if: '_root.header.network == linktype::ethernet'
  packet_ppi:
    seq:
      # https://www.cacetech.com/documents/PPI_Header_format_1.0.1.pdf - section 3
      - id: header
        type: packet_ppi_header
      - id: fields
        type: packet_ppi_field
        repeat: eos
  packet_ppi_header:
    seq:
      # https://www.cacetech.com/documents/PPI_Header_format_1.0.1.pdf - section 3.1
      - id: pph_version
        type: u1
      - id: pph_flags
        type: u1
      - id: pph_len
        type: u2
      - id: pph_dlt
        type: u4
  packet_ppi_field:
    seq:
      # https://www.cacetech.com/documents/PPI_Header_format_1.0.1.pdf - section 3.1
      - id: pfh_type
        type: u2
#        enum: pfh_type
      - id: pfh_datalen
        type: u2
#      - id: radio_802_11_common_body
#        #size: pfh_datalen
#        type: radio_802_11_common_body
#        if: pfh_type == pfh_type::radio_802_11_common
      - id: body
        size: pfh_datalen
#        if: pfh_type != pfh_type::radio_802_11_common
  radio_802_11_common_body:
    seq:
      # https://www.cacetech.com/documents/PPI_Header_format_1.0.1.pdf - section 4.1.2
      - id: tsf_timer
        type: u8
      - id: flags
        type: u2
      - id: rate
        type: u2
      - id: channel_freq
        type: u2
      - id: channel_flags
        type: u2
      - id: fhss_hopset
        type: u1
      - id: fhss_pattern
        type: u1
      - id: dbm_antsignal
        type: s1
      - id: dbm_antnoise
        type: s1
  ethernet_frame:
    seq:
      - id: dst_mac
        size: 6
      - id: src_mac
        size: 6
      - id: ether_type
        type: u2be
        enum: ether_type
      - id: ipv4_body
        type: ipv4_packet
        size-eos: true
        if: ether_type == ether_type::ipv4
      - id: body
        size-eos: true
        if: ether_type != ether_type::ipv4
  ipv4_packet:
    seq:
      - id: b1
        type: u1
      - id: b2
        type: u1
      - id: total_length
        type: u2be
      - id: identification
        type: u2be
      - id: b67
        type: u2be
      - id: ttl
        type: u1
      - id: protocol
        type: u1
        enum: protocol
      - id: header_checksum
        type: u2be
      - id: src_ip_addr
        size: 4
      - id: dst_ip_addr
        size: 4
      - id: options
        type: ipv4_options
        size: ihl_bytes - 20
      - id: tcp_segment_body
        type: tcp_segment
        if: protocol == protocol::tcp
      - id: body
        size: total_length - ihl_bytes
        if: protocol != protocol::tcp
    instances:
      version:
        value: (b1 & 0xf0) >> 4
      ihl:
        value: b1 & 0xf
      ihl_bytes:
        value: ihl * 4
  ipv4_options:
    seq:
      - id: entries
        type: ipv4_option
        repeat: eos
  ipv4_option:
    seq:
      - id: b1
        type: u1
      - id: len
        type: u1
      - id: body
        size: 'len > 2 ? len - 2 : 0'
    instances:
      copy:
        value: (b1 & 0b10000000) >> 7
      opt_class:
        value: (b1 & 0b01100000) >> 5
      number:
        value: (b1 & 0b00011111)
  tcp_segment:
    seq:
      - id: src_port
        type: u2
      - id: dst_port
        type: u2
      - id: seq_num
        type: u4
      - id: ack_num
        type: u4
      - id: b12
        type: u1
      - id: b13
        type: u1
      - id: window_size
        type: u2
      - id: checksum
        type: u2
      - id: urgent_pointer
        type: u2
      - id: body
        size-eos: true
enums:
  linktype:
    # http://www.tcpdump.org/linktypes.html
    0: null_linktype
    1: ethernet
    3: ax25
    6: ieee802_5
    7: arcnet_bsd
    8: slip
    9: ppp
    10: fddi
    50: ppp_hdlc
    51: ppp_ether
    100: atm_rfc1483
    101: raw
    104: c_hdlc
    105: ieee802_11
    107: frelay
    108: loop
    113: linux_sll
    114: ltalk
    117: pflog
    119: ieee802_11_prism
    122: ip_over_fc
    123: sunatm
    127: ieee802_11_radiotap
    129: arcnet_linux
    138: apple_ip_over_ieee1394
    139: mtp2_with_phdr
    140: mtp2
    141: mtp3
    142: sccp
    143: docsis
    144: linux_irda
    147: user0
    148: user1
    149: user2
    150: user3
    151: user4
    152: user5
    153: user6
    154: user7
    155: user8
    156: user9
    157: user10
    158: user11
    159: user12
    160: user13
    161: user14
    162: user15
    163: ieee802_11_avs
    165: bacnet_ms_tp
    166: ppp_pppd
    169: gprs_llc
    170: gpf_t
    171: gpf_f
    177: linux_lapd
    187: bluetooth_hci_h4
    189: usb_linux
    192: ppi
    195: ieee802_15_4
    196: sita
    197: erf
    201: bluetooth_hci_h4_with_phdr
    202: ax25_kiss
    203: lapd
    204: ppp_with_dir
    205: c_hdlc_with_dir
    206: frelay_with_dir
    209: ipmb_linux
    215: ieee802_15_4_nonask_phy
    220: usb_linux_mmapped
    224: fc_2
    225: fc_2_with_frame_delims
    226: ipnet
    227: can_socketcan
    228: ipv4
    229: ipv6
    230: ieee802_15_4_nofcs
    231: dbus
    235: dvb_ci
    236: mux27010
    237: stanag_5066_d_pdu
    239: nflog
    240: netanalyzer
    241: netanalyzer_transparent
    242: ipoib
    243: mpeg_2_ts
    244: ng40
    245: nfc_llcp
    247: infiniband
    248: sctp
    249: usbpcap
    250: rtac_serial
    251: bluetooth_le_ll
    253: netlink
    254: bluetooth_linux_monitor
    255: bluetooth_bredr_bb
    256: bluetooth_le_ll_with_phdr
    257: profibus_dl
    258: pktap
    259: epon
    260: ipmi_hpm_2
    261: zwave_r1_r2
    262: zwave_r3
    263: wattstopper_dlm
    264: iso_14443
  pfh_type:
    # https://www.cacetech.com/documents/PPI_Header_format_1.0.1.pdf - section 4
    2: radio_802_11_common
    3: radio_802_11n_mac_ext
    4: radio_802_11n_mac_phy_ext
    5: spectrum_map
    6: process_info
    7: capture_info
  # http://www.iana.org/assignments/ieee-802-numbers/ieee-802-numbers.xhtml
  ether_type:
    0x0800: ipv4
    0x0801: x_75_internet
    0x0802: nbs_internet
    0x0803: ecma_internet
    0x0804: chaosnet
    0x0805: x_25_level_3
    0x0806: arp
  protocol:
    # http://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml
    0: hopopt
    1: icmp
    2: igmp
    3: ggp
    4: ipv4
    5: st
    6: tcp
    7: cbt
    8: egp
    9: igp
    10: bbn_rcc_mon
    11: nvp_ii
    12: pup
    13: argus
    14: emcon
    15: xnet
    16: chaos
    17: udp
    18: mux
    19: dcn_meas
    20: hmp
    21: prm
    22: xns_idp
    23: trunk_1
    24: trunk_2
    25: leaf_1
    26: leaf_2
    27: rdp
    28: irtp
    29: iso_tp4
    30: netblt
    31: mfe_nsp
    32: merit_inp
    33: dccp
    34: protocol_3pc
    35: idpr
    36: xtp
    37: ddp
    38: idpr_cmtp
    39: tp_plus_plus
    40: il
    41: ipv6
    42: sdrp
    43: ipv6_route
    44: ipv6_frag
    45: idrp
    46: rsvp
    47: gre
    48: dsr
    49: bna
    50: esp
    51: ah
    52: i_nlsp
    53: swipe
    54: narp
    55: mobile
    56: tlsp
    57: skip
    58: ipv6_icmp
    59: ipv6_nonxt
    60: ipv6_opts
    61: any_host_internal_protocol
    62: cftp
    63: any_local_network
    64: sat_expak
    65: kryptolan
    66: rvd
    67: ippc
    68: any_distributed_file_system
    69: sat_mon
    70: visa
    71: ipcv
    72: cpnx
    73: cphb
    74: wsn
    75: pvp
    76: br_sat_mon
    77: sun_nd
    78: wb_mon
    79: wb_expak
    80: iso_ip
    81: vmtp
    82: secure_vmtp
    83: vines
    84: ttp
    84: iptm
    85: nsfnet_igp
    86: dgp
    87: tcf
    88: eigrp
    89: ospfigp
    90: sprite_rpc
    91: larp
    92: mtp
    93: ax_25
    94: ipip
    95: micp
    96: scc_sp
    97: etherip
    98: encap
    99: any_private_encryption_scheme
    100: gmtp
    101: ifmp
    102: pnni
    103: pim
    104: aris
    105: scps
    106: qnx
    107: a_n
    108: ipcomp
    109: snp
    110: compaq_peer
    111: ipx_in_ip
    112: vrrp
    113: pgm
    114: any_0_hop
    115: l2tp
    116: ddx
    117: iatp
    118: stp
    119: srp
    120: uti
    121: smp
    122: sm
    123: ptp
    124: isis_over_ipv4
    125: fire
    126: crtp
    127: crudp
    128: sscopmce
    129: iplt
    130: sps
    131: pipe
    132: sctp
    133: fc
    134: rsvp_e2e_ignore
    135: mobility_header
    136: udplite
    137: mpls_in_ip
    138: manet
    139: hip
    140: shim6
    141: wesp
    142: rohc
    255: reserved_255
