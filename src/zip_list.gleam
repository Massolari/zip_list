/// A ZipList is a list with a cursor that can be moved forwards and backwards.
import gleam/bool
import gleam/list

pub opaque type ZipList(a) {
  ZipList(previous: List(a), current: a, next: List(a))
}

// Constructors

/// Create a new ZipList
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// current(numbers)
/// // => 3
/// ```
pub fn new(
  previous previous: List(a),
  current current: a,
  next next: List(a),
) -> ZipList(a) {
  ZipList(previous, current, next)
}

/// Create a new ZipList with a single element
///
/// ## Examples
/// ```gleam
/// singleton(1) == new([], 1, [])
/// ```
pub fn singleton(current: a) -> ZipList(a) {
  ZipList(previous: [], current: current, next: [])
}

/// Create a new ZipList from a list
/// Returns `Error(Nil)` if the list is empty
///
/// ## Examples
/// ```gleam
/// from_list([1, 2, 3, 4, 5]) == Ok(new([], 1, [2, 3, 4, 5]))
/// from_list([]) == Error(Nil)
/// ```
pub fn from_list(list: List(a)) -> Result(ZipList(a), Nil) {
  case list {
    [] -> Error(Nil)
    [head, ..tail] -> Ok(ZipList(previous: [], current: head, next: tail))
  }
}

/// Create a new ZipList from a list, setting the current element to the first element that satisfies the predicate///
/// ## Examples
/// ```gleam
/// from_list_by([1, 2, 3, 4, 5], fn(x) { x == 3 }) == Ok(new([1, 2], 3, [4, 5]))
/// from_list_by([1, 2, 3, 4, 5], fn(x) { x == 6 }) == Error(Nil)
/// ```
pub fn from_list_by(
  list: List(a),
  predicate: fn(a) -> Bool,
) -> Result(ZipList(a), Nil) {
  from_list_by_helper([], predicate, list)
}

fn from_list_by_helper(
  previous: List(a),
  predicate: fn(a) -> Bool,
  remaining: List(a),
) -> Result(ZipList(a), Nil) {
  case remaining {
    [] -> Error(Nil)
    [head, ..tail] ->
      case predicate(head) {
        True -> Ok(ZipList(previous: previous, current: head, next: tail))
        False ->
          from_list_by_helper(list.append(previous, [head]), predicate, tail)
      }
  }
}

// Transformations

/// Convert a ZipList to a list
///
/// ## Examples
/// ```gleam
/// to_list(new([1, 2], 3, [4, 5]))
/// // => [1, 2, 3, 4, 5]
/// ```
pub fn to_list(zip_list: ZipList(a)) -> List(a) {
  list.append(zip_list.previous, [zip_list.current, ..zip_list.next])
}

// Cursor operations

/// Move the cursor N elements backwards
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// backwards(numbers, 2) == new([], 1, [2, 3, 4, 5])
/// ```
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// backwards(numbers, 5) == new([], 1, [2, 3, 4, 5])
/// ```
pub fn backwards(zip_list: ZipList(a), times: Int) -> ZipList(a) {
  use <- bool.guard(when: zip_list.previous == [], return: zip_list)

  case times {
    0 -> zip_list
    _ -> backwards(previous(zip_list), times - 1)
  }
}

/// Move the cursor to the first element
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// first(numbers) == new([], 1, [2, 3, 4, 5])
/// ```
/// ```gleam
/// let numbers = new([], 1, [2, 3, 4, 5])
/// first(numbers) == new([], 1, [2, 3, 4, 5])
/// ```
pub fn first(zip_list: ZipList(a)) -> ZipList(a) {
  case zip_list.previous {
    [] -> zip_list
    [head, ..tail] ->
      ZipList(
        previous: [],
        current: head,
        next: list.append(tail, [zip_list.current, ..zip_list.next]),
      )
  }
}

