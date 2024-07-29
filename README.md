# zip_list

[![Package Version](https://img.shields.io/hexpm/v/zip_list)](https://hex.pm/packages/zip_list)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/zip_list/)

A `ZipList` is a list-like data structure that maintains a selected element. It provides operations to navigate through the elements, as well as to insert or remove elements.

It is useful for various implementations, such as:

- **Navigable Menus**: Create menus with options that users can navigate through.
- **Image Carousels**: Implement carousels of images that users can scroll through.

## Installation

```sh
gleam add zip_list@1
```

## Usage

```gleam
import gleam/io
import zip_list

pub fn main() {
    zip_list.new([], "Dog", ["Cat", "Bird", "Fish"])
    |> zip_list.next

    io.println("You selected: " <> zip_list.current) // => "You selected: Cat"
}
```

Further documentation can be found at <https://hexdocs.pm/zip_list>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
