# BibleGateway

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

> Note that the method `BibleGateway.new.old_lookup` is only available after version `0.1.0`. By default, this gem will scrape the new biblegateway.com

```
require 'bible_gateway'

b = BibleGateway.new # defaults to :king_james_version, but can be initialized to different version

b.old_lookup('John 1:1') # scraping the old site
```

## Contributing

This gem needs more contributors! Areas that require help may include: raising issues, editing documentation, features implementation or simply supporting/sharing this repo to other like-minded folks. If you know someone who can help, please share our repo to him/her.  https://github.com/bibleable/bible_gateway Thank you!

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Building and testing of this gem

1. Git clone https://github.com/bibleable/bible_gateway.git and `cd bible_gateway`
2. Build gem by running `gem build bible_gateway.gemspec`
3. Gem install by running `gem install bible_gateway-X.X.X.gem`. Please replace X.X.X
4. To test, simply run `rspec`

## Copyright

See [LICENSE](License.txt) for details.
Most Bible translations are copyrighted.  Please see [BibleGateway.com](http://biblegateway.com) for more information.

## Special thanks

Special thanks to Geoffrey Dagley([@gdagley](http://github.com/gdagley)) - the original creator of `bible_gateway` rubygem. 
