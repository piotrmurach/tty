# [![Application icon](https://github.com/peter-murach/tty/raw/master/images/tty.png)][icon]
[icon]: http://peter-murach.github.io/tty/
[![Gem Version](https://badge.fury.io/rb/tty.png)][gem]
[![Build Status](https://secure.travis-ci.org/peter-murach/tty.png?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/peter-murach/tty.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/peter-murach/tty/badge.png?branch=master)][coveralls]
[![Inline docs](http://inch-ci.org/github/peter-murach/tty.png?branch=master)][inchpages]
[![Gitter](https://badges.gitter.im/Join Chat.svg)][gitter]

[gem]: http://badge.fury.io/rb/tty
[travis]: http://travis-ci.org/peter-murach/tty
[codeclimate]: https://codeclimate.com/github/peter-murach/tty
[coveralls]: https://coveralls.io/r/peter-murach/tty
[inchpages]: http://inch-ci.org/github/peter-murach/tty
[gitter]: https://gitter.im/peter-murach/tty?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge

> TTY is a toolbox for developing beautiful command line clients in Ruby. It provides a fluid interface for gathering input from the user, querying system and terminal and displaying information back. It is not another command line options parser, rather a plumbing library that helps in common tasks.

## Motivation

All too often libraries that interact with command line create their own interface logic that gathers input from users and displays information back. Many times utility files are created that contain methods for reading system or terminal properties. Shouldn't we focus our energy on building the actual client?

Even more so, any command line application needs a clear way of communicating its results back to terminal whether in tabular form, column form or colorfully indented text. Our time and energy should be spent in creating the tools not the foundation.

## Features

Jump-start development of your command line app:

* Terminal ASCII and Unicode tables.       [status: ✔ ]
* Terminal output colorization.            [status: ✔ ]
* Terminal output paging.                  [status: ✔ ]
* System detection utilities.              [status: ✔ ]
* Command detection utilities.             [status: ✔ ]
* Text manipulation(wrapping/truncation)   [status: ✔ ]
* Terminal progress bars drawing.          [status: ✔ ]
* Terminal spinners.                       [status: ✔ ]
* Prompt user interface.                   [status: In Progress]
* File diffs.                              [status: TODO]
* Configuration file management.           [status: TODO]
* Logging                                  [status: In Progress]
* Plugin ecosystem                         [status: TODO]
* Fully tested with major ruby interpreters.

## Installation

Add this line to your application's Gemfile:

    gem 'tty'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tty

## Contents

* [1. Table](#1-table)
* [2. Color](#2-color)
* [3. ProgressBar](#3-progressbar)
* [4. Spinner](#4-spinner)
* [5. Screen](#5-screen)
* [6. Terminal](#6-terminal)
  * [6.1 Pager](#61-pager)
* [7. Shell](#7-shell)
* [8. System](#8-system)

## Usage

**TTY** provides you with many tools to get the job done in terminal.

To print tabular output use `TTY::Table`:

```ruby
table = TTY::Table[['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']]
table.to_s   # => a1  a2  a3
                  b1  b2  b3
```

To colorize your strings use `Pastel`:

```ruby
pastel = Pastel.new
pastel.green.on_red.bold('Piotr')
```

To create a progress bar use `TTY::ProgressBar`:

```ruby
bar = TTY::ProgressBar.new("downloading [:bar]", total: 30)
30.times { bar.advance }
```

To create a spinner use `TTY::Spinner`:

```ruby
spinner = TTY::Spinner.new('Loading ... ', format: :spin_2)
30.times { spinner.spin }
```

## 1. Table

In order to convert data into table and generate ASCII output do:

```ruby
table = TTY::Table.new ['h1','h2','h3'], [['a1','a2','a3'], ['b1','b2','b3']]
table.render
# =>
  +--+--+--+
  |h1|h2|h3|
  +--+--+--+
  |a1|a2|a3|
  |b1|b2|b3|
  +--+--+--+
```

Please refer to [documentation](https://github.com/peter-murach/tty-table) for complete API.

## 2. Color

To colorize your output you can use **Pastel** like so:

```ruby
pastel = Pastel.new
pastel.red.on_green.bold 'text...'  # => red bold text on green background
```

Please refer to [documentation](https://github.com/peter-murach/pastel) for complete API.

## 3. ProgressBar

Please refer to [documentation](https://github.com/peter-murach/tty-progressbar) for complete API.

## 4. Spinner

Please refer to [documentation](https://github.com/peter-murach/tty-spinner) for complete API.

## 5. Screen

Please refer to [documentation](https://github.com/peter-murach/tty-screen) for complete API.


## 6 Terminal

To read general terminal properties you can use on of the helpers

```ruby
term = TTY::Terminal.new
term.echo(false) { }    # switch off echo for the block
term.page               # page terminal output, on non unix systems falls back to ruby implementation
```

### 6.1 Pager

To page your output do

```ruby
term.page 'long text...'
```

## 7 Shell

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
argument   # :required or :optional
char       # turn character based input, otherwise line (default: false)
clean      # reset question
default    # default value used if none is provided
echo       # turn echo on and off (default: true)
mask       # mask characters i.e '****' (default: false)
modify     # apply answer modification :upcase, :downcase, :trim, :chomp etc..
in         # specify range '0-9', '0..9', '0...9' or negative '-1..-9'
validate   # regex against which stdin input is checked
valid      # a list of expected valid options
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
read_char       # return first character
read_date       # return date type
read_datetime   # return datetime type
read_email      # validate answer against email regex
read_file       # return a File object
read_float      # return decimal or error if cannot convert
read_int        # return integer or error if cannot convert
read_multiple   # return multiple line string
read_password   # return string with echo turned off
read_range      # return range type
read_regex      # return regex expression
read_string     # return string
read_symbol     # return symbol
read_text       # return multiline string
read_keypress   # return the key pressed
```

For example, if we wanted to ask a user for a single digit in given range

```ruby
ask("Provide number in range: 0-9").in('0-9') do
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

## 8 System

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

Copyright (c) 2012-2014 Piotr Murach. See LICENSE for further details.
