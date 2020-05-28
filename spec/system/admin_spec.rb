# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin', type: :system, js: true do
  let(:admin) { create(:admin) }

  before { sign_in admin }

  context 'when displaying the main page' do
    it 'have access to admin section' do
      visit root_path
      expect(page).to have_text('Admin')
      click_on 'Admin', match: :first
      expect(page).to have_current_path(admin_index_path)
      expect(page).to have_text('Administration')
    end
  end
end
