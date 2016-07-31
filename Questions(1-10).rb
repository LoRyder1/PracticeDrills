# Write an efficient function that takes stock_prices_yesterday and returns the best profit I could have made from 1 purchase and 1 sale of 1 Apple stock yesterday.

# A greedy algorithm iterates through the problem space taking the optimal solution "so far", until it reaches the end.

# The greedy approach is only optimal if the problem has "optimal substructures," which means stitching together optimal solutions to subproblems yields an optimal solution

# Brute Force

# 1. APPLE STOCKS

def get_max_profit stock_prices_yesterday
  max_profit = 0
  stock_prices_yesterday.each_with_index do |earlier_price, earlier_time|
    for later_price in stock_prices_yesterday[earlier_time+1..-1]
      potential_profit = later_price - earlier_price
      max_profit = [max_profit, potential_profit].max
    end
  end
  return max_profit
end

# O(n^2)

def get_max_profit stock_prices_yesterday
  if stock_prices_yesterday.length < 2
    raise IndexError, 'Getting a profit requires at least two prices'
  end

  max_profit = stock_prices_yesterday[1] - stock_prices_yesterday[0]
  min_price = stock_prices_yesterday.shift

  stock_prices_yesterday.each do |current_price|
    potential_profit = current_price - min_price
    max_profit = [potential_profit, max_profit].max
    min_price = [current_price, min_price].min
  end

  return max_profit
end


# stock_prices_yesterday = [10, 7, 5, 8, 11, 9]

# p get_max_profit(stock_prices_yesterday)

# O(n) time and O(1) space. Loop once
# returns 6 (buying for $5 and selling for $11)

# 2. PRODUCT OF ALL OTHER NUMBERS

def get_products_of_all_int_except_at_index int_array
  prods_except_at_index = []

  # for each integer, we find the product of all the integers
  # before it, storing the total product so far each time

  product_so_far = 1
  i = 0
  while i < int_array.length
    prods_except_at_index[i] = product_so_far
    product_so_far *= int_array[i]
    i+=1
  end
  
  # for each integer, we find the product of all the integers after it. since each index in products already has the product of all the integers before it, now we're storing the total product of all other integers

  product_so_far = 1
  i = int_array.length - 1
  while i >= 0
    prods_except_at_index[i] *= product_so_far
    product_so_far *= int_array[i]
    i -= 1
  end
  return prods_except_at_index
end


def get_products_of_all_int_except_at_index int_array
  prods_except_at_index = []
  i = int_array.length-1
  product_so_far = 1

  0.upto(i) do |x|
    prods_except_at_index << product_so_far
    product_so_far *= int_array[x]
  end

  product_so_far = 1
  
  (i).downto(0) do |x|
    prods_except_at_index[x] *= product_so_far
    product_so_far *= int_array[x]
  end

  return prods_except_at_index
end


# p get_products_of_all_int_except_at_index [1,7,3,4]
# p get_products_of_all_int_except_at_index [2,7,3,4]
# O(n) time and O(n) space

# sorting = O(n lg n)

# 3. HIGHEST PRODUCT OF 3

def highest_product_of_3 array_of_ints
  if array_of_ints.length < 3
    raise Exception, 'Less than 3 items'
  end

  highest = [array_of_ints[0], array_of_ints[1]].max
  lowest = [array_of_ints[0], array_of_ints[1]].min

  highest_product_of_2 = array_of_ints[0] * array_of_ints[1]
  lowest_product_of_2 = array_of_ints[0] * array_of_ints[1]

  highest_product_of_three = array_of_ints[0] * array_of_ints[1] * array_of_ints[2]

  array_of_ints.each_with_index do |current, index|
    next if index < 2

    highest_product_of_three = [
      highest_product_of_three,
      current * highest_product_of_2,
      current * lowest_product_of_2
    ].max

    highest_product_of_2 = [
      highest_product_of_2,
      current * highest, 
      current * lowest
    ].max

    lowest_product_of_2 = [
      lowest_product_of_2, 
      current * highest, 
      current * lowest
    ].min

    highest = [highest, current].max

    lowest = [lowest, current].min
  end

  return highest_product_of_three

