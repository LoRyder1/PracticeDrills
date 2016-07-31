# 11. MILLION GAZILLION
# a searcg ebgube called MillionGazillion

# We can use a trie: a digital tree - an ordered tree data structure that is used to store a dynamic set or assoicative array where the keys are usually strings. Unlike a binary search tree, no node in the tree stores the key associated with that node; instead, its position in the tree defines teh key with which it is associated. All the descendants of a node have a common prefix of the string associated with that node, and the root is associated with the empty string. 

# O(26^n) complexity with alphabetical url

# 12. Find in Ordered Set

# Suppose we had an array of n integers in sorted order. How quickly could we check if a given integer is in the array?

# Because the arry is sorted, we can use binary search to find the item in O(lg n) time and O(1) additional space. 

# A brute force search would walk through the whole set, taking O(n) time in the worst case.

# We can only use binary search if the input arry is already sorted

def binary_search target, nums
  floor_index = -1
  ceiling_index = nums.length

  while floor_index +1 < ceiling_index
    distance = ceiling_index - floor_index
    half_distance = distance / 2
    guess_index = floor_index + half_distance

    guess_value = nums[guess_index]

    return true if guess_value == target

    if guess_value > target
      ceiling_index = guess_index
    else
      floor_index = guess_index
    end

  end

  return false
end

# 13. Find Rotation Point

words = [
    'ptolemaic',
    'retrograde',
    'supplant',
    'undulate',
    'xenoepist',
    'asymptote', # <-- rotates here !
    'babka',
    'banoffee',
    'engender',
    'karpatka',
    'othellolagkage'
]

# words = [
#   'k', 'v', 'a', 'b', 'c', 'd', 'e', 'g', 'i'
# ]

def find_rotation_point words
  first_word = words[0]

  floor_index = 0
  ceiling_index = words.length - 1

  while floor_index < ceiling_index
    distance = ceiling_index - floor_index
    half_distance = distance / 2
    guess_index = floor_index + half_distance

    if words[guess_index] > first_word
      floor_index = guess_index
    else
      ceiling_index = guess_index
    end

    if floor_index + 1 == ceiling_index
      return ceiling_index
    end

  end
end

# p find_rotation_point words

# Complexity: O(lg n) time and O(1) space, just like binary search
# We are assuming that our word lengths are bound by some constant - if they were bounded by a non-constant l, each of our string comparisons would cost O(l), for a total of O(l), for a total of O(l*lg n) runtime.

# Binary search teaches us that when an array is sorted or mostly sorted:

# 1. the value at a given index tells us a lot about what's to the left and what's to the right.
# 2. We don't have to look at every item in the array. By inspecting the middle item, we can 'rule out' half of the array.
# 3. We can use this approach over and over, cutting the problem in half until we have the answer. This is sometimes called 'divide and conquer'.


# 14. Inflight-entertainment

# What data structure gives us convenient constant-time lookups? - A set

require 'set'

def can_two_movies_fill_flight movie_lengths, flight_length

  movie_lengths_seen = Set.new

  movie_lengths.each do |first_movie_length|

    matching_second_movie_length = flight_length - first_movie_length
    if movie_lengths_seen.include? matching_second_movie_length
      return true
    end

    movie_lengths_seen.add(first_movie_length)
  end

  # we never found a match, so return false
  return false
end


# p can_two_movies_fill_flight [10,50], 60

# Complexity: O(n) time, and O(n) space. Note while optimizing runtime we added a bit of space cost

# 15. Compute nth Fibonacci Number

def fib_recursive n
  if n == 0 || n == 1
    return n
  end
  return fib_recursive(n-1) + fib_recursive(n-2)
end

# Runtime is O(2^n)

# Memoize - ensures that a function doesn't run for the same inputs more than once by keeping a record of the results for given inputs (usually in a hash)

class Fibber
  def initialize
    @memo = {}
  end

  def fib n
    if n < 0
      raise Exception, "Index was negative. No such thing as a negative index in a series."
    elsif n == 0 || n == 1
      return n
    end

    if @memo.include? n
      return @memo[n]
    end

    result = self.fib(n-1) + self.fib(n-2)

    # memoize
    @memo[n] = result

    return result
    
  end
end


# Runtime is O(n) space: O(n)

# p Fibber.new.fib(8)

