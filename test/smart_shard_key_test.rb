require 'test_helper'

class SmartShardKeyTestModel
  include SmartShardKey
end

class SmartShardKeyTest < Minitest::Test
  def setup
    @smart_id = 2342352325252323
  end

  def test_that_it_has_a_version_number
    refute_nil ::SmartShardKey::VERSION
  end

  def test_get_shard_id_of_key
    assert_equal 0, SmartShardKeyTestModel.shard_id_of_key(0)
    assert_equal 102, SmartShardKeyTestModel.shard_id_of_key(102)
    assert_equal 13, SmartShardKeyTestModel.shard_id_of_key(8192 + 13)

    assert_equal 5, SmartShardKeyTestModel.shard_id_of_key("8197")
  end

  def test_generate_id
    key0 = 124
    sequence0 = 101
    timestamp0 = 1451122080.3224
    assert_equal 3895326173374054501,
      SmartShardKeyTestModel.generate_id(key0, sequence0, timestamp0)

    key0 = 12424
    sequence0 = 101423532
    timestamp0 = 1451121083.8915
    assert_equal 3895323498549352876,
      SmartShardKeyTestModel.generate_id(key0, sequence0, timestamp0)
  end

  def test_get_shard_id_of_id
    assert_equal 124, SmartShardKeyTestModel.shard_id_of_id(3895326173374054501)
    assert_equal 4232, SmartShardKeyTestModel.shard_id_of_id(3895323498549352876)
  end

  def test_split_id
    timestamp0, shard_id0, sequence0 = SmartShardKeyTestModel.split_id(3895326173374054501)
    assert_equal 124, shard_id0
    assert_equal 101, sequence0
    assert_equal 1451122080, timestamp0.to_i

    timestamp1, shard_id1, sequence1 = SmartShardKeyTestModel.split_id(3895323498549352876)
    assert_equal 4232, shard_id1
    assert_equal 6572, sequence1
    assert_equal 1451121083, timestamp1.to_i
  end
end
