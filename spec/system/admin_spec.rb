# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin', type: :system, js: true do
  let!(:user) { create(:user) }
  let!(:product) { create(:product) }
  let(:admin) { create(:admin) }

  before { sign_in admin }

  context 'when displaying the main page' do
    before { visit root_path }

    it 'have access to admin section' do
      expect(page).to have_text('Admin')
      click_on 'Admin', match: :first
      expect(page).to have_current_path(admin_index_path)
      expect(page).to have_text('Administration')
    end

    it 'can add a new product' do
      find("a[href='#{new_product_path}']").click
      expect(page).to have_current_path(new_product_path)
      page.attach_file(Rails.root.join('spec/fixtures/spintop.jpg'), make_visible: true)
      fill_in 'product_name', with: 'new test product'
      fill_in 'product_price', with: rand(1000..10000).to_s
      fill_in 'product_description', with: 'test product description'
      fill_in 'product_order', with: rand(0...10).to_s

      expect do
        click_on 'Submit'
        expect(page).to have_text('new test product')
      end.to change(Product, :count).by(1)
    end

    it 'can edit an existing product' do
      find("a[href='#{edit_product_path(product.id)}']").click
      expect(page).to have_current_path(edit_product_path(product.id))
      new_name = "Renamed #{product.name}"
      fill_in 'product_name', with: new_name
      new_price = product.price + 150
      fill_in 'product_price', with: new_price.to_s
      new_description = "New appealing #{product.name} description"
      fill_in 'product_description', with: new_description
      new_order = (product.order + 1) % 10
      fill_in 'product_order', with: new_order.to_s

      click_on 'Submit'
      expect(page).to have_text(new_name)

      product.reload
      expect(product.name).to eql(new_name)
      expect(product.price).to eql(new_price)
      expect(product.description).to eql(new_description)
      expect(product.order).to eql(new_order)
    end
  end

  context 'when displaying the admin page' do
    before { visit admin_index_path }

    it 'can impersonate a user' do
      user_name = user.username
      expect(page).to have_text("Sign in as #{user_name}")
      click_on user_name, match: :first
      expect(page).to have_current_path(root_path)
      expect(page).not_to have_text('Admin')
      expect(page).to have_text("You are currently signed in as [#{user_name}] - Cancel impersonation")
      click_on 'Cancel impersonation'
      expect(page).not_to have_text('You are currently signed in as')
      expect(page).to have_text('Admin')
    end
  end
end
