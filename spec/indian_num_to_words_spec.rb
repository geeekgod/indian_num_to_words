# frozen_string_literal: true

RSpec.describe IndianNumToWords do
  it "has a version number" do
    expect(IndianNumToWords::VERSION).not_to be nil
  end

  # Integer tests
  describe "#to_indian_word - Integer" do
    it "converts single-digit numbers" do
      expect(5.to_indian_word).to eq("Five")
    end

    it "converts double-digit numbers" do
      expect(21.to_indian_word).to eq("Twenty One")
      expect(40.to_indian_word).to eq("Forty")
    end

    it "converts hundreds correctly" do
      expect(105.to_indian_word).to eq("One Hundred and Five")
      expect(200.to_indian_word).to eq("Two Hundred")
    end

    it "converts thousands correctly" do
      expect(1001.to_indian_word).to eq("One Thousand, One")
      expect(2010.to_indian_word).to eq("Two Thousand, Ten")
    end

    it "converts lakhs correctly" do
      expect(100000.to_indian_word).to eq("One Lakh")
      expect(123456.to_indian_word).to eq("One Lakh, Twenty Three Thousand, Four Hundred and Fifty Six")
    end

    it "converts crores correctly" do
      expect(10000000.to_indian_word).to eq("One Crore")
      expect(251000000.to_indian_word).to eq("Twenty Five Crore, Ten Lakh")
    end

    it "handles zero" do
      expect(0.to_indian_word).to eq("Zero")
    end

    it "handles edge cases around boundaries" do
      expect(999.to_indian_word).to eq("Nine Hundred and Ninety Nine")
      expect(1000.to_indian_word).to eq("One Thousand")
      expect(999999.to_indian_word).to eq("Nine Lakh, Ninety Nine Thousand, Nine Hundred and Ninety Nine")
      expect(1000000.to_indian_word).to eq("Ten Lakh")
    end
  end

  # Float tests
  describe "#to_indian_word - Float" do
    it "converts decimal numbers" do
      expect(5.5.to_indian_word).to eq("Five Point Five")
      expect(123.456.to_indian_word).to eq("One Hundred and Twenty Three Point Four Five Six")
    end

    it "converts decimal numbers with zero whole part" do
      expect(0.5.to_indian_word).to eq("Zero Point Five")
    end

    it "converts decimal numbers with zero decimal part" do
      expect(5.0.to_indian_word).to eq("Five")
    end

    it "converts decimal numbers with zero whole and decimal part" do
      expect(0.0.to_indian_word).to eq("Zero")
    end

    it "handles edge cases around boundaries" do
      expect(999999.999.to_indian_word).to eq("Nine Lakh, Ninety Nine Thousand, Nine Hundred and Ninety Nine Point Nine Nine Nine")
    end

    it "handles negative numbers" do
      expect(-5.5.to_indian_word).to eq("Minus Five Point Five")
    end

    it "handles negative zero" do
      expect(-0.0.to_indian_word).to eq("Zero")
    end
  end
end
