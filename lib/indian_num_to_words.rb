# frozen_string_literal: true

require_relative "indian_num_to_words/version"

NUMBER_WORDS = {
  0 => "Zero", 1 => "One", 2 => "Two", 3 => "Three", 4 => "Four", 5 => "Five",
  6 => "Six", 7 => "Seven", 8 => "Eight", 9 => "Nine", 10 => "Ten",
  11 => "Eleven", 12 => "Twelve", 13 => "Thirteen", 14 => "Fourteen",
  15 => "Fifteen", 16 => "Sixteen", 17 => "Seventeen", 18 => "Eighteen",
  19 => "Nineteen", 20 => "Twenty", 30 => "Thirty", 40 => "Forty",
  50 => "Fifty", 60 => "Sixty", 70 => "Seventy", 80 => "Eighty", 90 => "Ninety"
}.freeze

# This module provides methods to convert numbers to words using the Indian numbering system.
# It can be included in the Integer and Float classes.
module IndianNumToWords
  class Error < StandardError; end

  def to_indian_word
    return "Minus #{(-self).to_indian_word}" if negative?

    return integer_to_words(self) if is_a?(Integer)

    float_to_words(self) if is_a?(Float)
  end

  private

  def float_to_words(number)
    whole, decimal = number.to_s.split(".")
    words = integer_to_words(whole.to_i)
    unless decimal.to_i.zero?
      decimal_words = decimal.chars.map { |d| NUMBER_WORDS[d.to_i] }.join(" ")
      words += " Point #{decimal_words}"
    end
    words
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def integer_to_words(number)
    return NUMBER_WORDS[number] if number < 100 && (NUMBER_WORDS.key?(number) || (number % 10).zero?)

    case number
    when 0 then "Zero"
    when 1..99 then small_number_to_words(number)
    when 100..999 then hundreds_to_words(number)
    when 1_000..99_999 then thousands_to_words(number)
    when 100_000..9_999_999 then lakhs_to_words(number)
    else crores_to_words(number)
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def small_number_to_words(number)
    return NUMBER_WORDS[number] if number < 20 || (number % 10).zero?

    tens, ones = number.divmod(10)
    [NUMBER_WORDS[tens * 10], NUMBER_WORDS[ones]].compact.join(" ")
  end

  def hundreds_to_words(number)
    hundreds, remainder = number.divmod(100)
    parts = ["#{NUMBER_WORDS[hundreds]} Hundred"]
    parts << integer_to_words(remainder) unless remainder.zero?
    parts.join(" and ")
  end

  def thousands_to_words(number)
    thousands, remainder = number.divmod(1_000)
    parts = ["#{integer_to_words(thousands)} Thousand"]
    parts << integer_to_words(remainder) unless remainder.zero?
    parts.join(", ")
  end

  def lakhs_to_words(number)
    lakhs, remainder = number.divmod(100_000)
    parts = ["#{integer_to_words(lakhs)} Lakh"]
    parts << integer_to_words(remainder) unless remainder.zero?
    parts.join(", ")
  end

  def crores_to_words(number)
    crores, remainder = number.divmod(10_000_000)
    parts = ["#{integer_to_words(crores)} Crore"]
    parts << integer_to_words(remainder) unless remainder.zero?
    parts.join(", ")
  end
end

Integer.include IndianNumToWords
Float.include IndianNumToWords
