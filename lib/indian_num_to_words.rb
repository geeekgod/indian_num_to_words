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
    return NUMBER_WORDS[self] if self < 20 || (self % 10 == 0 && self < 100)

    case self
    when 0
      "Zero"
    when 1..99
      tens, ones = self.divmod(10)
      [NUMBER_WORDS[tens * 10], NUMBER_WORDS[ones]].compact.join(" ")
    when 100..999
      hundreds, remainder = self.divmod(100)
      parts = [NUMBER_WORDS[hundreds] + " Hundred"]
      parts << remainder.to_indian_word unless remainder.zero?
      parts.join(" and ")
    when 1000..99999
      thousands, remainder = self.divmod(1000)
      parts = [thousands.to_indian_word + " Thousand"]
      parts << remainder.to_indian_word unless remainder.zero?
      parts.join(", ")
    when 100000..9999999
      lakhs, remainder = self.divmod(100000)
      parts = [lakhs.to_indian_word + " Lakh"]
      parts << remainder.to_indian_word unless remainder.zero?
      parts.join(", ")
    else # 1 crore and above
      crores, remainder = self.divmod(10000000)
      parts = [crores.to_indian_word + " Crore"]
      parts << remainder.to_indian_word unless remainder.zero?
      parts.join(", ")
    end
  end
end


Integer.include IndianNumToWords