/// Move the cursor N elements forward
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// forward(numbers, 2) == new([1, 2, 3, 4], 5, [])
/// ```
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// forward(numbers, 5) == new([1, 2, 3, 4, 5], 6, [])
/// ```
pub fn forward(zip_list: ZipList(a), times: Int) -> ZipList(a) {
  use <- bool.guard(when: zip_list.next == [], return: zip_list)

  case times {
    0 -> zip_list
    _ -> forward(next(zip_list), times - 1)
  }
}

/// Move the cursor to the Nth element
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// jump(numbers, 1) == new([1], 2, [3, 4, 5])
/// ```
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// jump(numbers, 5) == new([1, 2, 3, 4], 5, [])
/// ```
pub fn jump(zip_list: ZipList(a), index: Int) -> ZipList(a) {
  let #(first, second) =
    zip_list
    |> to_list
    |> list.split(index)

  let #(previous, current, next) = case list.reverse(first), second {
    [], [] -> #(zip_list.previous, zip_list.current, zip_list.next)
    _, [head, ..tail] -> #(first, head, tail)
    [head, ..tail], [] -> #(list.reverse(tail), head, second)
  }

  ZipList(previous: previous, current: current, next: next)
}

/// Move the cursor to the last element
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// last(numbers) == new([1, 2, 3, 4], 5, [])
/// ```
/// ```gleam
/// let numbers = new([1, 2, 3, 4], 5, [])
/// last(numbers) == new([1, 2, 3, 4], 5, [])
/// ```
pub fn last(zip_list: ZipList(a)) -> ZipList(a) {
  case list.reverse(zip_list.next) {
    [] -> zip_list
    [head, ..tail] ->
      ZipList(
        previous: list.append(zip_list.previous, [
          zip_list.current,
          ..list.reverse(tail)
        ]),
        current: head,
        next: [],
      )
  }
}

/// Move the cursor to the next element
/// Returns the same ZipList if there is no next element
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// next(numbers) == new([1, 2, 3], 4, [5])
/// ```
/// ```gleam
/// let numbers = new([1, 2, 3, 4, 5], 6, [])
/// next(numbers) == new([1, 2, 3, 4, 5], 6, [])
/// ```
pub fn next(zip_list: ZipList(a)) -> ZipList(a) {
  case next_try(zip_list) {
    Ok(new_zip_list) -> new_zip_list
    Error(_) -> zip_list
  }
}

/// Move the cursor to the next element
/// Returns `Error(Nil)` if there is no next element
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// next_try(numbers) == Ok(new([1, 2, 3], 4, [5]))
/// ```
/// ```gleam
/// let numbers = new([1, 2, 3, 4, 5], 6, [])
/// next_try(numbers) == Error(Nil)
/// ```
pub fn next_try(zip_list: ZipList(a)) -> Result(ZipList(a), Nil) {
  case zip_list.next {
    [] -> Error(Nil)
    [head, ..tail] ->
      Ok(ZipList(
        previous: list.append(zip_list.previous, [zip_list.current]),
        current: head,
        next: tail,
      ))
  }
}

/// Move the cursor to the next element, wrapping around to the first element if there is no next element
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// next_wrap(numbers) == new([1, 2, 3], 4, [5])
/// ```
/// ```gleam
/// let numbers = new([1, 2, 3, 4, 5], 6, [])
/// next_wrap(numbers) == new([], 1, [2, 3, 4, 5, 6])
/// ```
pub fn next_wrap(zip_list: ZipList(a)) -> ZipList(a) {
  case next_try(zip_list) {
    Ok(new_zip_list) -> new_zip_list
    Error(_) -> first(zip_list)
  }
}

/// Move the cursor to the previous element
/// Returns the same ZipList if there is no previous element
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// previous(numbers) == new([1], 2, [3, 4, 5])
/// ```
/// ```gleam
/// let numbers = new([], 1, [2, 3, 4, 5])
/// previous(numbers) == new([], 1, [2, 3, 4, 5])
/// ```
pub fn previous(zip_list: ZipList(a)) -> ZipList(a) {
  case previous_try(zip_list) {
    Ok(new_zip_list) -> new_zip_list
    Error(_) -> zip_list
  }
}

