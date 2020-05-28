# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  context 'when created' do
    it 'must have the user role' do
      expect(user.has_role?(:user)).to be true
    end
  end
end
