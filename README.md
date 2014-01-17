# Sms Tools

A small collection of useful Ruby and JavaScript classes implementing often
needed functionality for dealing with SMS messages.

The gem is also a Rails engine and using it in your Rails app will allow you
to also use the JavaScript classes via the asset pipeline.

## Features

The following features are available on both the server side and the client
side:

- Detection of the most optimal encoding for sending an SMS message (GSM 7-bit
  or Unicode).
- Correctly determining the message's length according to the most optimal
  encoding.
- Concatenation detection and concatenated message parts counting.

And more.

## Installation

Add this line to your application's Gemfile:

    gem 'smstools'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install smstools

## Usage

The gem consists of both server-side (Ruby) and client-side classes. You can
use either one.

### Server-side code

If you use the gem in Rails or via Bundler, just use the appropriate class,
such as `SmsTools::EncodingDetection` or `SmsTools::GsmEncoding`.

### Client-side code

If you're using the gem in Rails 3.x or newer, you can just add the following
to your `application.js` file to gain access to the JavaScript classes:

    #= require 'sms_tools/all'

Or require only the files you need:

    #= require 'sms_tools/message'

Note that this assumes you're using the asset pipeline. You need to have a
CoffeeScript preprocessor set up.

## Contributing

1. [Fork the repo](http://github.com/mitio/smstools/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Make your changes and provide tests for them
4. Make sure all tests pass (run them with `bundle exec rake test`)
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Send a pull request.
