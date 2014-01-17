# Sms Tools

A small collection of Ruby and JavaScript classes implementing often needed functionality for
dealing with SMS messages.

The gem can also be used in a Rails application as an engine. It integrates with the asset pipeline
and gives you access to some clinet-side SMS manipulation functionality.

## Features

The following features are available on both the server side and the client
side:

- Detection of the most optimal encoding for sending an SMS message (GSM 7-bit or Unicode).
- Correctly determining a message's length in the most optimal encoding.
- Concatenation detection and concatenated message parts counting.

The following can be accomplished only on the server with Ruby:

- Converting a UTF-8 string to a GSM 7-bit encoding and vice versa.
- Detecting if a UTF-8 string can be safely represented in a GSM 7-bit encoding.
- Detection of double-byte chars in the GSM 7-bit encoding.

And possibly more.

### Note on the GSM encoding

All references to the "GSM" encoding or the "GSM 7-bit alphabet" in this text actually refer to the
[GSM 03.38 spec](http://en.wikipedia.org/wiki/GSM_03.38) and [its latest
version](ftp://ftp.unicode.org/Public/MAPPINGS/ETSI/GSM0338.TXT), as defined by the Unicode
consortium.

This encoding is the most widely used one when sending SMS messages.

## Installation

Add this line to your application's Gemfile:

    gem 'smstools'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install smstools

If you're using the gem in Rails, you may also want to add the following to your `application.js`
manifest file to gain access to the client-side features:

    //= require sms_tools

## Usage

The gem consists of both server-side (Ruby) and client-side classes. You can
use either.

### Server-side code

First make sure you have installed the gem and have required the appropriate files.

#### Encoding detection

The `SmsTools::EncodingDetection` class provides you with a few simple methods to detect the most
optimal encoding for sending an SMS message, to correctly caclulate its length in that encoding and
to see if the text would need to be concatenated or will fit in a single message.

Here is an example with a non-concatenated message which is best encoded in the GSM 7-bit alphabet:

```ruby
sms_text     = 'Text in GSM 03.38: ÄäøÆ with a double-byte char: ~ '
sms_encoding = SmsTools::EncodingDetection.new sms_text

sms_encoding.gsm?               # => true
sms_encoding.unicode?           # => false
sms_encoding.length             # => 52 (because of the double-byte char)
sms_encoding.concatenated?      # => false
sms_encoding.concatenated_parts # => 1
sms_encoding.encoding           # => :gsm
```

Here's another example with a concatenated Unicode message:

```ruby
sms_text     = 'Я' * 90
sms_encoding = SmsTools::EncodingDetection.new sms_text

sms_encoding.gsm?               # => false
sms_encoding.unicode?           # => true
sms_encoding.length             # => 90
sms_encoding.concatenated?      # => true
sms_encoding.concatenated_parts # => 2
sms_encoding.encoding           # => :unicode
```

You can check the specs for this class for more examples.

#### GSM 03.38 encoding conversion

The `SmsTools::GsmEncoding` class can be used to check if a given UTF-8 string can be full
represented in the GSM 03.38 encoding as well as to convert from UTF-8 to GSM 03.38 and vice-versa.

The main API this class gives you is:

```ruby
SmsTools::GsmEncoding.valid? message_text_in_utf8   # => true or false

SmsTools::GsmEncoding.from_utf8 utf8_encoded_string # => a GSM 03.38 encoded string
SmsTools::GsmEncoding.to_utf8 gsm_encoded_string    # => an UTF-8 encoded string
```

Check out the code of the class to find out more.

### Client-side code

If you're using the gem in Rails 3.1 or newer, you can gain access to the `SmsTools.Message` class.
It's interface is similar to the one of `SmsTools::EncodingDetection`. Here is an example in
CoffeeScript:

```coffeescript
message = new SmsTools.Message 'The text of the message: ~'

message.encoding               # => 'gsm'
message.length                 # => 27
message.concatenatedPartsCount # => 1
```

You can also check how long can this message be in the current most optimal encoding, if we want to
limit the number of concatenated messages we will allow to be sent:

```coffeescript
maxConcatenatedPartsCount = 2
message.maxLengthFor(maxConcatenatedPartsCount) # => 306
```

This allows you to have a dynamic instead of a fixed length limit, for when you use a non-GSM 03.38
symbol in your text, your message length limit decreases significantly.

Note that to use this client-side code, a Rails application with an active asset pipeline is
assumed. It might be possible to use it in other setups as well, but you're on your own there.

## Contributing

1. [Fork the repo](http://github.com/mitio/smstools/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Make your changes and provide tests for them
4. Make sure all tests pass (run them with `bundle exec rake test`)
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Send a pull request.
