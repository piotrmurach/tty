<div align="center">
  <a href="http://piotrmurach.github.io/tty"><img width="130" src="https://cdn.rawgit.com/piotrmurach/tty/master/images/tty.png" alt="tty logo" /></a>
</div>
<br/>
[![Gem Version](https://badge.fury.io/rb/tty.svg)][gem]
[![Build Status](https://secure.travis-ci.org/piotrmurach/tty.svg?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/piotrmurach/tty/badges/gpa.svg)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/piotrmurach/tty/badge.svg?branch=master)][coveralls]
[![Inline docs](http://inch-ci.org/github/piotrmurach/tty.svg?branch=master)][inchpages]
[![Gitter](https://badges.gitter.im/Join Chat.svg)][gitter]

[gem]: http://badge.fury.io/rb/tty
[travis]: http://travis-ci.org/piotrmurach/tty
[codeclimate]: https://codeclimate.com/github/piotrmurach/tty
[coveralls]: https://coveralls.io/r/piotrmurach/tty
[inchpages]: http://inch-ci.org/github/piotrmurach/tty
[gitter]: https://gitter.im/piotrmurach/tty?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge

> TTY is a toolbox for developing beautiful command line clients in Ruby. It provides a fluid interface for gathering input from the user, querying system and terminal and displaying information back. It is not another command line options parser, rather a plumbing library that helps in common tasks.

## Motivation

All too often libraries that interact with command line create their own interface logic that gathers input from users and displays information back. Many times utility files are created that contain methods for reading system or terminal properties. Shouldn't we focus our energy on building the actual client?

Even more so, any command line application needs a clear way of communicating its results back to terminal whether in tabular form, column form or colorfully indented text. Our time and energy should be spent in creating the tools not the foundation.

## Features

Fully modular, choose out of many components to suite your needs and jump-start development of your command line app:

* Terminal ASCII and Unicode tables.       [status: ✔ ]
* Terminal output colorization.            [status: ✔ ]
* Terminal output paging.                  [status: ✔ ]
* System detection utilities.              [status: ✔ ]
* Command detection utilities.             [status: ✔ ]
* Text manipulation(wrapping/truncation)   [status: ✔ ]
* Terminal progress bars drawing.          [status: ✔ ]
* Terminal spinners.                       [status: ✔ ]
* Interactive prompt for user input.       [status: ✔ ]
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

* [1. Overview](#1-overview)
* [2. Prompting for input](#2-prompting-for-input)
* [3. Drawing tables](#3-drawing-tables)
* [4. Drawing progress bars](#4-drawing-progress-bars)
* [5. Drawing spinners](#5-drawing-spinners)
* [6. Output coloring](#6-output-coloring)
* [7. Output paging](#7-output-paging)
* [8. Detecting screen properties](#8-detecting-screen-properties)
* [9. Detecting platform](#9-detecting-platform)
* [10. Detecting color capabilities](#10-detecting-color-capabilities)
* [11. Searching executables](#11-searching-executables)
* [12. Moving cursor](#12-moving-cursor)
* [13. Setting editor](#13-setting-editor)

## 1. Overview

**TTY** provides you with many tools to get the job done in terminal.

To ask for user input use `TTY::Prompt`:

```ruby
prompt = TTY::Prompt.new
prompt.yes?('Do you like Ruby?')
# => Do you like Ruby? (Y/n)

# or ask to select from list

prompt.select("Choose your destiny?", %w(Scorpion Kano Jax))
# =>
# Choose your destiny? (Use arrow keys, press Enter to select)
# ‣ Scorpion
#   Kano
#   Jax
```

To print tabular output use `TTY::Table`:

```ruby
table = TTY::Table[['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']]
table.to_s
# => a1  a2  a3
     b1  b2  b3
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

To colorize your strings use `Pastel`:

```ruby
pastel = Pastel.new
pastel.green.on_red.bold('Piotr')
```

To page very long input use `TTY::Pager`:

```ruby
pager = TTY::Pager.new
pager.page('Very long text...')
```

To measure screen size use `TTY::Screen`:

```ruby
screen = TTY::Screen.new
screen.size     # => [51, 280]
screen.width    # => 280
screen.height   # => 51
```

`TTY::Color` allows you to check if terminal supports color:

```ruby
TTY::Color.supports?  # => true
TTY::Color.mode # => 64
```

To move cursor around the terminal use `TTY::Cursor`:

```ruby
cursor = TTY::Cursor
print cursor.up(5) + cursor.forward(2)
```

## 2. Prompting for input

**TTY** relies on [tty-prompt](https://github.com/piotrmurach/tty-prompt#ttyprompt) component for processing user input.

```ruby
prompt.ask('What is your name?', default: ENV['USER'])
# => What is your name? (piotr)
```

Please refer to [documentation](https://github.com/piotrmurach/tty-prompt#contents) for complete API.

## 3. Drawing tables

**TTY** uses the [tty-table](https://github.com/piotrmurach/tty-table) component in order to convert data into table and render as string output in tabular form. For example, to render data with ASCII border:

```ruby
table = TTY::Table.new ['header1','header2'], [['a1','a2'], ['b1','b2']]
table.render(:ascii)
# =>
  +-------+-------+
  |header1|header2|
  +-------+-------+
  |a1     |a2     |
  |b1     |b2     |
  +-------+-------+
```

Please refer to [documentation](https://github.com/piotrmurach/tty-table) for complete API.

## 4. Drawing progress bars

In order to draw progress bars in terminal, **TTY** uses the [tty-progressbar](https://github.com/piotrmurach/tty-progressbar) component.

For example, to render basic download bar do:

```ruby
bar = TTY::ProgressBar.new("downloading [:bar]", total: 30)
30.times { bar.advance }
```

Please refer to [documentation](https://github.com/piotrmurach/tty-progressbar) for complete API.

## 5. Drawing spinners

**TTY** uses the [tty-spinner](https://github.com/piotrmurach/tty-spinner) component to handle terminal spinning animation. For instance, to create a simple spinner do:

```ruby
spinner = TTY::Spinner.new("[:spinner] Loading ...", format: :pulse_2)
30.times { spinner.spin }
spinner.stop('Done!')
```

Please refer to [documentation](https://github.com/piotrmurach/tty-spinner) for complete API.

## 6. Output coloring

In order to colorize strings, **TTY** uses the [pastel](https://github.com/piotrmurach/pastel) component:

```ruby
pastel = Pastel.new
pastel.red.on_green.bold 'text...'  # => red bold text on green background
```

Please refer to [documentation](https://github.com/piotrmurach/pastel#contents) for complete API.

## 7. Output paging

To page terminal output **TTY** relies on [tty-pager](https://github.com/piotrmurach/tty-pager) component.

For example to page terminal output do (on non unix systems falls back to ruby implementation):

```ruby
pager = TTY::Pager.new
pager.page('Very long text...')
```

Please refer to [documentation](https://github.com/piotrmurach/tty-pager) for complete API.

## 8. Detecting screen properties

**TTY** uses the [tty-screen](https://github.com/piotrmurach/tty-screen) component to measure the screen properties.

For example to get screen size do:

```ruby
screen = TTY::Screen.new
screen.size     # => [51, 280]
screen.width    # => 280
screen.height   # => 51
```

Please refer to [documentation](https://github.com/piotrmurach/tty-screen) for complete API.

## 9. Detecting platform

To check for platform properties **TTY** uses [tty-platform](https://github.com/piotrmurach/tty-platform) component.

```ruby
platform = TTY::Platform.new
platform.cpu     # => 'x86_64'
platform.os      # => 'darwin'
platform.version # => '10.6.1'
```

In addition, there are more generic utilities to check for type of operating system:

```
TTY::Platform.unix?    # => true
TTY::Platform.windows? # => false
```

Please refer to [documentation](https://github.com/piotrmurach/tty-platform) for complete API.

## 10. Detecting color capabilities

[tty-color](https://github.com/piotrmurach/tty-color) component allows **TTY** detect color support and mode in terminal emulator:

```ruby
TTY::Color.supports?  # => true
TTY::Color.mode # => 64
```

Please refer to [documentation](https://github.com/piotrmurach/tty-color) for complete API.

## 11. Searching executables

To find executable path **TTY** uses [tty-which](https://github.com/piotrmurach/tty-which#ttywhich) component.

For instance, to find out if `less` utility is actually supported by the system do:

```ruby
TTY::Which.which('less')  # => '/usr/bin/less'
```

Please refer to [documentation](https://github.com/piotrmurach/tty-which#ttywhich) for complete API.

## 12. Moving cursor

To perform terminal cursor movements use [tty-cursor](https://github.com/piotrmurach/tty-cursor#ttycursor) component.

For example, to move cursor up by 5 rows and forward by 2 columns:

```ruby
cursor = TTY::Cursor
print cursor.up(5) + cursor.forward(2)
```

Please refer to [documentation](https://github.com/piotrmurach/tty-cursor#contents) for complete API.

## 13. Setting editor

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

Copyright (c) 2012-2016 Piotr Murach. See LICENSE for further details.
