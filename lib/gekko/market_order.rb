module Gekko

  #
  # Represents a market order. If a bid, it must specify the maximum spendable quote
  # currency as remaining quote margin
  #
  class MarketOrder < Order

    attr_accessor :quote_margin, :remaining_quote_margin, :max_precision

    def initialize(side, id, size, quote_margin, expiration = nil)
      super(side, id, size, expiration)

      @quote_margin           = quote_margin
      @remaining_quote_margin = @quote_margin

      if bid?
        quote_margin.nil? && raise('Quote currency margin must be provided for a market bid')
      elsif ask?
        size.nil? && raise('Size must be provided for a market ask')
      end
    end

    #
    # Returns +true+ if the order is filled
    #
    def filled?
      max_precision ||
        (!size.nil? && remaining.zero?) ||
        (!quote_margin.nil? && remaining_quote_margin.zero?)
    end

    #
    # Returns +true+ if the order has been filled or can not keep
    # executing further due to quote currency margin constraints
    #
    def done?
      filled? ||
        (bid? && remaining_quote_margin.zero?)
    end

  end
end