/// Move the cursor to the previous element
/// Returns `Error(Nil)` if there is no previous element
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// previous_try(numbers) == Ok(new([1], 2, [3, 4, 5]))
/// ```
/// ```gleam
/// let numbers = new([], 1, [2, 3, 4, 5])
/// previous_try(numbers) == Error(Nil)
/// ```
pub fn previous_try(zip_list: ZipList(a)) -> Result(ZipList(a), Nil) {
  let previous_reversed = list.reverse(zip_list.previous)

  case previous_reversed {
    [] -> Error(Nil)
    [head, ..tail] ->
      Ok(
        ZipList(previous: list.reverse(tail), current: head, next: [
          zip_list.current,
          ..zip_list.next
        ]),
      )
  }
}

/// Move the cursor to the previous element, wrapping around to the last element if there is no previous element
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// previous_wrap(numbers) == new([1, 2, 3], 4, [5])
/// ```
/// ```gleam
/// let numbers = new([], 1, [2, 3, 4, 5])
/// previous_wrap(numbers) == new([1, 2, 3, 4], 5, [])
/// ```
pub fn previous_wrap(zip_list: ZipList(a)) -> ZipList(a) {
  case previous_try(zip_list) {
    Ok(new_zip_list) -> new_zip_list
    Error(_) -> last(zip_list)
  }
}

// Modification

/// Append a list to the next elements of the ZipList
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// append_next(numbers, [6, 7]) == new([1, 2], 3, [4, 5, 6, 7])
/// ```
pub fn append_next(zip_list: ZipList(a), next: List(a)) -> ZipList(a) {
  ZipList(
    previous: zip_list.previous,
    current: zip_list.current,
    next: list.append(zip_list.next, next),
  )
}

/// Append a list to the previous elements of the ZipList
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// append_previous(numbers, [-1, 0]) == new([1, 2, -1, 0], 3, [4, 5])
/// ```
pub fn append_previous(zip_list: ZipList(a), previous: List(a)) -> ZipList(a) {
  ZipList(
    previous: list.append(zip_list.previous, previous),
    current: zip_list.current,
    next: zip_list.next,
  )
}

/// Map a function over the elements of the ZipList, passing a flag indicating if the element is the current element
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// current_map(numbers, fn(x, is_current) {
///   case is_current {
///     True -> x * 10
///     False -> x * 2
///   }
/// }) == new([2, 4], 30, [8, 10])
/// ```
pub fn current_map(zip_list: ZipList(a), f: fn(a, Bool) -> b) -> ZipList(b) {
  let f_with_flag = fn(element) { f(element, False) }

  ZipList(
    previous: list.map(zip_list.previous, f_with_flag),
    current: f(zip_list.current, True),
    next: list.map(zip_list.next, f_with_flag),
  )
}

/// Filter the elements of the ZipList
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// filter(numbers, int.is_even) == new([2], 4, [])
/// ```
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// filter(numbers, int.is_odd) == new([1], 3, [5])
/// ```
/// ```gleam
/// let numbers = new([], 1, [])
/// filter(numbers, int.is_even) == Error(Nil)
/// ```
pub fn filter(zip_list: ZipList(a), f: fn(a) -> Bool) -> Result(ZipList(a), Nil) {
  let filtered_previous = list.filter(zip_list.previous, f)
  let filtered_next = list.filter(zip_list.next, f)
  let filtered_current = case f(zip_list.current) {
    True -> Ok(zip_list.current)
    False -> Error(Nil)
  }

  case filtered_current {
    Ok(current) ->
      Ok(ZipList(
        previous: filtered_previous,
        current: current,
        next: filtered_next,
      ))
    Error(_) ->
      case list.reverse(filtered_previous), filtered_next {
        [], [] -> Error(Nil)
        _, [head, ..tail] ->
          Ok(ZipList(previous: filtered_previous, current: head, next: tail))
        [head, ..tail], [] ->
          Ok(ZipList(
            previous: list.reverse(tail),
            current: head,
            next: filtered_next,
          ))
      }
  }
}

