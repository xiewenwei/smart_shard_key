require "smart_shard_key/version"

module SmartShardKey
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    # 64 bits for the smart_id
    TOTAL_LEN = 64
    # 41 bits for time in milliseconds (gives us 41 years of IDs with a custom epoch)
    TIMESTAMP_LEN = 41
    # 11 bits that represent the logical shard ID
    SHARD_ID_LEN = 11
    # 12 bits that represent an auto-incrementing sequence, modulus 4096. This means we can generate 4096 IDs, per shard, per millisecond
    LOCAL_ID_LEN = 12

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
      (id >> LOCAL_ID_LEN) & ((1 << SHARD_ID_LEN) - 1)
    end

    # generate smart id
    # @param key[int]
    # @param local_id[int] optional
    # @param timestamp[float] optional
    # @return smart id[int] 64 bits integer
    def generate_id(key, local_id = nil, timestamp = nil)
      scale_timestamp =
        if timestamp
          (timestamp * 1000).to_i
        else
          (Time.now.to_f * 1000).to_i
        end

      shard_id = shard_id_of_key(key)

      # use random value for local_id without given
      safe_local_id =
        if local_id
          local_id % (1 << LOCAL_ID_LEN)
        else
          rand(1 << LOCAL_ID_LEN)
        end

      (scale_timestamp << (TOTAL_LEN - TIMESTAMP_LEN)) |
        (shard_id << LOCAL_ID_LEN) |
        safe_local_id
    end

    # split smart id to three segment: timestamp, shard_id and local_id
    # @param id[int] smart id
    # @return array[timestamp[Time], shard_id[int], local_id[int]]
    def split_id(id)
      timestamp = (id >> (TOTAL_LEN - TIMESTAMP_LEN)) / 1000.0

      shard_id = (id >> LOCAL_ID_LEN) & ((1 << SHARD_ID_LEN) - 1)

      local_id = id & ((1 << LOCAL_ID_LEN) - 1)

      [Time.at(timestamp), shard_id, local_id]
    end
  end

end
