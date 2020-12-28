module SmsTools
  module UnicodeEncoding
    extend self

    BASIC_PLANE = 0x0000..0xFFFF

    # UCS-2/UTF-16 is used for unicode text messaging. UCS-2/UTF-16 represents characters in minimum
    # 2-bytes, any characters in the basic plane are represented with 2-bytes, so each codepoint
    # within the Basic Plane counts as a single character. Any codepoint outside the Basic Plane is
    # encoded using 4-bytes and therefore counts as 2 characters in a text message.
    def character_count(char)
      char.each_codepoint.sum { |codepoint| BASIC_PLANE.include?(codepoint) ? 1 : 2 }
    end
  end
end