def fib_iterative n
  if n < 0
    raise Exception, "index was negative. No such thing as a negative index in a series."

  elsif n == 0 || n == 1
    return n
  end

  prev_prev = 0
  prev = 1
  current = prev + prev_prev

  (n-1).times do 
    current = prev + prev_prev
    prev_prev = prev
    prev = current
  end

  return current

end

# Complexity: O(n) time and O(1) space

# p fib_iterative 8

# 16. The Cake Thief

cake_arrays = [[7,160],[3,90],[2,15]]
capacity = 20

# p max_duffel_bag_value(cake_arrays, capacity) # returns 555 ( 6 of the middle type of cake and 1 of the last type of cake)

# The Unbounded knapsack problem


# this solution is good and efficient

# def max_duffel_bag_value_with_capacity_1 cake_arrays
#   max_value_at_capacity_1 = 0

#   cake_arrays.each do |cake_weight, cake_value|
#     if cake_weight == 1
#       max_value_at_capacity_1 = [max_value_at_capacity_1, cake_value].max
#     end
#   end
#   return max_value_at_capacity_1  
# end


# this solution is inefficient but optimal 
def max_duffel_bag_value1 cake_arrays, weight_capacity
  # we make an array to hold the maximum possible value at every duffel bag weight capacity from 0 to weight_capacity
  # starting each index with value 0
  max_values_at_capacities = [0] * (weight_capacity + 1)

  (0..weight_capacity).each do |current_capacity|

    # set a variable to hold the max monetary value so far for current_capacity
    current_max_value = 0

    cake_arrays.each do |cake_weight, cake_value|
      # if a cake weighs 0 and has a positive value the value of our duffel bag is infinite
      if (cake_weight == 0 && cake_value != 0)
        return Float::INFINITY
      end

      # if the current cake weighs as much or less than the current weight capacity
      # it's possible taking the cake would give get a better value
      if (cake_weight <= current_capacity)

        # so we check: should we use the cake or not?
        # if we use the cake, the most kilograms we can include in addition to the cake we're adding is the current capacity minus the cake's weight. we find the max value at that integer capacity in our array max_values_at_capacities
        max_value_using_cake = cake_value + max_values_at_capacities[current_capacity - cake_weight]

        # now we see if it's worth taking the cake. how does the value with the cake compare to the current_max_value?
        current_max_value = [max_value_using_cake, current_max_value].max
      end
    end

    # add each capacity's max value to our array so we can use them when calculating all the remaining capacities
    max_values_at_capacities[current_capacity] = current_max_value
  end

  return max_values_at_capacities[weight_capacity]
end

def max_duffel_bag_value cake_arrays, weight_capacity
  max_values_at_capacities = [0] * (weight_capacity + 1)
  (0..weight_capacity).each do |current_capacity|
    current_max_value = 0
    cake_arrays.each do |cake_weight, cake_value|
      return Float::INFINITY if (cake_weight.zero? && cake_value != 0)
      
      if (cake_weight <= current_capacity)
        mx_values = max_values_at_capacities[current_capacity - cake_weight]
        max_value_using_cake = cake_value + mx_values
        current_max_value = [max_value_using_cake, current_max_value].max
      end
    end
    max_values_at_capacities[current_capacity] = current_max_value
  end
  return max_values_at_capacities[weight_capacity]
end

# Complexity: O(n*k) time and O(k) space, where n is the number of types of cake and k is the capacity of the duffel bag. 

ck_values = [[3,40],[5,70]]

p max_duffel_bag_value ck_values, 8  # 110
p max_duffel_bag_value ck_values, 9  # 120

# ck_values1 = [[7,160],[3,90],[2,15]]
# p max_duffel_bag_value ck_values1, 8   # 120

# 17. JavaScript Scope

# Hoisting. In Javascript, variable declarations are "hoisted" to the top of the current scope. Variable assignments, however, are not. 
# Remembe: when you declare a variable in JavaScript (using "var"), that variable declaration is "hoisted" to the top of the current scope-meaning the top fo the current function or the top of the script if the variable isn't in a function. Hoisting can cause unexpected behavior, so a good way to keep things clear is to always declare your variables at the top of the scope.