end

# Complexity:  O(n) time and O(1) additional space
# array_of_ints = [1, 10, -5, 1, -100]  # 5000
array_of_ints = [-10,-10,1,3,2]   # 300

# p highest_product_of_3 array_of_ints

# 4. MERGE MEETING TIMES

def merge_ranges meetings
  sorted_meetings = meetings.sort
  merged_meetings = [sorted_meetings.shift]

  sorted_meetings.each do |current_meeting_start, current_meeting_end|

    last_merged_meeting_start, last_merged_meeting_end = merged_meetings[-1]

    if current_meeting_start <= last_merged_meeting_end
      merged_meetings[-1] = [last_merged_meeting_start, [last_merged_meeting_end, current_meeting_end].max]
    else
      merged_meetings.push([current_meeting_start, current_meeting_end])
    end
  end

  return merged_meetings
end

range = [[0, 1],[3, 5],[4, 8],[10, 12],[9, 10]]  # [[0, 1], [3, 8], [9, 12]]
# p merge_ranges range

# Runtime of O(nlgn) if unordered space cost: O(n)

# memoize - memoization ensures that a function doesn't run for the same inputs more than once by keeping a record of the results for given inputs (usually in a hash).
# Memoization is a common strategy for dynamic programming problems, which are problems where the solution is composed of solutions to the same problem with smaller inputs. Another common strategy is going bottom-up

# bottom-up is a way to avoid recursion, saving the memory cost that recursion incurs when it builds up the call stack

# 5. MAKING CHANGE

def change_possibilities_bottom_up amount, denominations
  ways_of_doing_n_cents = [0] * (amount + 1)
  ways_of_doing_n_cents[0] = 1

  denominations.each do |coin|
    (coin..amount).each do |higher_amount|
      higher_amount_remainder = higher_amount - coin
      ways_of_doing_n_cents[higher_amount] += ways_of_doing_n_cents[higher_amount_remainder]
    end
  end

  return ways_of_doing_n_cents[amount]
end

# p change_possibilities_bottom_up 5, [1,3,5]
p change_possibilities_bottom_up 6, [1,3,5]

# Complexity: O(n*m) and O(n) additional space, where n is the amount of money and m is the number of potential denominations.

# 6. RECTANGULAR LOVE

def find_range_overlap point1, length1, point2, length2
  highest_start_point = [point1, point2].max
  lowest_end_point = [point1 + length1, point2 + length2].min
  p highest_start_point
  p lowest_end_point

  if highest_start_point >= lowest_end_point
    return [nil, nil]
  end

  overlap_length = lowest_end_point - highest_start_point

  return [highest_start_point, overlap_length]
end

def find_rectangular_overlap rect1, rect2

  x_overlap_point, overlap_width = find_range_overlap(\
    rect1['left_x'], rect1['width'], rect2['left_x'], rect2['width'])
  y_overlap_point, overlap_height = find_range_overlap(\
    rect1['bottom_y'], rect1['height'], rect2['bottom_y'], rect2['height'])

  if !overlap_width || !overlap_height
    return {
      'left_x' => nil, 'bottom_y' => nil,
      'width' => nil, 'height' => nil,
    }
  end

  return {
    'left_x' => x_overlap_point, 'bottom_y' => y_overlap_point,
    'width' => overlap_width, 'height' => overlap_height,
  }
  
end

rect1 = {
  'left_x' => 1, 'bottom_y' => 5,
  'width' => 10, 'height' => 4,
}

rect2 = {
  'left_x' => 1, 'bottom_y' => 1,
  'width' => 2, 'height' => 6,
}

# p find_rectangular_overlap rect1, rect2

# Complexity: O(1) time and O(1) space

# 7. TEMPERATURE TRACKER