/// Map a function over the elements of the ZipList, passing the index of each element
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// index_map(numbers, fn(x, i) { x * i }) == new([0, 2], 6, [12, 20])
/// ```
pub fn index_map(zip_list: ZipList(a), f: fn(a, Int) -> b) -> ZipList(b) {
  let previous_length = list.length(zip_list.previous)

  ZipList(
    previous: list.index_map(zip_list.previous, f),
    current: f(zip_list.current, previous_length),
    next: list.index_map(zip_list.next, fn(element, index) {
      f(element, index + previous_length + 1)
    }),
  )
}

/// Map a function over the elements of the ZipList
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// map(numbers, fn(x) { x * 2 }) == new([2, 4], 6, [8, 10])
/// ```
pub fn map(zip_list: ZipList(a), f: fn(a) -> b) -> ZipList(b) {
  ZipList(
    previous: list.map(zip_list.previous, f),
    current: f(zip_list.current),
    next: list.map(zip_list.next, f),
  )
}

/// Prepend a list to the next elements of the ZipList
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// prepend_next(numbers, [6, 7]) == new([1, 2], 3, [6, 7, 4, 5])
/// ```
pub fn prepend_next(zip_list: ZipList(a), next: List(a)) -> ZipList(a) {
  ZipList(
    previous: zip_list.previous,
    current: zip_list.current,
    next: list.append(next, zip_list.next),
  )
}

/// Prepend a list to the previous elements of the ZipList
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// prepend_previous(numbers, [-1, 0]) == new([-1, 0, 1, 2], 3, [4, 5])
/// ```
pub fn prepend_previous(zip_list: ZipList(a), previous: List(a)) -> ZipList(a) {
  ZipList(
    previous: list.append(previous, zip_list.previous),
    current: zip_list.current,
    next: zip_list.next,
  )
}

/// Remove the current element from the ZipList
/// The cursor is moved to the next element if there is one, otherwise to the previous element
/// Returns the same ZipList if there is no next or previous element
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// remove(numbers) == new([1, 2], 4, [5])
/// ```
/// ```gleam
/// let numbers = new([1, 2], 3, [])
/// remove(numbers) == new([1], 2, [])
/// ```
/// ```gleam
/// let numbers = new([], 1, [])
/// remove(numbers) == new([], 1, [])
/// ```
pub fn remove(zip_list: ZipList(a)) -> ZipList(a) {
  case remove_try(zip_list) {
    Ok(new_zip_list) -> new_zip_list
    Error(_) -> zip_list
  }
}

/// Remove the current element from the ZipList
/// The cursor is moved to the previous element if there is one, otherwise to the next element
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// remove_backwards(numbers) == new([1], 2, [3, 4, 5])
/// ```
/// ```gleam
/// let numbers = new([], 1, [2, 3])
/// remove_backwards(numbers) == new([], 2, [3])
/// ```
/// ```gleam
/// let numbers = new([], 1, [])
/// remove(numbers) == new([], 1, [])
/// ```
pub fn remove_backwards(zip_list: ZipList(a)) -> ZipList(a) {
  case remove_try(zip_list) {
    Ok(new_zip_list) -> previous(new_zip_list)
    Error(_) -> zip_list
  }
}

/// Remove the current element from the ZipList
/// The cursor is moved to the next element if there is one, otherwise to the previous element
/// Returns `Error(Nil)` if there is no next or previous element
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// remove_try(numbers) == Ok(new([1, 2], 4, [5]))
/// ```
/// ```gleam
/// let numbers = new([1, 2], 3, [])
/// remove_try(numbers) == Ok(new([1], 2, []))
/// ```
/// ```gleam
/// let numbers = new([], 1, [])
/// remove_try(numbers) == Error(Nil)
/// ```
pub fn remove_try(zip_list: ZipList(a)) -> Result(ZipList(a), Nil) {
  case zip_list.next, list.reverse(zip_list.previous) {
    [], [] -> Error(Nil)
    [head, ..tail], _ -> Ok(ZipList(..zip_list, current: head, next: tail))
    _, [head, ..tail] ->
      Ok(ZipList(..zip_list, current: head, previous: list.reverse(tail)))
  }
}

