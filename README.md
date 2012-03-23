# Yamldiff

Given two yaml files, Yamldiff tells you which keys present in the first file
are not present in the second.

## Installation

Add this line to your application's Gemfile:

    gem 'yamldiff'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yamldiff

## Usage

    require 'yamldiff'
    result = Yamldiff.diff_yaml('path_to_file_1', 'path_to_file_2')
    result.inspect
    # { 'path_to_file_2' => [<array of YamldiffError objects>] }

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
