# BibleGateway

Travis CI:
[![Build Status](https://travis-ci.org/bibleable/bible_gateway.png?branch=master)](https://travis-ci.org/bibleable/bible_gateway)
1.9.3, 2.0.0, 2.1.1

An unofficial 'API' for BibleGateway.com. 

## Installation

Add this line to your application's Gemfile:

    gem 'bible_gateway'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bible_gateway

## Usage

```
require 'bible_gateway'

BibleGateway.versions # available versions

b = BibleGateway.new # defaults to :king_james_version, but can be initialized to different version

b.version = :english_standard_version
b.lookup('John 1:1') # => "<h4>John 1</h4>\n<h5>The Word Became Flesh</h5> <sup>1</sup> In the beginning was the Word, and the Word was with God, and the Word was God."
```

## Scraping the old site through old_lookup

```
require 'bible_gateway'

b = BibleGateway.new # defaults to :king_james_version, but can be initialized to different version

b.old_lookup('John 1:1') # scraping the old site
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

See [LICENSE](License.txt) for details.
Most Bible translations are copyrighted.  Please see [BibleGateway.com](http://biblegateway.com) for more information.

## Thanks

Special thanks to Geoffrey Dagley([@gdagley](http://github.com/gdagley)) - the original creator of `bible_gateway` rubygem. 
