# frozen_string_literal: true

require_relative "indian_num_to_words/version"

NUMBER_WORDS = {
  0 => "Zero", 1 => "One", 2 => "Two", 3 => "Three", 4 => "Four", 5 => "Five",
  6 => "Six", 7 => "Seven", 8 => "Eight", 9 => "Nine", 10 => "Ten",
  11 => "Eleven", 12 => "Twelve", 13 => "Thirteen", 14 => "Fourteen",
  15 => "Fifteen", 16 => "Sixteen", 17 => "Seventeen", 18 => "Eighteen",
  19 => "Nineteen", 20 => "Twenty", 30 => "Thirty", 40 => "Forty",
  50 => "Fifty", 60 => "Sixty", 70 => "Seventy", 80 => "Eighty", 90 => "Ninety"
}

module IndianNumToWords
  class Error < StandardError; end

  def to_indian_word
    
    return "Minus " + (-self).to_indian_word if self < 0
    
    return integer_to_words(self) if is_a?(Integer)

    return float_to_words(self) if is_a?(Float)
  end

  private

  def float_to_words(number)
    whole, decimal = number.to_s.split('.')
    words = integer_to_words(whole.to_i)
    unless decimal.to_i.zero?
      decimal_words = decimal.chars.map { |d| NUMBER_WORDS[d.to_i] }.join(" ")
      words += " Point " + decimal_words
    end
    words
  end

  def integer_to_words(number)
    return NUMBER_WORDS[number] if number < 20 || (number % 10 == 0 && number < 100)

    case number
    when 0
      "Zero"
    when 1..99
      tens, ones = number.divmod(10)
      [NUMBER_WORDS[tens * 10], NUMBER_WORDS[ones]].compact.join(" ")
    when 100..999
      hundreds, remainder = number.divmod(100)
      parts = [NUMBER_WORDS[hundreds] + " Hundred"]
      parts << integer_to_words(remainder) unless remainder.zero?
      parts.join(" and ")
    when 1000..99999
      thousands, remainder = number.divmod(1000)
      parts = [integer_to_words(thousands) + " Thousand"]
      parts << integer_to_words(remainder) unless remainder.zero?
      parts.join(", ")
    when 100000..9999999
      lakhs, remainder = number.divmod(100000)
      parts = [integer_to_words(lakhs) + " Lakh"]
      parts << integer_to_words(remainder) unless remainder.zero?
      parts.join(", ")
    else
      crores, remainder = number.divmod(10000000)
      parts = [integer_to_words(crores) + " Crore"]
      parts << integer_to_words(remainder) unless remainder.zero?
      parts.join(", ")
    end
  end
end


Integer.include IndianNumToWords
Float.include IndianNumToWords