/// Replace the current element of the ZipList
///
/// ## Examples
/// ```gleam
/// let numbers = new([1, 2], 3, [4, 5])
/// replace(numbers, 6) == new([1, 2], 6, [4, 5])
/// ```
pub fn replace(zip_list: ZipList(a), new_current: a) -> ZipList(a) {
  ZipList(..zip_list, current: new_current)
}

// Acessors

/// Get the next elements of the ZipList
///
/// ## Examples
/// ```gleam
/// new([1, 2], 3, [4, 5])
/// |> get_all_next
/// // => [4, 5]
/// ```
pub fn get_all_next(zip_list: ZipList(a)) -> List(a) {
  zip_list.next
}

/// Get the previous elements of the ZipList
///
/// ## Examples
/// ```gleam
/// new([1, 2], 3, [4, 5])
/// |> get_all_previous
/// // => [1, 2]
/// ```
pub fn get_all_previous(zip_list: ZipList(a)) -> List(a) {
  zip_list.previous
}

/// Get the current element of the ZipList
///
/// ## Examples
/// ```gleam
/// new([1, 2], 3, [4, 5])
/// |> current
/// // => 3
/// ```
pub fn current(zip_list: ZipList(a)) -> a {
  zip_list.current
}

/// Get the index of the current element in the ZipList
///
/// ## Examples
/// ```gleam
/// new([1, 2], 3, [4, 5])
/// |> index
/// // => 2
/// ```
/// ```gleam
/// new([], 3, [4, 5])
/// |> index
/// // => 0
/// ```
pub fn index(zip_list: ZipList(a)) -> Int {
  list.length(zip_list.previous)
}

/// Get the next element of the ZipList
/// Returns `Error(Nil)` if there is no next element
///
/// ## Examples
/// ```gleam
/// new([1, 2], 3, [4, 5])
/// |> get_next
/// // => Ok(4)
/// ```
/// ```gleam
/// new([1, 2, 3], 4, [])
/// |> get_next
/// // => Error(Nil)
/// ```
pub fn get_next(zip_list: ZipList(a)) -> Result(a, Nil) {
  case zip_list.next {
    [] -> Error(Nil)
    [head, ..] -> Ok(head)
  }
}

/// Get the previous element of the ZipList
/// Returns `Error(Nil)` if there is no previous element
///
/// ## Examples
/// ```gleam
/// new([1, 2], 3, [4, 5])
/// |> get_previous
/// // => Ok(2)
/// ```
/// ```gleam
/// new([], 3, [4, 5])
/// |> get_previous
/// // => Error(Nil)
/// ```
pub fn get_previous(zip_list: ZipList(a)) -> Result(a, Nil) {
  case list.reverse(zip_list.previous) {
    [] -> Error(Nil)
    [head, ..] -> Ok(head)
  }
}

/// Check if the current element is the first element of the ZipList
///
/// ## Examples
/// ```gleam
/// new([1, 2], 3, [4, 5])
/// |> is_first
/// // => False
/// ```
/// ```gleam
/// new([], 3, [4, 5])
/// |> is_first
/// // => True
/// ```
pub fn is_first(zip_list: ZipList(a)) -> Bool {
  list.is_empty(zip_list.previous)
}

/// Check if the current element is the last element of the ZipList
///
/// ## Examples
/// ```gleam
/// new([1, 2], 3, [4, 5])
/// |> is_last
/// // => False
/// ```
/// ```gleam
/// new([1, 2], 3, [])
/// |> is_last
/// // => True
/// ```
pub fn is_last(zip_list: ZipList(a)) -> Bool {
  list.is_empty(zip_list.next)
}

/// Get the length of the ZipList
///
/// ## Examples
/// ```gleam
/// new([1, 2], 3, [4, 5])
/// |> length
/// // => 5
/// ```
pub fn length(zip_list: ZipList(a)) -> Int {
  list.length(zip_list.previous) + 1 + list.length(zip_list.next)
}