# 18. What's wrong with this JavaScript?
`<button id="btn-0">Button1!</button>
<button id="btn-1">Button2!</button>
"btn-2"

<script type="text/javascript">
  var prizes = ['A Unicorn!', 'A Hug!', 'Fresh Laundry!'];
  for (var btnNum = 0; btnNum < prizes.length; btnNum++) {
    # for each of our buttons, when the user clicks it...
    document.getElementById('btn', btnNum).onclick = function() {
      # tell her what she's won!
      alert(prizes[btnNum]);
    };
  }
</script>`

# The anonymous function we're assigning to the buttons' onclicks has access to variables in the scope outside of it (this is called a closure). In this case, it has access to btnNum.
# WHen a function accesses a variable outside its scope, it accesses that variable , not a frozen copy.
# Why undefined? - In JavaScript, accessing a nonexistant index in an array returns undefined, Ruby return nil. 
# Solve by wrapping anonymous function in another anonymous funciton that takes btnNum as an argument

# btnNum is a number, which is a primitive type in JavaScript.
# Primitives are 'simple' data types (string, number, boolean, null, and undefined in JavaScript)
# Everything else is an object in JavaScript (funcitons, arrays, Date() values, etc)

# Arguments Passed by Value vs Arguments Passed by Reference
# One important property of primitives in JS is that when they are passed as arguments to a function, they are copied ("passed by value")
# In contrast, when a function takes an object, it actually takes a reference to that very object. So changes you make to the object in the function persist after the function is done running. This is sometimes called a side effect. 

# 19. Queue Two Stacks

# A Queue is like a line at the movie theater. It's "first in, first, out", (FIFO), which means that the item that was put in the queue longest ago is the first item that comes out. "First come, first served."
# Queue's have two main methods: 1. enqueue(): adds an item 2. dequeue(): removes and returns the next item in line
# They can also include some utility methods: 1. peek(): returns the item at the front fo the queue, without removing it. 2. is_empty(): returns True if the queue is empty, False otherwise. with 2 stacks. Your queue should have an enqueue and a dequeue function and it should be "first in first out" (FIFO). 
# A stack is like a stack of plates. It's 'last in, first out' (LIFO), which means the item that was put in the stack most recently is the first item that comes out.

# Solution use an instack and outstack

# accounting method: can be used for computing time complexity for things like "the cost of m operations on this data structure." In the accounting method, you simply look at the time cost incurred by each item passing through the system instead of the time cost of each operation. 
# = counting the time cost per item instead of per enqueue of dequeue
# Each of these 4 pushes and pops is O(1) time. So our total cost per item is O(1). Our m enqueue and dequeue operations put m or fewer item into the system, giving a total runtime of O(m). 

#20.  Largest Stack - you want to be able to access the largest element in a stack

class Stack

  # initialize an empty array
  def initialize
    @items = []
  end

  # push a new item to the last index
  def push(item)
    @items.push(item)
  end

  # remove the last item
  def pop()

    # if the stack is empty, return nil
    # (it would also be reasonable to throw an exception)
    return nil if @items.empty?

    return @items.pop()
    
  end

  # see what the last iem is 
  def peek()
    return nil if @items.empty?
    return @items[-1]
  end
end

class MaxStack

  def initialize
    @stack = Stack.new
    @maxs_stack = Stack.new
  end

  # Add a new item to the top of our stack. If the item is greater than or equal to the last item in maxs_stack, it's the new max! So we'll add it to maxs_stack.
  def push item
    @stack.push item
    if !@maxs_stack.peek || item >= @maxs_stack.peek
      @maxs_stack.push(item)
    end
  end

  # Remove and return the top item from our stack. If if equals the top item in maxs_stack, they must have been pushed in together. So we'll pop it out of maxs_stack too.

  def pop
    item = @stack.pop
    if item == @maxs_stack.peek
      @maxs_stack.pop
    end
    return item
  end

  # The last item in maxs_stack is the max item in our stack
  def get_max
    return @maxs_stack.peek
  end
end

# Complexity: O(1) time for push, pop, and get_max. O(m) additional space, where m is the number of operation performed on the stack. Trade space efficiency for time efficiency. 
# We are spending time on push and pop so we can save time on get_max. We have chosen to optimize for the time cost of calls to get_max(). If we expected to e running push and pop frequently and running get_max rarely, we could have optimized for faster push and pop funciton. Sometimes the first step in algorithm design is deciding what we're optimizing for. Start by considering tthe expected characteristics of the input. 


