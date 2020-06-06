# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User', type: :system, js: true do
  let(:user) { create(:user) }
  let!(:products) { create_list(:product, 10) }

  before { sign_in user }

  it 'cant add a new product' do
    visit new_product_path
    expect(page).to have_text('You are not authorized to perform this action.')
    expect(page).to have_current_path(root_path)
  end

  context 'when displaying the main page' do
    let(:test_product) { products[rand(0...products.size)] }

    before { visit root_path }

    it 'does not have access to admin section' do
      expect(page).not_to have_text('Admin')
      visit admin_index_path
      expect(page).to have_text('You are not authorized to perform this action.')
      expect(page).to have_current_path(root_path)
    end

    it 'can add/remove a product to/from his cart' do
      within("div#product-#{test_product.id}") do
        find("a[href='#{add_product_cart_index_path(id: test_product.id)}']").click
        expect(accept_alert).to eql("Your cart contains now 1 x product [#{test_product.name}].")
      end

      visit root_path

      within("div#product-#{test_product.id}") do
        find("a[href='#{remove_product_cart_index_path(id: test_product.id)}']").click
        expect(accept_alert).to eql("Product [#{test_product.name}] was removed from your cart.")
      end
    end

    it 'cant checkout an empty cart' do
      click_on 'Cart'
      expect(page).to have_current_path(root_path)
      expect(page).to have_text('Your cart is empty. Choose some product first.')
    end

    # TODO: cart content checks
    it 'can checkout his cart' do
      within("div#product-#{test_product.id}") do
        find("a[href='#{add_product_cart_index_path(id: test_product.id)}']").click
        expect(accept_alert).to eql("Your cart contains now 1 x product [#{test_product.name}].")
      end

      click_on 'Cart'
      expect(page).to have_current_path(cart_index_path)
      expect(page).to have_text('Cart content')

      select '14-16', from: 'Delivery hour range'
      now = Date.current
      fill_in 'delivery_date', with: (Date.current + (now.cwday > 5 ? 9 : 7).days).strftime('%Y-%m-%d')

      click_on 'Validate order'
      expect(page).to have_current_path(root_path)

      click_on 'Cart'
      expect(page).to have_text('Your cart is empty. Choose some product first.')
    end
  end
end
