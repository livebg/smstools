require 'spec_helper'
require 'sms_tools'

describe SmsTools::GsmEncoding do
  describe 'from_utf8' do
    it 'converts simple UTF-8 text to GSM 03.38' do
      SmsTools::GsmEncoding.from_utf8('simple').must_equal 'simple'
    end

    it 'converts UTF-8 text with double-byte chars to GSM 03.38' do
      SmsTools::GsmEncoding.from_utf8('foo []').must_equal "foo \e<\e>"
    end

    it 'raises an exception if the UTF-8 text contains chars outside of GSM 03.38' do
      -> { SmsTools::GsmEncoding.from_utf8('баба') }.must_raise RuntimeError, /Unsupported symbol in GSM-7 encoding/
    end
  end

  describe 'force_from_utf8' do
    it 'converts simple UTF-8 text to GSM 03.38' do
      SmsTools::GsmEncoding.from_utf8('simple').must_equal 'simple'
    end

    it 'converts UTF-8 text with double-byte chars to GSM 03.38' do
      SmsTools::GsmEncoding.from_utf8('foo []').must_equal "foo \e<\e>"
    end

    it 'converts UTF-8 text removing invalid characters' do
      SmsTools::GsmEncoding.from_utf8('бsimple\t\v\b\a').must_equal "simple"
    end
  end

  describe 'to_utf8' do
    it 'converts simple GSM 03.38 to UTF-8' do
      SmsTools::GsmEncoding.to_utf8('simple').must_equal 'simple'
    end

    it 'converts UTF-8 text with double-byte chars to GSM 03.38' do
      SmsTools::GsmEncoding.to_utf8("GSM \e<\e>").must_equal 'GSM []'
    end

    it 'raises an exception if the UTF-8 text contains chars outside of GSM 03.38' do
      -> { SmsTools::GsmEncoding.to_utf8('баба') }.must_raise RuntimeError, /Unsupported symbol in GSM-7 encoding/
    end

    it 'ignores single occurrences of the GSM-7 extension table escape code' do
      SmsTools::GsmEncoding.to_utf8("\x1B").must_equal ''
    end
  end
end
