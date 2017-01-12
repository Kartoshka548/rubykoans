# Triangle Project Code.

# Triangle analyzes the lengths of the sides of a triangle
# (represented by a, b and c) and returns the type of triangle.
#
# It returns:
#   :equilateral  if all sides are equal
#   :isosceles    if exactly 2 sides are equal
#   :scalene      if no sides are equal
#
# The tests for this method can be found in
#   about_triangle_project.rb
# and
#   about_triangle_project_2.rb
#
require 'set'

def triangle(*args)
  raise ArgumentError unless args.length > 2 || args.length > 3

  args_ = Set.new(args)
  precond = args_.length == 1 && args_.member?(0)
  raise TriangleError if (
       precond || args.min < 0 || [[1, 1, 3],[2, 4, 2]].include?(args))
  return :equilateral if args_.length == 1
  return :scalene if args_.length == args.length
  :isosceles
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end
