# 21. The Stolen Breakfast Drone - your company delivers breakfast via autonomous quadcopter drones. And something mysterious has happened

def find_unique_delivery_id1 delivery_ids
  ids_to_occurrences = {}

  delivery_ids.each do |delivery_id|
    if ids_to_occurrences.include? delivery_id
      ids_to_occurrences[delivery_id] += 1
    else
      ids_to_occurrences[delivery_id] = 1
    end
  end

  ids_to_occurrences.each do |delivery_id, occurences|
    return delivery_id if occurrences == 1
  end
end

# Complexity: runtime -> O(n), space -> O(n)

# Our machine stores integers as binary numbers using bits. What if we thought about this problem on the level of individual bits?

# XOR - exclusive or operator

# We XOR all the integers in the array. We start with a variable unique_delivery_id set to 0. Every time we XOR with a new ID, it will change the bits. When we XOR with the same ID again, it will cancel out the earlier change. 

def find_unique_delivery_id delivery_ids
  unique_delivery_id = 0

  delivery_ids.each do |delivery_id|
    unique_delivery_id ^= delivery_id
  end

  return unique_delivery_id
end

# Complexity: O(n) time, and O(1) space

# Signs to watch out for where bit manipulation may be useful
# 1. You want to multiply or divide by 2 (use a left shift to multiply by 2, right shift to divide by 2).
# 2. You want to "cancel out" matching numbers (use XOR).

# p find_unique_delivery_id [1,2,3,1,2]

# 22. Delete Node
# Delete a node from a singly-linked list, given only a variable pointing to that node
# A linked list is a low-level data structure. It stores an ordered list of items in individual "node" objects that have pointers to other nodes. 

# Advantages of linked lists: 

# 1. Linked lists have constant-time insertions and deletions. Arrays require O(n) time to do the same thing, because you'd have to shift all the subsequent items over 1 index
# 2. Linked lists can continue to expand as long as there is space on the machine. Arrays in low level languages must have their size specified ahead of time. 

# Disadvantages: 

# 1. To access or edit an item in a linked list, you have to take O(i) time to walk from the head of the list to the ith item (unless of course you already have a pointer directly to that item). Arrays have constant-time lookups and edits to the ith item. 

class LinkedListNode
  attr_accessor :value, :next

  def initialize value
    @value = value
    @next = nil
  end
end

a = LinkedListNode.new('A')
b = LinkedListNode.new('B')
c = LinkedListNode.new('C')

a.next = b
b.next = c

def delete_node node_to_delete
  # get the input node's next node, the one we want to skip to
  next_node = node_to_delete.next

  if next_node
    # replace the input node's value and pointer with the next
    # node's value and pointer. the previous node now effectively
    # skips over the input node
    node_to_delete.value = next_node.value
    node_to_delete.next = next_node.next
  else
    # eep, we're trying to delete the last node!
    raise "Can't delete the last node with this method!"
  end
end

# Complexity: O(1) time, and O(1) space

# p a
# p "====="
# p delete_node(b)
# p "====="
# p a

# Two potential side-effects
# 1. Any reference to the input node have now effectively been reassigned to its @next node. 
# 2. If there are pointers to the input node's original next node, those pointers now point to a "dangling" node (a node that's no longer reachable by walking down our list). 

# garbage collector - automatically frees up memory that a program is no longer using

# 23. Does this Linked List Have a Cycle?

# A singly-linked list is built with nodes, were each node has:
  # node.next and node.data

# A cycle occurs when a node's @next points back to a previous node in the list. The linked list is no longer linear with a beginning and end-instead, it cycles through a loop of nodes

def check_cycle first_node

  # start both runners at the beginning
  slow_runner = first_node
  fast_runner = first_node

  # until we hit the end of the list
  while fast_runner != nil && fast_runner.next != nil
    slow_runner = slow_runner.next
    fast_runner = fast_runner.next.next

    # case: fast_runner is about to "lap" slow_runner
    if fast_runner == slow_runner
      return true
    end
  end

  # case: fast_runner hit the end of the list
  return false
end

# Complexity
# O(n) time and O(1) space

# 24. Reverse a Linked List
# Write a function for reversing a linked list. Do it in-place.
# An in-place algorithm operates directly on its input and changes it, instead of creating and returning a new object. This is sometimes called desctructive, since the original input is "destroyed" when it's edited to create the new output. 

class LinkedListNode

  attr_accessor :value, :next

  def initialize value
    @value = value
    @next = nil
  end
end

def reverse head_of_list
  current = head_of_list
  previous = nil
  next_node = nil

  # until we have 'fallen off' the end of the list
  while current

    # copy a pointer to the next element
    # before we overwrite current.next
    next_node = current.next

    # step forward in the list
    previous = current
    current = next_node
  end

  return previous
end

# Complexity: O(n) time and O(1) space

# 25. Kth to Last Node in a Singly-Linked List
# write a function kth_to_last_node() that takes an integer k and the head_node of a singly linked list, and returns the kth to last node in the list. 

class LinkedListNode
  attr_accessor :value, :next

  def initialize value
    @value = value
    @next = nil
  end
end

a = LinkedListNode.new("Angel Food")
b = LinkedListNode.new("Bundt")
c = LinkedListNode.new("Cheese")
d = LinkedListNode.new("Devil's Food")
e = LinkedListNode.new("Eccles")

a.next = b
b.next = c
c.next = d
d.next = e