class TempTracker
  attr_reader :max_temp, :min_temp, :mean, :mode, :occurrences
  def initialize
    @occurrences = [0] * (111)
    @max_occurrences = 0
    @mode = nil

    @total_numbers = 0
    @total_sum = 0.0
    @mean = nil

    @min_temp = nil
    @max_temp = nil
  end

  def insert temperature
    # for mode
    @occurrences[temperature] +=1
    if @occurrences[temperature] > @max_occurrences
      @mode = temperature
      @max_occurrences = @occurrences[temperature]
    end

    # for mean
    @total_numbers +=1
    @total_sum += temperature
    @mean = @total_sum/@total_numbers

    # for min and max
    if @max_temp.nil? or temperature > @max_temp
      @max_temp = temperature
    end
    if @min_temp.nil? or temperature < @min_temp
      @min_temp = temperature
    end
  end
end
# @hey = TempTracker.new
# p @hey.insert 45
# p @hey.insert 76
# p @hey.mean
# Complexity: O(1) time for each function, and O(1) space related input


#============ BINARY TREE ================


# A binary tree is a tree where every node has two or fewer children. The children are usually called @left adn @right
# a leaf node is a tree node with no children. It's the "end" of a path to the bottom, from the root

# depth-first traversal is a method for walking through a tree or graph where you go as deep as possible down a path before "fanning out." Your set of visited nodes will shoot out from the starting point along one path, with more single paths progressively shooting off of that one as each path hits a dead end. 

# a breadth-first traversal is a method for walking through a tree or graph where you "fan out" as much as possible before going deeper. Your set of visited nodes will seem to "ripple outwards" from the starting point.

# Is binary tree special - > balanced
class BinaryTreeNode

  attr_accessor :value
  attr_reader :left, :right

  def initialize(value)
    @value = value
    @left  = nil
    @right = nil
  end

  def insert_left(value)
    @left = BinaryTreeNode.new(value)
    return @left
  end

  def insert_right(value)
    @right = BinaryTreeNode.new(value)
    return @right
  end
end

def is_balanced tree_root
  depths = []

  nodes = []
  nodes.push([tree_root, 0])
  # p nodes

  while !nodes.empty?

    node, depth = nodes.pop

    if !node.left && !node.right

      if !depths.include? depth
        depths.push(depth)

        if (depths.length > 2) || \
          (depths.length == 2 && (depths[0] - depths[1]).abs > 1)
          return false
        end
      end

    else
      if node.left
        nodes.push([node.left, depth +1])
      end
      if node.right
        nodes.push([node.right, depth +1])
      end
    end
  end

  return true
end

# @tree = BinaryTreeNode.new(10)
# @tree.insert_left(2).insert_left(3).insert_left(2).insert_right(2)
# p @tree
# p is_balanced(@tree)
# Complexity: O(n) time and O(n) space

# is binary tree valid?

def bst_checker root

  node_and_bounds_stack = []
  node_and_bounds_stack.push([root, -Float::INFINITY, Float::INFINITY])

  while !node_and_bounds_stack.empty?
    node, lower_bound, upper_bound = node_and_bounds_stack.pop()
    if (node.value < lower_bound) || (node.value > upper_bound)
      return false
    end

    if node.left
      node_and_bounds_stack.push([node.left, lower_bound, node.lvalue])
    end
    if node.right
      node_and_bounds_stack.push([node.right, node.value, upper_bound])
    end
  end

  return true
end

# Complexity: O(n) time adn O(n) additional space

# The call stack is what a program uses to keep track of what function it's currently running and what to do with that function's return value
# Whenever you call a function, a new frame gets pushed onto the call stack, which is popped off when the function returns. As functions call other functions, the stack gets taller. In recursive functions, the stack can get as tall as the number of times the function calls itself. This can cause a problem: the stack has a limited amount of space, and if it gets too big you can get a stack overflow error. 

# FInd 2nd largest element in a binary search tree

def find_largest root_node
  current = root_node
  while current
    return current.value if !current.right
    current = current.right
  end
end

def find_second_largest root_node
  if !root_node.left && !root_node.right
    raise Exception, "Tree must have at least 2 nodes"
  end

  current = root_node

  while current

    if current.left && !current.right
      return find_largest(current.left)
    end

    if current.right && !current.right.left && !current.right.right
      return current.value
    end

    current = current.right
  end
end

# Complexity: O(h) time where h is the height of the tree, O(1) space