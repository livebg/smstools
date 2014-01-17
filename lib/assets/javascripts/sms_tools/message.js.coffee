window.SmsTools ?= {}

class SmsTools.Message
  maxLengthForEncoding:
    gsm:
      normal: 160
      concatenated: 153
    unicode:
      normal: 70
      concatenated: 67

  doubleByteCharsInGsmEncoding:
    '^':  true
    '{':  true
    '}':  true
    '[':  true
    '~':  true
    ']':  true
    '|':  true
    '€':  true
    '\\': true

  gsmEncodingPattern: /^[0-9a-zA-Z@Δ¡¿£_!Φ"¥Γ#èΛ¤éΩ%ùΠ&ìΨòΣçΘΞ:Ø;ÄäøÆ,<Ööæ=ÑñÅß>ÜüåÉ§à€~ \$\.\-\+\(\)\*\\\/\?\|\^\}\{\[\]\'\r\n]*$/

  constructor: (@text) ->
    @text                   = @text.replace /\r\n?/g, "\n"
    @encoding               = @_encoding()
    @length                 = @_length()
    @concatenatedPartsCount = @_concatenatedPartsCount()

  maxLengthFor: (concatenatedPartsCount) ->
    messageType = if concatenatedPartsCount > 1 then 'concatenated' else 'normal'

    concatenatedPartsCount * @maxLengthForEncoding[@encoding][messageType]

  _encoding: ->
    if @gsmEncodingPattern.test(@text) then 'gsm' else 'unicode'

  _concatenatedPartsCount: ->
    encoding = @encoding
    length   = @length

    if length <= @maxLengthForEncoding[encoding].normal
      1
    else
      parseInt Math.ceil(length / @maxLengthForEncoding[encoding].concatenated), 10

   # Returns the number of symbols, which the given text will take up in an SMS
   # message, taking into account any double-space symbols in the GSM 03.38
   # encoding.
  _length: ->
    length = @text.length

    if @encoding == 'gsm'
      for char in @text
        length += 1 if @doubleByteCharsInGsmEncoding[char]

    length
