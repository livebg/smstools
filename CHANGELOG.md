## 0.2.2 (20 Jan 2021)

* #9 Fix the way some complex Unicode characters (like composite emojis) are counted. Thanks to @bryanrite for the neat implementation. Note the fix could be **potentially backwards-incompatible** if you were relying on the incorrect behaviour previously. Technically it's still a bug fix.

## 0.2.1 (18 Aug 2020)

* #7 Introduce `SmsTools.use_ascii_encoding` option (defaults to `true` for backwards-compatibility) that allows disabling the `:ascii` workaround encoding. See #6 and #7 for details. Thanks @kingsley-wang.

## 0.2.0 (2 March 2017)

* The non-breaking space character (0x00A0 in Unicode and "\xC2\xA0" in UTF-8) is no longer regarded as a valid GSM 7-bit symbol. [#4](https://github.com/livebg/smstools/issues/4)
* GsmEncoding.to_utf8 will now raise errors in case the provided argument is not a valid GSM 7-bit text.

## 0.1.1 (18 April 2016)

* Replaces small c with cedilla to capital one, as per the GSM 03.38 standard (by @skliask)

## 0.1.0 (08 October 2015)

* distinguish between ascii encoding and gsm encoding
* add option for preventing the use of gsm encoding, that is to use unicode instead

## 0.0.1 (17 January 2014)

* Initial release.
