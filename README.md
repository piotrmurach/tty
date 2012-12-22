# TTY
[![Build Status](https://secure.travis-ci.org/peter-murach/tty.png?branch=master)][travis] [![Code Climate](https://codeclimate.com/badge.png)][codeclimate]

[travis]: http://travis-ci.org/peter-murach/tty
[codeclimate]: https://codeclimate.com/github/peter-murach/tty

Toolbox for developing CLI clients in Ruby. This library provides a fluid interface for working with terminals.

## Features

Jump-start development of your command line app:

* Fully customizable table rendering with an easy-to-use API. (status: In Progress)
* Terminal output colorization.          (status: DONE)
* Terminal & System detection utilities. (status: In Progress)
* Text alignment/padding/indentation.    (status: In Progress)
* Shell user interface.                  (status: In Progress)
* File diffs.                            (status: TODO)
* Progress bar.                          (status: TODO)
* Configuration file management.         (status: TODO)
* Fully tested with major ruby interpreters.
* No dependencies to allow for easy gem vendoring.

## Installation

Add this line to your application's Gemfile:

    gem 'tty'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tty

## Usage

### Table

To instantiate table pass 2-dimensional array:

```ruby
  table = TTY::Table[['a1', 'a2'], ['b1', 'b2']]
  table = TTY::Table.new [['a1', 'a2'], ['b1', 'b2']]
  table = TTY::Table.new rows: [['a1', 'a2'], ['b1', 'b2']]

  table = TTY::Table.new ['h1', 'h2'], [['a1', 'a2'], ['b1', 'b2']]
  table = TTY::Table.new header: ['h1', 'h2'], rows: [['a1', 'a2'], ['b1', 'b2']]
```

Apart from `rows` and `header`, you can provide other customization options such as

```ruby
  column_widths   # enforce maximum columns widths
  column_aligns   # array of cell alignments out of :left, :center and :right
  renderer        # enforce display type out of :basic, :color, :unicode, :ascii
```

Table behaves like an Array so `<<`, `each` and familiar methods can be used

```ruby
  table << ['a1', 'a2', 'a3']
  table << ['b1', 'b2', 'b3']
  table << ['a1', 'a2'] << ['b1', 'b2']  # chain rows assignment

  table.each { |row| ... }  # iterate over rows
  table[i, j]               # return element at row(i) and column(j)
  table.row(i) { ... }      # return array for row(i)
  table.column(j) { ... }   # return array for column(j)
  table.row_size            # return row size
  table.column_size         # return column size
  table.size                # return an array of [row_size, column_size]
```

or pass your rows in a block

```ruby
  table = TTY::Table.new  do |t|
    t << ['a1', 'a2', 'a3']
    t << ['b1', 'b2', 'b3']
  end
```

And then to print do

```ruby
  table.to_s

  a1  a2  a3
  b1  b2  b3
```

To print border around data table you need to specify `renderer` type out of `basic`, `ascii`, `unicode`. For instance to output unicode border:

```
  table = TTY::Table.new ['header1', 'header2'], [['a1', 'a2'], ['b1', 'b2'], renderer: 'unicode'
  table.to_s

  ┌───────┬───────┐
  │header1│header2│
  ├───────┼───────┤
  │a1     │a2     │
  │b1     │b2     │
  └───────┴───────┘
```

### Terminal

```ruby
  term = TTY::Terminal.new
  term.width    # => 140
  term.height   # =>  60
  term.color?   # => true or false
```

To colorize your output do

```ruby
  term.color.set 'text...', :bold, :red, :on_green    # => red bold text on green background
  term.color.remove 'text...'       # strips off ansi escape sequences
  term.color.code :red              # ansi escape code for the supplied color
```

### Shell

Main responsibility is to interact with the prompt and provide convenience methods.

In order to ask question and parse answers:

```ruby
  shell  = TTY::Shell.new
  answer = shell.ask("What is your name?").read_string
```

The library provides small DSL to help with parsing and asking precise questions

```ruby
  default     # default value used if none is provided
  argument    # :required or :optional
  validate    # regex against which stdin input is checked
  valid       # a list of expected valid options
  clean       # reset question
```

You can chain question methods or configure them inside a block

```ruby
  shell.ask("What is your name?").argument(:required).default('Piotr').validate(/\w+\s\w+/).valid(['Piotr', 'Piotrek']).read_string

  shell.ask "What is your name?" do
    argument :required
    default  'Piotr'
    validate /\w+\s\w+/
    valid    ['Piotr', 'Piotrek']
  end.read_string
```

Reading answers and converting them into required types can be done with custom readers

```ruby
  read_string     # return string
  read_bool       # return true or false for strings such as "Yes", "No"
  read_int        # return integer or error if cannot convert
  read_float      # return decimal or error if cannot convert
  read_date       # return date type
  read_datetime   # return datetime type
```

### System

```ruby
  TTY::System.unix?      # => true
  TTY::System.windows?   # => false
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012 Piotr Murach. See LICENSE for further details.
