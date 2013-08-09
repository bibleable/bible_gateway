# BibleGateway

Travis CI:
[![Build Status](https://travis-ci.org/gdagley/bible_gateway.png?branch=master)](https://travis-ci.org/gdagley/bible_gateway)
1.9.2, 1.9.3, 2.0.0

An unofficial 'API' for BibleGateway.com.

## Installation

Add this line to your application's Gemfile:

    gem 'bible_gateway'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bible_gateway

## Usage

    BibleGateway.versions # available versions

    b = BibleGateway.new # defaults to :king_james_version, but can be initialized to different version
    b.version = :english_standard_version
    b.lookup('John 1:1') # => "<h4>John 1</h4>\n<h5>The Word Became Flesh</h5> <sup>1</sup> In the beginning was the Word, and the Word was with God, and the Word was God."

## Todo

* Add other versions that are available

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

See [LICENSE](License.txt) for details.
Most Bible translations are copyrighted.  Please see [BibleGateway.com](http://biblegateway.com) for more information.
