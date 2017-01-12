require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutIteration < Neo::Koan

  # -- An Aside ------------------------------------------------------
  # Ruby 1.8 stores names as strings. Ruby 1.9 and later stores names
  # as symbols. So we use a version dependent method "as_name" to
  # convert to the right format in the koans. We will use "as_name"
  # whenever comparing to lists of methods.

  in_ruby_version("1.8") do
    def as_name(name)
      name.to_s
    end
  end

  in_ruby_version("1.9", "2") do
    def as_name(name)
      name.to_sym
    end
  end

  # Ok, now back to the Koans.
  # -------------------------------------------------------------------

  def test_each_is_a_method_on_arrays
    assert_equal true, [].methods.include?(as_name(:each))
  end

  def test_iterating_with_each
    array = [1, 2, 3]
    sum = 0
    array.each do |item|
      sum += item
    end
    assert_equal array.reduce(:+), sum
  end

  def test_each_can_use_curly_brace_blocks_too
    array = [1, 2, 3]
    sum = 0
    array.each { |item| sum += item }
    assert_equal array.inject(0) { |retval, el| retval + el }, sum
  end

  def test_break_works_with_each_style_iterations
    array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    sum = 0
    array.each do |item|
      break if item > 3
      sum += item
    end
    assert_equal array.freeze[0..array.find_index(3)].reduce(:+), sum
  end

  def test_collect_transforms_elements_of_an_array
    array = [1, 2, 3]
    new_array = array.collect { |item| item + 10 }
    assert_equal array.map { |i| i+10 }, new_array

    # NOTE: 'map' is another name for the 'collect' operation
    another_array = array.map { |item| item + 10 }
    assert_equal new_array, another_array
  end

  def test_select_selects_certain_items_from_an_array
    array = [1, 2, 3, 4, 5, 6].shuffle.freeze

    even_numbers = array \
      .select { |item| (item % 2) == 0 }

    a  = array \
      .select \
      .each_with_index { |el, idx| el % 2 == 0 }

    b = array \
      .each_with_index \
      .select { |v, i| v % 2 == 0 } \
      .map { |v, _| v }

    assert_val = a == b && b || []
    assert_equal assert_val, even_numbers

    # NOTE: 'find_all' is another name for the 'select' operation
    more_even_numbers = array.find_all { |item| (item % 2) == 0 }
    assert_equal even_numbers, more_even_numbers
  end

  def test_find_locates_the_first_element_matching_a_criteria
    array = ["Jim", "Bill", "Clarence", "Doug", "Eli"]

    assert_equal array[2], array.find { |item| item.size > 4 }
  end

  def test_inject_will_blow_your_mind
    l = [2, 3, 4]
    result = l.inject(0) { |sum, item| sum + item }
    assert_equal l.reduce(&:+), result

    result2 = l.inject(1) { |product, item| product * item }
    assert_equal l.reduce(&:*), result2

    # Extra Credit:
    # Describe in your own words what inject does.
  end

  def test_all_iteration_methods_work_on_any_collection_not_just_arrays
    # Ranges act like a collection
    factor = 10
    result = (1..3).map { |item| item + factor }
    assert_equal Range.new(1+factor, 3+factor).to_a, result

    # Files act like a collection of lines
    l = proc { |line| line.strip.upcase }
    File.open("example_file.txt") do |file|
      upcase_lines = file.map &l
      file.seek 0
      own = file.map(&:strip).map(&:upcase)
      assert_equal own, upcase_lines
    end

    # NOTE: You can create your own collections that work with each,
    # map, select, etc.
  end

  # Bonus Question:  In the previous koan, we saw the construct:
  #
  #   File.open(filename) do |file|
  #     # code to read 'file'
  #   end
  #
  # Why did we do it that way instead of the following?
  #
  #   file = File.open(filename)
  #   # code to read 'file'
  # auto-closing it.
  # When you get to the "AboutSandwichCode" koan, recheck your answer.

end
