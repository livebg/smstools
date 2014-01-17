require 'sms_tools/version'
require 'sms_tools/encoding_detection'
require 'sms_tools/gsm_encoding'

if defined?(::Rails) and ::Rails.version >= '3.1'
  require 'sms_tools/rails/engine'
end
