# TTY
[![Gem Version](https://badge.fury.io/rb/tty.png)][gem]
[![Build Status](https://secure.travis-ci.org/peter-murach/tty.png?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/peter-murach/tty.png)][codeclimate]

[gem]: http://badge.fury.io/rb/tty
[travis]: http://travis-ci.org/peter-murach/tty
[codeclimate]: https://codeclimate.com/github/peter-murach/tty

Toolbox for developing CLI clients in Ruby. This library provides a fluid interface for working with terminals.

## Features

Jump-start development of your command line app:

* Table rendering with an easy-to-use API. [status: In Progress]
* Terminal output colorization, paging.    [status: ✔ ]
* System & command detection utilities.    [status: In Progress]
* Text manipulation(wrapping/truncation)   [status: In Progress]
* Shell user interface.                    [status: In Progress]
* File diffs.                              [status: TODO]
* Progress bar.                            [status: TODO]
* Configuration file management.           [status: TODO]
* Logging                                  [status: In Progress]
* Plugin ecosystem                         [status: TODO]
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

or cross header with rows inside a hash like so

```ruby
  table = TTY::Table.new [{'h1' => ['a1', 'a2'], 'h2' => ['b1', 'b2']}]
```

Apart from `rows` and `header`, you can provide other customization options such as

```ruby
  column_widths   # array of maximum columns widths
  column_aligns   # array of cell alignments out of :left, :center and :right
  renderer        # enforce display type out of :basic, :color, :unicode, :ascii
  orientation     # either :horizontal or :vertical
  border          # hash of border properties out of :characters, :style, :separator keys
  width           # constrain the table total width, otherwise dynamically calculated based on content and terminal size
```

Table behaves like an Array so `<<`, `each` and familiar methods can be used

```ruby
  table << ['a1', 'a2', 'a3']
  table << ['b1', 'b2', 'b3']
  table << ['a1', 'a2'] << ['b1', 'b2']  # chain rows assignment

  table.each { |row| ... }  # iterate over rows
  table.each_with_index     # iterate over each element with row and column index
  table[i, j]               # return element at row(i) and column(j)
  table.row(i) { ... }      # return array for row(i)
  table.column(j) { ... }   # return array for column(j)
  table.column(name)        # return array for column(name), name of header
  table.row_size            # return row size
  table.column_size         # return column size
  table.size                # return an array of [row_size, column_size]
  table.border              # specify border properties
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

#### Border

To print border around data table you need to specify `renderer` type out of `basic`, `ascii`, `unicode`. By default `basic` is used. For instance, to output unicode border:

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

You can also create your own custom border by subclassing `TTY::Table::Border` and implementing the `def_border` method using internal DSL methods like so:

```ruby
  class MyBorder < TTY::Table::Border
    def_border do
      left         '$'
      center       '$'
      right        '$'
      bottom       ' '
      bottom_mid   '*'
      bottom_left  '*'
      bottom_right '*'
    end
  end
```

Next pass the border class to your instantiated table

```ruby
  table = TTY::Table.new ['header1', 'header2'], [['a1', 'a2'], ['b1', 'b2']
  table.renders_with MyBorder
  table.to_s

  $header1$header2$
  $a1     $a2     $
  *       *       *
```

Finally, if you want to introduce slight modifications to the predefined border types, you can use table `border` helper like so

```ruby
  table = TTY::Table.new ['header1', 'header2'], [['a1', 'a2'], ['b1', 'b2']
  table.border do
    mid          '='
    mid_mid      ' '
  end

  table.to_s

  header1 header2
  ======= =======
  a1      a2
  b1      b2
```

In addition to specifying border characters you can force table to render separator line on each row like:

```ruby
  table = TTY::Table.new ['header1', 'header2'], [['a1', 'a2'], ['b1', 'b2']]
  table.border.separator = :each_row
  table.to_s

  +-------+-------+
  |header1|header2|
  +-------+-------+
  |a1     |a2     |
  +-------+-------+
  |b1     |b2     |
  +-------+-------+
```

Also to change the display color of your border do:

```ruby
  table.border.style = :red
```

#### Alignment

All columns are left aligned by default. You can enforce per column alignment by passing `column_aligns` option like so

```ruby
  rows = [['a1', 'a2'], ['b1', 'b2']
  table = TTY::Table.new rows: rows, column_aligns: [:center, :right]
```

To align a single column do

```ruby
  table.align_column(1, :right)
```

If you require a more granular alignment you can align individual fields in a row by passing `align` option

```ruby
  table = TTY::Table.new do |t|
    t << ['a1', 'a2', 'a3']
    t << ['b1', {:value => 'b2', :align => :right}, 'b3']
    t << ['c1', 'c2', {:value => 'c3', :align => :center}]
  end
```

#### Style

To format individual fields/cells do

```ruby
  table = TTY::Table.new rows: rows, width: 40
```

#### Filter

You can define filters that will modify individual table fields value before they are rendered. A filter can be a callable such as proc. Here's an example that formats

```ruby
  table = TTY::Table.new ['header1', 'header2'], [['a1', 'a2'], ['b1', 'b2']
  table.filter = Proc.new do |val, row_index, col_index|
    if col_index == 1 and !(row_index == 0)
      val.capitalize
    end
  end
  table.to_s

  +-------+-------+
  |header1|header2|
  +-------+-------+
  |a1     |A2     |
  +-------+-------+
  |b1     |B2     |
  +-------+-------+

```

To add background color to even fields do

```ruby
```

### Terminal

To read general terminal properties you can use on of the helpers

```ruby
  term = TTY::Terminal.new
  term.width              # => 140
  term.height             # =>  60
  term.color?             # => true or false
  term.echo(false) { }    # switch off echo for the block
  term.page               # page terminal output, on non unix systems falls back to ruby implementation
```

To colorize your output do

```ruby
  term.color.set 'text...', :bold, :red, :on_green    # => red bold text on green background
  term.color.remove 'text...'       # strips off ansi escape sequences
  term.color.code :red              # ansi escape code for the supplied color
```

To page your output do

```ruby
  term.page 'long text...'
```

### Shell

Main responsibility is to interact with the prompt and provide convenience methods.

Available methods are

```ruby
  shell = TTY::Shell.new
  shell.ask          # print question
  shell.read         # read from stdin
  shell.say          # print message to stdout
  shell.confirm      # print message(s) in green
  shell.warn         # print message(s) in yellow
  shell.error        # print message(s) in red
  shell.suggest      # print suggestion message based on possible matches
  shell.print_table  # print table to stdout
```

In order to ask question and parse answers:

```ruby
  shell  = TTY::Shell.new
  answer = shell.ask("What is your name?").read_string
```

The library provides small DSL to help with parsing and asking precise questions

```ruby
  argument    # :required or :optional
  character   # turn character based input, otherwise line (default: false)
  clean       # reset question
  default     # default value used if none is provided
  echo        # turn echo on and off (default: true)
  mask        # mask characters i.e '****' (default: false)
  modify      # apply answer modification :upcase, :downcase, :trim, :chomp etc..
  range       # specify range '0-9', '0..9', '0...9' or negative '-1..-9'
  validate    # regex against which stdin input is checked
  valid       # a list of expected valid options
```

You can chain question methods or configure them inside a block

```ruby
  shell.ask("What is your name?").argument(:required).default('Piotr').validate(/\w+\s\w+/).read_string

  shell.ask "What is your name?" do
    argument :required
    default  'Piotr'
    validate /\w+\s\w+/
    valid    ['Piotr', 'Piotrek']
    modify   :capitalize
  end.read_string
```

Reading answers and converting them into required types can be done with custom readers

```ruby
  read_bool       # return true or false for strings such as "Yes", "No"
  read_date       # return date type
  read_datetime   # return datetime type
  read_email      # validate answer against email regex
  read_float      # return decimal or error if cannot convert
  read_int        # return integer or error if cannot convert
  read_multiple   # return multiple line string
  read_password   # return string with echo turned off
  read_range      # return range type
  read_string     # return string
```

For example, if we wanted to ask a user for a single digit in given range

```ruby
  ask("Provide number in range: 0-9") do
    range '0-9'
    on_error :retry
  end.read_int
```

on the other hand, if we are interested in range answer then

```ruby
  ask("Provide range of numbers?").read_range
```

To suggest possible matches for the user input use `suggest` method like so

```ruby
  shell.suggest('sta', ['stage', 'stash', 'commit', 'branch'])
  # =>
    Did you mean one of these?
            stage
            stash
```

### System

```ruby
  TTY::System.unix?        # check if unix platform
  TTY::System.windows?     # check if windows platform
  TTY::System.which(cmd)   # full path to executable if found, nil otherwise
  TTY::System.exists?(cmd) # check if command is available
  TTY::System.editor       # provides access to system editor
```

To set preferred editor you can either use shell environment variables such as `EDITOR` and `VISUAL` or set the command(s) manually like so

```ruby
  TTY::System.editor.command('vim')
```

To open a file in your editor of choice do

```ruby
  TTY::System.editor.open('file path...')
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012-2013 Piotr Murach. See LICENSE for further details.
