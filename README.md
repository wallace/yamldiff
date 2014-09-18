# Yamldiff
[![Build Status](https://travis-ci.org/wallace/yamldiff.png)](https://travis-ci.org/wallace/yamldiff)

Given two yaml files, Yamldiff tells you which keys present in the first file are not present in the second.

## Installation

From release:
```bash
$ sudo gem install yamldiff
```

From source code:
```bash
$ bundle
$ gem build yamldiff.gemspec
$ sudo gem install yamldiff-VERSION.gem
```

## Usage

Of the program:
```console
$ yamldiff 
USAGE: yamldiff [-i] file1 file2
```

Of the lib:
```ruby
require 'yamldiff'
result = Yamldiff.diff_yaml('path_to_file_1', 'path_to_file_2')
result.inspect
# { 'path_to_file_2' => [<array of YamldiffError objects>] }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
