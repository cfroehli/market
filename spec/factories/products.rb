# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product_#{n}" }
    price { rand(1000..10000) }
    description { "Product #{name} description" }
    order { rand(0...10) }
  end
end
