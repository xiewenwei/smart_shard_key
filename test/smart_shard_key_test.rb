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
    assert_equal 13, SmartShardKeyTestModel.shard_id_of_key(2048 + 13)

    assert_equal 5, SmartShardKeyTestModel.shard_id_of_key("2053")
  end

  def test_generate_id
    key0 = 124
    local_id0 = 101
    timestamp0 = 1451122080.3224
    assert_equal 12172894291966279781,
      SmartShardKeyTestModel.generate_id(key0, local_id0, timestamp0)

    key0 = 12424
    local_id0 = 101423532
    timestamp0 = 1451121083.8915
    assert_equal 12172885933297273260,
      SmartShardKeyTestModel.generate_id(key0, local_id0, timestamp0)
  end

  def test_get_shard_id_of_id
    assert_equal 124, SmartShardKeyTestModel.shard_id_of_id(12172894291966279781)
    assert_equal 136, SmartShardKeyTestModel.shard_id_of_id(12172885933297273260)
  end

  def test_split_id
    timestamp0, shard_id0, local_id0 = SmartShardKeyTestModel.split_id(12172894291966279781)
    assert_equal 124, shard_id0
    assert_equal 101, local_id0
    assert_equal 1451122080, timestamp0.to_i

    timestamp1, shard_id1, local_id1 = SmartShardKeyTestModel.split_id(12172885933297273260)
    assert_equal 136, shard_id1
    assert_equal 2476, local_id1
    assert_equal 1451121083, timestamp1.to_i
  end
end
