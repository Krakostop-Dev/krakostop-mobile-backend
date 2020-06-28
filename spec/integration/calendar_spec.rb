require 'swagger_helper'

describe 'Calendar' do
  path '/api/v1/calendar' do
    get 'Fetches attractions for each day' do
      tags 'Calendar'
      produces 'application/json'
      parameter name: :Authorization, in: :header, description: 'Bearer <token>', required: true, schema: { type: :string }
      security [Bearer: {}]

      response '401', 'Cant find user for given token', save_response: true do
        let(:Authorization) { 'Bearer bad_token_here' }
        run_test!
      end

      response '200', 'Returns attractions grupped by day', save_response: true do
        let!(:Authorization) { "Bearer #{Login::JwtEncrypter.new.call(pair.users.first)}" }
        let(:pair) { create(:pair, :with_users) }
        7.times do |i|
            let!(:"day#{i}") { create(:day, :with_attractions) }
        end
        
        run_test!
      end
    end
  end
end
