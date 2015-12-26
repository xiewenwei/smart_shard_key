require "smart_shard_key/version"

module SmartShardKey
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    # smart_id total len
    TOTAL_LEN = 64
    # len of timestamp
    TIMESTAMP_LEN = 36
    # len of shard_id
    SHARD_ID_LEN = 13
    # len of sequence
    SEQUENCE_LEN = 15

    # return shard_id of the given key
    # @param key[int]
    # @return shard_id[int]
    def shard_id_of_key(key)
      key.to_i % (1 << SHARD_ID_LEN)
    end

    # return shard_id of the given id
    # @param id[int] 64 bits id
    # @return shard_id[int]
    def shard_id_of_id(id)
      (id >> SEQUENCE_LEN) & ((1 << SHARD_ID_LEN) - 1)
    end

    # generate smart id
    # @param key[int]
    # @param sequence[int] optional
    # @param timestamp[float] optional
    # @return smart id[int] 64 bits integer
    def generate_id(key, sequence = nil, timestamp = nil)
      scale_timestamp =
        if timestamp
          (timestamp * 10).to_i
        else
          (Time.now.to_f * 10).to_i
        end

      shard_id = shard_id_of_key(key)

      # use random value for sequence without given
      safe_sequence =
        if sequence
          sequence % (1 << SEQUENCE_LEN)
        else
          rand(1 << SEQUENCE_LEN)
        end

      (scale_timestamp << (TOTAL_LEN - TIMESTAMP_LEN)) |
        (shard_id << SEQUENCE_LEN) |
        safe_sequence
    end

    # split smart id to three segment: timestamp, shard_id and sequence
    # @param id[int] smart id
    # @return [timestamp[Time], shard_id[int], sequence[int]]
    def split_id(id)
      timestamp = (id >> (TOTAL_LEN - TIMESTAMP_LEN)) / 10.0

      shard_id = (id >> SEQUENCE_LEN) & ((1 << SHARD_ID_LEN) - 1)

      sequence = id & ((1 << SEQUENCE_LEN) - 1)

      [Time.at(timestamp), shard_id, sequence]
    end
  end

end
