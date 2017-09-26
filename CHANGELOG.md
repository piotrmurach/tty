# Change log

This file documents notable changes in reverse chronological order.

## [v0.8.0] - 2017-xx-xx

### Added
* Add telety executable
* Add CLI for scaffolding new console applications
* Add Commands::New for generating new command line applications
* Add Plugins#load_from to allow loading dependencies from gemspec
* Add tty-tree component

### Changed
* Remove Plugins#find
* Change Plugins#load to Plugins#activate
* Remove metrics rake tasks
* Update dependencies

## [v0.7.0] - 2017-03-26

### Changed
* Update tty-prompt dependency
* Update tty-cursor dependency
* Update tty-pager dependency
* Update tty-which dependency
* Update tty-file dependency
* Update tty-editor dependency

## [v0.6.1] - 2017-02-26

### Changed
* Update tty-command dependency

## [v0.6.0] - 2017-01-28

### Added
* Add tty-editor dependency
* Add tty-file dependency

### Changed
* Change to use plugin system to load all tty dependencies
* Remove coercion, delegatable & unicode support
* Remove error types from TTY module namespace
* Remove System::Editor
* Remove Vector
* Remove Logger
* Remove Terminal & Terminal:Home

## [v0.5.0] - 2016-05-30

### Added
* Add tty-command dependency

### Changed
* Update tty-progressbar dependency
* Update tty-prompt dependency
* Update tty-spinner dependency

## [v0.4.0] - 2016-02-13

### Added
* Add tty-color dependency

### Changed
* Update dependencies

## [v0.3.2] - 2015-11-28

### Added
* Add tty-cursor as a dependency

### Changed
* Remove necromancer dependency

## [v0.3.1] - 2015-11-25

### Added
* Add tty-prompt as actual dependency

## [v0.3.0] - 2015-11-24

### Changed
* Extract prompting for user input as dependency on tty-prompt
* Extract terminal mode
* Remove support utils
* Update dependencies to latest
* Change home directory implementation

## [v0.2.1] -2015-09-20

* Update dependencies to latest versions

## [v0.2.0] - 2015-07-06

### Changed
* Extract platform detection as dependency on tty-platform
* Extract terminal output paging as dependency on tty-pager
* Extract which command as dependency on tty-which

## [v0.1.3] - 2015-04-03

### Added
* Add table rendering as dependency on tty-table

### Changed
* Update tty-progressbar dependency

## [0.1.2] - 2014-12-14

### Added
* Add Necromancer for type conversions
* Add read_keypress call by @janko-m
* Add raw mode by @janko-m

### Changed
* Remove type conversions

## [v0.1.1] - 2014-11-23

### Added
* Add TTY::ProgressBar
* Add TTY::Spinner

### Changed
* Remove TTY::Terminal::Color and replace with Pastel
* Change to depend on Equatable library
* Change to depend on TTY::Screen library for screen size detection

## [v0.1.0] - 2014-09-21

### Changed
* Simplify development dependency mangement
* Update test suite to the latest RSpec
* Improve method documentation across library
* Semantic changes across library to improve code readability

## [v0.0.1] - 2012-09-30

* Initial release

[v0.7.0]: https://github.com/piotrmurach/tty/compare/v0.6.1...v0.7.0
[v0.6.1]: https://github.com/piotrmurach/tty/compare/v0.6.0...v0.6.1
[v0.6.0]: https://github.com/piotrmurach/tty/compare/v0.5.0...v0.6.0
[v0.5.0]: https://github.com/piotrmurach/tty/compare/v0.4.0...v0.5.0
[v0.4.0]: https://github.com/piotrmurach/tty/compare/v0.3.2...v0.4.0
[v0.3.2]: https://github.com/piotrmurach/tty/compare/v0.3.1...v0.3.2
[v0.3.1]: https://github.com/piotrmurach/tty/compare/v0.3.0...v0.3.1
[v0.3.0]: https://github.com/piotrmurach/tty/compare/v0.2.1...v0.3.0
[v0.2.1]: https://github.com/piotrmurach/tty/compare/v0.2.0...v0.2.1
[v0.2.0]: https://github.com/piotrmurach/tty/compare/v0.1.3...v0.2.0
[v0.1.3]: https://github.com/piotrmurach/tty/compare/v0.1.2...v0.1.3
[v0.1.2]: https://github.com/piotrmurach/tty/compare/v0.1.1...v0.1.2
[v0.1.1]: https://github.com/piotrmurach/tty/compare/v0.1.0...v0.1.1
[v0.1.0]: https://github.com/piotrmurach/tty/compare/v0.0.9...v0.1.0
