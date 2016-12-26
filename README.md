<div align="center">
  <a href="http://piotrmurach.github.io/tty"><img width="130" src="https://cdn.rawgit.com/piotrmurach/tty/master/images/tty.png" alt="tty logo" /></a>
</div>
<br/>
[![Gem Version](https://badge.fury.io/rb/tty.svg)][gem]
[![Build Status](https://secure.travis-ci.org/piotrmurach/tty.svg?branch=master)][travis]
[![Build status](https://ci.appveyor.com/api/projects/status/0a85w6yr40lmuo3o?svg=true)][appveyor]
[![Code Climate](https://codeclimate.com/github/piotrmurach/tty/badges/gpa.svg)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/piotrmurach/tty/badge.svg?branch=master)][coveralls]
[![Inline docs](http://inch-ci.org/github/piotrmurach/tty.svg?branch=master)][inchpages]
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)][gitter]

[gem]: http://badge.fury.io/rb/tty
[travis]: http://travis-ci.org/piotrmurach/tty
[appveyor]: https://ci.appveyor.com/project/piotrmurach/tty
[codeclimate]: https://codeclimate.com/github/piotrmurach/tty
[coveralls]: https://coveralls.io/r/piotrmurach/tty
[inchpages]: http://inch-ci.org/github/piotrmurach/tty
[gitter]: https://gitter.im/piotrmurach/tty

> TTY is a toolbox for developing beautiful command line clients in Ruby. It provides a fluid interface for gathering input from the user, querying system and terminal and displaying information back. It is not another command line options parser, rather a plumbing library that helps in common tasks.

## Motivation

All too often libraries that interact with command line create their own interface logic that gathers input from users and displays information back. Many times utility files are created that contain methods for reading system or terminal properties. Shouldn't we focus our energy on building the actual client?

Even more so, any command line application needs a clear way of communicating its results back to terminal whether in tabular form, column form or colorfully indented text. Our time and energy should be spent in creating the tools not the foundation.

## Features

* Jump-start development of your command line app the Unix way.
* Fully modular, choose out of many [components](#2-components) to suite your needs.
* All tty components are small packages that do one thing well.
* Fully tested with major ruby interpreters.

## Installation

Add this line to your application's Gemfile to install all components:

    gem 'tty'

or install a particular component:

    gem 'tty-*'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tty

## Contents

* [1. Overview](#1-overview)
* [2. Components](#2-components)

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

To run external commands with output logging, capturing stdout and stderr use `TTY::Command`:

```ruby
cmd = TTY::Command.new
out, err = cmd.run('cat ~/.bashrc | grep alias')
```

To measure screen size use `TTY::Screen`:

```ruby
screen = TTY::Screen.new
screen.size     # => [51, 280]
screen.width    # => 280
screen.height   # => 51
```

`TTY::Color` allows you to check if terminal supports color and the color mode:

```ruby
TTY::Color.supports?  # => true
TTY::Color.mode # => 64
```

For instance, to find out if `less` utility is actually supported by the system do:

```ruby
TTY::Which.which('less')  # => '/usr/bin/less'
```

To move cursor around the terminal use `TTY::Cursor`:

```ruby
cursor = TTY::Cursor
print cursor.up(5) + cursor.forward(2)
```

## 2. Components

|  Component   | Description | API docs |
| ------------ | ----------- | -------- |
| [pastel](https://github.com/piotrmurach/pastel) | Terminal strings styling with intuitive and clean API. | [docs](http://www.rubydoc.info/gems/pastel) |
| [tty-color](https://github.com/piotrmurach/tty-color) | Terminal color capabilities detection. | [docs](http://www.rubydoc.info/gems/tty-color) |
|[tty-command](https://github.com/piotrmurach/tty-command) | Execute shell commands with pretty logging and capture stdout, stderr and exit status. | [docs] (http://www.rubydoc.info/gems/tty-command) |
| [tty-cursor](https://github.com/piotrmurach/tty-cursor#ttycursor) | Move terminal cursor around. | [docs](http://www.rubydoc.info/gems/tty-cursor) |
| [tty-editor](https://github.com/piotrmurach/tty-editor) | | |
 |[tty-file](https://github.com/piotrmurach/tty-file) | File manipulation utility methods. | [docs](http://www.rubydoc.info/gems/tty-file) |
| [tty-pager](https://github.com/piotrmurach/tty-pager) | Terminal output paging in a cross-platform way. | [docs](http://www.rubydoc.info/gems/tty-pager) |
| [tty-platform](https://github.com/piotrmurach/tty-platform) | Detecting different operating systems. | [docs](http://www.rubydoc.info/gems/tty-platform) |
| [tty-progressbar](https://github.com/piotrmurach/tty-progressbar) | A flexible progress bars drawing in terminal emulators. | [docs](http://www.rubydoc.info/gems/tty-progressbar) |
| [tty-prompt](https://github.com/piotrmurach/tty-prompt) | A beautiful and powerful interactive command line prompt. | [docs](http://www.rubydoc.info/gems/tty-prompt) |
| [tty-screen](https://github.com/piotrmurach/tty-screen) | Terminal screen properties detection. | [docs](http://www.rubydoc.info/gems/tty-screen)
|[tty-spinner](https://github.com/piotrmurach/tty-spinner) | A terminal spinner for tasks with non-deterministic time.| [docs](http://www.rubydoc.info/gems/tty-spinner) |
| [tty-table](https://github.com/piotrmurach/tty-table) | A flexible and intuitive table output generator. | [docs](http://www.rubydoc.info/gems/tty-table) |
| [tty-which](https://github.com/piotrmurach/tty-which) | Platform independent implementation of Unix which command. | [docs](http://www.rubydoc.info/gems/tty-which) |

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Copyright

Copyright (c) 2012-2017 Piotr Murach. See LICENSE for further details.
