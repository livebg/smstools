require 'spec_helper'
require 'sms_tools'

describe SmsTools::EncodingDetection do
  it "exposes the original text as a method" do
    detection_for('foo').text.must_equal 'foo'
  end

  describe "encoding" do
    it "defaults to ASCII encoding for empty messages" do
      detection_for('').encoding.must_equal :ascii
    end

    it "returns ASCII as encoding for simple ASCII text" do
      detection_for('foo bar baz').encoding.must_equal :ascii
    end

    it "returns GSM as encoding for special symbols defined in GSM 03.38" do
      detection_for('09azAZ@Δ¡¿£_!Φ"¥Γ#èΛ¤éΩ%ùΠ&ìΨòΣCΘΞ:Ø;ÄäøÆ,<Ööæ=ÑñÅß>ÜüåÉ§à€~').encoding.must_equal :gsm
    end

    it "returns ASCII as encoding for puntucation and newline symbols" do
      detection_for('Foo bar {} [baz]! Larodi $5. What else?').encoding.must_equal :ascii
      detection_for("Spaces and newlines are GSM 03.38, too: \r\n").encoding.must_equal :ascii
    end

    it "returns Unicode when non-GSM Unicode symbols are used" do
      detection_for('Foo bar лароди').encoding.must_equal :unicode
      detection_for('∞').encoding.must_equal :unicode
    end

    it 'considers the non-breaking space character as a non-GSM Unicode symbol' do
      non_breaking_space = "\xC2\xA0"

      detection_for(non_breaking_space).encoding.must_equal :unicode
    end

    describe 'with SmsTools.use_gsm_encoding = false' do
      before do
        SmsTools.use_gsm_encoding = false
      end

      after do
        SmsTools.use_gsm_encoding = true
      end

      it "returns Unicode as encoding for special symbols defined in GSM 03.38" do
        detection_for('09azAZ@Δ¡¿£_!Φ"¥Γ#èΛ¤éΩ%ùΠ&ìΨòΣCΘΞ:Ø;ÄäøÆ,<Ööæ=ÑñÅß>ÜüåÉ§à€~').encoding.must_equal :unicode
      end

      it 'returns ASCII for simple ASCII text' do
        detection_for('Hello world.').encoding.must_equal :ascii
      end

      it "defaults to ASCII encoding for empty messages" do
        detection_for('').encoding.must_equal :ascii
      end
    end

    describe 'with SmsTools.use_ascii_encoding = false' do
      before do
        SmsTools.use_ascii_encoding = false
      end

      after do
        SmsTools.use_ascii_encoding = true
      end

      it "returns GSM 03.38 as encoding for special symbols defined in GSM 03.38" do
        detection_for('09azAZ@Δ¡¿£_!Φ"¥Γ#èΛ¤éΩ%ùΠ&ìΨòΣCΘΞ:Ø;ÄäøÆ,<Ööæ=ÑñÅß>ÜüåÉ§à€~').encoding.must_equal :gsm
      end

      it 'returns GSM 03.38 for simple ASCII text' do
        detection_for('Hello world.').encoding.must_equal :gsm
      end

      it "defaults to GSM 03.38 encoding for empty messages" do
        detection_for('').encoding.must_equal :gsm
      end
    end
  end

  describe "message length" do
    it "computes the length of trivial ANSI-only messages correctly" do
      detection_for('').length.must_equal 0
      detection_for('larodi').length.must_equal 6
      detection_for('a' * 180).length.must_equal 180
    end

    it "computes the length of non-trivial GSM encoded messages correctly" do
      detection_for('GSM: 09azAZ@Δ¡¿£_!Φ"¥Γ#èΛ¤éΩ%ùΠ&ìΨòΣÇΘΞ:Ø;ÄäøÆ,<Ööæ=ÑñÅß>ÜüåÉ§à').length.must_equal 63
    end

    it "correctly counts the length of whitespace-only messages" do
      detection_for('     ').length.must_equal 5
      detection_for("\r\n  ").length.must_equal 4
    end

    it "correctly counts the length of whitespace chars in GSM-encoded messages" do
      detection_for('ΞØ     ').length.must_equal 7
      detection_for("ΞØ\r\n  ").length.must_equal 6
    end

    it "counts double-space chars for GSM encoding" do
      detection_for('^{}[~]|€\\').length.must_equal 18
      detection_for('Σ: €').length.must_equal 5
    end

    it "computes the length of Unicode messages correctly" do
      detection_for('кирилица').length.must_equal 8
      detection_for('Я!').length.must_equal 2
      detection_for("Уникод: ΞØ\r\n  ").length.must_equal 14
      detection_for('Ю' * 200).length.must_equal 200
    end

    it "doesn't count double-space chars for Unicode encoding" do
      detection_for('Уникод: ^{}[~]|€\\').length.must_equal 17
      detection_for('Уникод: Σ: €').length.must_equal 12
    end

    it "counts ZWJ unicode characters correctly" do
      detection_for('😴').length.must_equal 2
      detection_for('🛌🏽').length.must_equal 4
      detection_for('🤾🏽‍♀️').length.must_equal 7
      detection_for('🇵🇵').length.must_equal 4
      detection_for('👩‍❤️‍👩').length.must_equal 8
    end

    describe 'with SmsTools.use_gsm_encoding = false' do
      before do
        SmsTools.use_gsm_encoding = false
      end

      it "returns ASCII encoded length for some specific symbols which are also in GSM 03.38" do
        detection_for('[]').length.must_equal 2
      end
    end

    describe 'with SmsTools.use_ascii_encoding = false' do
      before do
        SmsTools.use_ascii_encoding = false
      end

      it "returns GSM 03.38 encoded length for some specific symbols which are also in ASCII" do
        detection_for('[]').length.must_equal 4
      end
    end
  end

  describe "concatenated message parts counting" do
    def concatenated_parts_for(length: nil, encoding: nil, must_be: nil)
      SmsTools::EncodingDetection.new('').stub :length, length do |detection|
        detection.stub :encoding, encoding do |detection|
          detection.concatenated_parts.must_equal must_be
        end
      end
    end

    it "counts parts for GSM-encoded messages" do
      concatenated_parts_for length: 0,   encoding: :gsm, must_be: 1
      concatenated_parts_for length: 160, encoding: :gsm, must_be: 1
      concatenated_parts_for length: 161, encoding: :gsm, must_be: 2
      concatenated_parts_for length: 306, encoding: :gsm, must_be: 2
      concatenated_parts_for length: 307, encoding: :gsm, must_be: 3
      concatenated_parts_for length: 459, encoding: :gsm, must_be: 3
      concatenated_parts_for length: 500, encoding: :gsm, must_be: 4
    end

    it "counts parts for Unicode messages" do
      concatenated_parts_for length: 0,   encoding: :unicode, must_be: 1
      concatenated_parts_for length: 70,  encoding: :unicode, must_be: 1
      concatenated_parts_for length: 71,  encoding: :unicode, must_be: 2
      concatenated_parts_for length: 134, encoding: :unicode, must_be: 2
      concatenated_parts_for length: 135, encoding: :unicode, must_be: 3
    end

    it "counts parts for actual GSM-encoded messages" do
      detection_for('').concatenated_parts.must_equal 1
      detection_for('Σ' * 160).concatenated_parts.must_equal 1
      detection_for('Σ' * 159 + '~').concatenated_parts.must_equal 2
    end

    it "counts parts for actual Unicode-encoded messages" do
      detection_for('Я').concatenated_parts.must_equal 1
      detection_for('Я' * 70).concatenated_parts.must_equal 1
      detection_for('Я' * 71).concatenated_parts.must_equal 2
      detection_for('Я' * 133 + '~').concatenated_parts.must_equal 2
    end
  end

  describe "maximum length for particular number of concatenated messages" do
    it "works for GSM-encoded messages" do
      detection_for('x').maximum_length_for(1).must_equal 160
      detection_for('x').maximum_length_for(2).must_equal 306
      detection_for('x').maximum_length_for(3).must_equal 459
    end

    it "works for Unicode messages" do
      detection_for('ю').maximum_length_for(1).must_equal 70
      detection_for('ю').maximum_length_for(2).must_equal 134
      detection_for('ю').maximum_length_for(3).must_equal 201
    end
  end

  describe "predicates" do
    it "returns true for gsm? and false for unicode? if the encoding is GSM" do
      detection_for('').stub :encoding, :gsm do |detection|
        detection.must_be :gsm?
        detection.wont_be :unicode?
      end
    end

    it "returns false for gsm? and true for unicode? if the encoding is Unicode" do
      detection_for('').stub :encoding, :unicode do |detection|
        detection.wont_be :gsm?
        detection.must_be :unicode?
      end
    end

    it "returns true for concatenated? if concatenated_parts > 1" do
      detection_for('').stub :concatenated_parts, 7 do |detection|
        detection.must_be :concatenated?
      end
    end

    it "returns false for concatenated? if concatenated_parts is 1" do
      detection_for('').stub :concatenated_parts, 1 do |detection|
        detection.wont_be :concatenated?
      end
    end
  end

  def detection_for(text)
    SmsTools::EncodingDetection.new text
  end
end
