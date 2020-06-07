# frozen_string_literal: true

module Market
  module Cart
    module SessionMixin
      extend ActiveSupport::Concern

      included do
        def set_cart
          @cart = ::Market::Cart::Cart.new(session)
        end
      end
    end

    class Cart
      include Enumerable

      def initialize(session)
        @session = session
        @session[:cart] ||= {}
      end

      def clear
        @session[:cart] = {}
        @session.delete :cart_updated
      end

      def signature
        Digest::MD5.hexdigest(@session[:cart_updated].to_s)
      end

      def empty?
        @session[:cart].empty?
      end

      def present?(item_id)
        @session[:cart].key? item_id
      end

      def quantity(item_id)
        @session[:cart][item_id] || 0
      end

      def add(item_id)
        mark_update
        self[item_id] = quantity(item_id) + 1
      end

      def remove(item_id)
        mark_update
        qty = quantity(item_id) - 1
        if qty.positive?
          self[item_id] = qty
        else
          @session[:cart].delete(item_id)
          0
        end
      end

      def each(&block)
        cart = @session[:cart]
        if block_given?
          cart.each(&block)
        else
          cart.to_enum(__method__)
        end
      end

      def <<(item_id)
        add(item_id)
        self
      end

      def [](item_id)
        quantity(item_id)
      end

      private

      def []=(item_id, value)
        @session[:cart][item_id] = value
      end

      def mark_update
        @session[:cart_updated] = DateTime.now
      end
    end
  end
end
