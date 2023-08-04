meta:
  id: benchmark_process_xor
  endian: le
seq:
  - id: chunks
    repeat: eos
    type: chunk
types:
  chunk:
    seq:
      - id: len_body
        type: u4
      - id: body
        size: len_body
        process: xor(0xaa)
        type: integers
  integers:
    seq:
      - id: numbers
        type: s4
        repeat: eos