def kth_to_last_node k, head
  # STEP 1: get the length of the list
  # start at 1, not 0
  # else we'd fail to count the head node!
  list_length = 1
  current_node = head

  # traverse the whole list,
  # counting all the nodes
  while current_node.next
    current_node = current_node.next
    list_length += 1
  end

  # STEP 2: walk to the target node
  # calculate how far to go, from the head, 
  # to get to the kth to last node
  how_far_to_go = list_length - k

  current_node = head
  (0...how_far_to_go).each do |i|
    current_node = current_node.next
  end

  return current_node
end

def kth_to_last_node k, head
  left_node = head
  right_node = head

  # move right_node to the kth node
  (0...k-1).each do |x|
    right_node = right_node.next
  end

  # starting with left_node on the head, 
  # move left_node and right_node down the list, 
  # maintaining a distance of k between them,
  # until right_node hits the end of the list
  while right_node.next
    left_node = left_node.next
    right_node = right_node.next
  end

  # since left_node is k nodes behind right_node,
  # left_node is now the kth to last node!
  return left_node
end

# Complexity: O(n) time and O(1) space, where n is the length of the list

# p kth_to_last_node(2, a)
# p kth_to_last_node(3, a)
# returns the node with value "Devil's Food" (the 2nd to last node)

# 26. Reverse String in Place

def reverse string
  left_pointer = 0
  right_pointer = string.length - 1

  while left_pointer < right_pointer

    # swap characters
    string[left_pointer], string[right_pointer] =
      string[right_pointer], string[left_pointer]

    # move towards middle
    left_pointer += 1
    right_pointer -= 1
  end

  return string
end

# p reverse "hello"

# Complexity: O(n) time and O(1) space

# 27. Reverse Words

message = "find you will pain only go you recordings security the into if"

# reverse_words message
# returns 'if into the security recordings you go only pain will you find'

def reverse_words message

  # first we reverse all the characters in the entire message
  reverse_characters(message, 0, message.length-1)
  # this gives us the right word order
  # but with each word backwards

  # now we'll make the words forward again
  # by reversing each word's characters

  # we hold the index of the /start/ of the current word
  # as we look for the /end/ of the current word
  current_word_start_index = 0

  for i in 0..message.length

    # found the end of the current word!
    if (message[i] == ' ') || (i == message.length)

      reverse_characters(message, current_word_start_index, i-1)

      # if we haven't exhausted the string our 
      # next word's start is one character ahead
      current_word_start_index = i + 1
    end
  end

  return message
end

def reverse_characters message, front_index, back_index

  # walk towards the middle, from both sides
  while front_index < back_index

    # swap the front char and back char
    message[front_index], message[back_index] = 
      message[back_index], message[front_index]

    front_index += 1
    back_index -= 1
  end

  return message
end

# p reverse_words message
# Complexity: O(n) time and O(1) space

# 28. Parenthesis Matching
# Find the closing parenthesis

def get_closing_paren sentence, opening_paren_index
  open_nested_parens = 0

  (opening_paren_index + 1).upto(sentence.length - 1) do |position|
    char = sentence[position]

    if char == '('
      open_nested_parens += 1
    elsif char == ')'
      if open_nested_parens == 0
        return position
      else
        open_nested_parens -= 1
      end
    end
  end

  raise Exception, "No closing parenthesis :("
end

# Complexity: O(n) time, where n is the number of chars in the string. O(1) space

# 29. Bracket Validator

# Write a brackets validator
# A greedy algorithm iterates through the problem space taking the optimal soluiton "so far," until it reaches the end. The greedy approach is only optimal if the problem has "optimal substructure," which means stiching together optimal solutions to subproblems yields an optimal solution. 

require 'set'

def is_valid code
  openers_to_closers_hash = {
    '(' => ')',
    '{' => '}',
    '[' => ']'
  }

  openers = Set.new(openers_to_closers_hash.keys)
  closers = Set.new(openers_to_closers_hash.values)

  openers_stack = []

  for i in 0...code.length
    char = code[i]
    if openers.include? char
      openers_stack.push(char)
    elsif closers.include? char
      if openers_stack.empty?
        return false
      else
        last_unclosed_opener = openers_stack.pop

        # if this closer doesn't correspond to the most recently
        # seen unclosed opener, short-circuit, returning false
        if openers_to_closers_hash[last_unclosed_opener] != char
          return false
        end

      end
    end
  end
  return openers_stack == []
end

# p is_valid("(ahfds)")

# Complexity: O(n) time (one iteration through the string), and O(n) space

# Two common uses for stacks are:
# 1. parsing 
# 2. tree or graph traversal

# 30. Permutation Palindrome
# Write an efficient function that checks whether any permutation of an input is a palindrome(the same forwards as backwards)

# Using a hash is the most common way to get from a brute force approach to something more clever.
# Integer overflow: an integer that does not fit into the integer type

require 'set'

def has_palindrome_permutation the_string
  # track the characters we've seen an odd number of times
  unpaired_characters = Set.new

  (0...the_string.length).each do |i|
    char = the_string[i]

    if unpaired_characters.include? char
      unpaired_characters.delete(char)
    else
      unpaired_characters.add(char)
    end
  end

  # the string has a palindrome permutation if it
  # has one or zero characters without a pair
  return unpaired_characters.length <= 1
end

# Complexity: O(n) time, since, we're making one iteration through the n characters in the string