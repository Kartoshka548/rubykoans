require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutBlocks < Neo::Koan
  F = Proc.new { 1 + 2 }

  def method_with_block
    result = yield if block_given?
    result
  end

  def test_methods_can_take_blocks
    yielded_result = method_with_block &F
    assert_equal F.call, yielded_result
  end

  def test_blocks_can_be_defined_with_do_end_too
    yielded_result = method_with_block do
      F.call
    end
    assert_equal F.call, yielded_result
  end

  # ------------------------------------------------------------------

  def method_with_block_arguments
    yield "Jim"
  end

  def test_blocks_can_take_arguments
    method_with_block_arguments do |each_yielded_value|
      assert_equal 'Jim', each_yielded_value
    end
  end

  # ------------------------------------------------------------------

  def many_yields
    yield(:peanut)
    yield(:butter)
    yield(:and)
    yield(:jelly)
  end

  def test_methods_can_call_yield_many_times
    result = []
    many_yields { |item| result << item }

    enumerator = to_enum(:many_yields)
    assert_equal enumerator.to_a, result
  end

  # ------------------------------------------------------------------

  def yield_tester
    if block_given?
      yield
    else
      :no_block
    end
  end

  def test_methods_can_see_if_they_have_been_called_with_a_block
    assert_equal :with_block, yield_tester { :with_block }
    assert_equal :no_block, yield_tester
  end

  # ------------------------------------------------------------------

  def test_block_can_affect_variables_in_the_code_where_they_are_created
    value = :initial_value
    method_with_block { value = :modified_in_a_block }      # reference mutation, tread lightly!
    assert :modified_in_a_block == value
  end

  def test_blocks_can_be_assigned_to_variables_and_called_explicitly
    add_one = lambda { |n| n + 1 }
    v = 10

    retval = add_one.yield(v)
    assert_equal retval, add_one.call(v)

    # Alternative calling syntax
    assert_equal add_one.[](v), add_one[v]
  end

  def test_stand_alone_blocks_can_be_passed_to_methods_expecting_blocks
    make_upper = lambda { |n| n.upcase }
    result = method_with_block_arguments(&make_upper)
    assert_equal 'mij'.upcase.reverse, result
  end

  # ------------------------------------------------------------------

  def method_with_explicit_block(&block)
    block.call(10)
  end

  def test_methods_can_take_an_explicit_block_argument
    assert_equal 10 * 2, method_with_explicit_block { |n| n * 2 }

    add_one = lambda { |n| n + 1 }
    assert_equal 10 + 1, method_with_explicit_block(&add_one)
  end

end
