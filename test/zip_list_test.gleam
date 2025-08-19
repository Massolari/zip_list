import birdie
import gleam/int
import gleam/string
import gleeunit
import zip_list

pub fn main() {
  gleeunit.main()
}

pub fn new_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> string.inspect
  |> birdie.snap("new")
}

pub fn singleton_test() {
  zip_list.singleton(1)
  |> string.inspect
  |> birdie.snap("singleton")
}

pub fn from_list_test() {
  zip_list.from_list([1, 2, 3])
  |> string.inspect
  |> birdie.snap("from_list")
}

pub fn from_list_empty_test() {
  zip_list.from_list([])
  |> string.inspect
  |> birdie.snap("from_list_empty")
}

pub fn from_list_by_test() {
  zip_list.from_list_by([1, 2, 3, 4], int.is_even)
  |> string.inspect
  |> birdie.snap("from_list_by")
}

pub fn from_list_by_error_test() {
  zip_list.from_list_by([1, 3], int.is_even)
  |> string.inspect
  |> birdie.snap("from_list_by_error")
}

pub fn to_list_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.to_list
  |> string.inspect
  |> birdie.snap("to_list")
}

pub fn backwards_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.backwards(2)
  |> string.inspect
  |> birdie.snap("backwards")
}

pub fn first_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.first
  |> string.inspect
  |> birdie.snap("first")
}

pub fn first_from_first_test() {
  zip_list.new([], 1, [2, 3, 4, 5])
  |> zip_list.first
  |> string.inspect
  |> birdie.snap("first_from_first")
}

pub fn forward_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.forward(2)
  |> string.inspect
  |> birdie.snap("forward")
}

pub fn jump_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.jump(1)
  |> string.inspect
  |> birdie.snap("jump")
}

pub fn jump_overflow_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.jump(10)
  |> string.inspect
  |> birdie.snap("jump_overflow")
}

pub fn last_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.last
  |> string.inspect
  |> birdie.snap("last")
}

pub fn last_from_last_test() {
  zip_list.new([1, 2, 3, 4], 5, [])
  |> zip_list.last
  |> string.inspect
  |> birdie.snap("last_from_last")
}

pub fn next_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.next
  |> string.inspect
  |> birdie.snap("next")
}

pub fn next_try_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.next_try
  |> string.inspect
  |> birdie.snap("next_try")
}

pub fn next_try_overflow_test() {
  zip_list.new([1, 2, 3], 4, [])
  |> zip_list.next_try
  |> string.inspect
  |> birdie.snap("next_try_overflow")
}

pub fn next_wrap_test() {
  zip_list.new([1, 2, 3], 4, [])
  |> zip_list.next_wrap
  |> string.inspect
  |> birdie.snap("next_wrap")
}

pub fn previous_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.previous
  |> string.inspect
  |> birdie.snap("previous")
}

pub fn previous_try_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.previous_try
  |> string.inspect
  |> birdie.snap("previous_try")
}

pub fn previous_try_overflow_test() {
  zip_list.new([], 4, [5, 6, 7])
  |> zip_list.previous_try
  |> string.inspect
  |> birdie.snap("previous_try_overflow")
}

pub fn previous_wrap_test() {
  zip_list.new([], 4, [5, 6, 7])
  |> zip_list.previous_wrap
  |> string.inspect
  |> birdie.snap("previous_wrap")
}

pub fn append_next_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.append_next([8, 9])
  |> string.inspect
  |> birdie.snap("append_next")
}

pub fn append_previous_test() {
  zip_list.new([-1, 0, 1], 4, [5, 6, 7])
  |> zip_list.append_previous([2, 3])
  |> string.inspect
  |> birdie.snap("append_previous")
}

pub fn current_map_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.current_map(fn(x, is_current) {
    case is_current {
      True -> x * 10
      False -> x * 2
    }
  })
  |> string.inspect
  |> birdie.snap("current_map")
}

pub fn current_map_different_type_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.current_map(fn(x, is_current) {
    case is_current {
      True -> "is_current"
      False -> int.to_string(x)
    }
  })
  |> string.inspect
  |> birdie.snap("current_map_different_type")
}

pub fn filter_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.filter(int.is_odd)
  |> string.inspect
  |> birdie.snap("filter")
}

pub fn index_map_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.index_map(fn(x, i) { x + i })
  |> string.inspect
  |> birdie.snap("index_map")
}

pub fn map_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.map(fn(x) { x * 2 })
  |> string.inspect
  |> birdie.snap("map")
}

pub fn prepend_next_test() {
  zip_list.new([1, 2, 3], 4, [7, 8, 9])
  |> zip_list.prepend_next([5, 6])
  |> string.inspect
  |> birdie.snap("prepend_next")
}

pub fn prepend_previous_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.prepend_previous([-1, 0])
  |> string.inspect
  |> birdie.snap("prepend_previous")
}

pub fn remove_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.remove
  |> string.inspect
  |> birdie.snap("remove")
}

pub fn remove_go_previous_test() {
  zip_list.new([1, 2, 3], 4, [])
  |> zip_list.remove
  |> string.inspect
  |> birdie.snap("remove_go_previous")
}

pub fn remove_backwards_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.remove_backwards
  |> string.inspect
  |> birdie.snap("remove_backwards")
}

pub fn remove_backwards_go_next_test() {
  zip_list.new([], 4, [5, 6, 7])
  |> zip_list.remove_backwards
  |> string.inspect
  |> birdie.snap("remove_backwards_go_next")
}

pub fn remove_try_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.remove_try
  |> string.inspect
  |> birdie.snap("remove_try")
}

pub fn remove_try_error_test() {
  zip_list.new([], 4, [])
  |> zip_list.remove_try
  |> string.inspect
  |> birdie.snap("remove_try_error")
}

pub fn replace_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.replace(10)
  |> string.inspect
  |> birdie.snap("replace")
}

pub fn get_all_next_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.get_all_next
  |> string.inspect
  |> birdie.snap("get_all_next")
}

pub fn get_all_previous_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.get_all_previous
  |> string.inspect
  |> birdie.snap("get_all_previous")
}

pub fn current_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.current
  |> string.inspect
  |> birdie.snap("current")
}

pub fn index_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.index
  |> string.inspect
  |> birdie.snap("index")
}

pub fn get_next_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.get_next
  |> string.inspect
  |> birdie.snap("get_next")
}

pub fn get_next_error_test() {
  zip_list.new([1, 2, 3], 4, [])
  |> zip_list.get_next
  |> string.inspect
  |> birdie.snap("get_next_error")
}

pub fn get_previous_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.get_previous
  |> string.inspect
  |> birdie.snap("get_previous")
}

pub fn get_previous_error_test() {
  zip_list.new([], 4, [5, 6, 7])
  |> zip_list.get_previous
  |> string.inspect
  |> birdie.snap("get_previous_error")
}

pub fn is_first_false_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.is_first
  |> string.inspect
  |> birdie.snap("is_first_false")
}

pub fn is_first_true_test() {
  zip_list.new([], 4, [5, 6, 7])
  |> zip_list.is_first
  |> string.inspect
  |> birdie.snap("is_first_true")
}

pub fn is_last_false_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.is_last
  |> string.inspect
  |> birdie.snap("is_last_false")
}

pub fn is_last_true_test() {
  zip_list.new([1, 2, 3], 4, [])
  |> zip_list.is_last
  |> string.inspect
  |> birdie.snap("is_last_true")
}

pub fn length_test() {
  zip_list.new([1, 2, 3], 4, [5, 6, 7])
  |> zip_list.length
  |> string.inspect
  |> birdie.snap("length")
}
