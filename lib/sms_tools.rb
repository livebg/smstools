require 'sms_tools/version'
require 'sms_tools/encoding_detection'
require 'sms_tools/gsm_encoding'
require 'sms_tools/unicode_encoding'

if defined?(::Rails) and ::Rails.version >= '3.1'
  require 'sms_tools/rails/engine'
end

module SmsTools
  class << self
    def use_gsm_encoding?
      @use_gsm_encoding.nil? ? true : @use_gsm_encoding
    end

    def use_gsm_encoding=(value)
      @use_gsm_encoding = value
    end

    def use_ascii_encoding?
      @use_ascii_encoding.nil? ? true : @use_ascii_encoding
    end

    def use_ascii_encoding=(value)
      @use_ascii_encoding = value
    end
  end
end
