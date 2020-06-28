require 'swagger_helper'

describe 'Locations' do
  path '/api/v1/locations' do
    post 'Creates new location for pair' do
      tags 'Location'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, description: 'Bearer <token>', required: true, schema: { type: :string }
      parameter name: :data, in: :body, required: true, schema: {
        type: :object,
        properties: {
          lat: { type: :string },
          lng: { type: :string }
        },
        required: %w[lat lng]
      }

      response '401', 'Cant find user for given token', save_response: true do
        let(:data) { { lat: '-15.19750', lng: '108.35723' } }
        let(:Authorization) { 'Bearer bad_token_here' }
        run_test!
      end

      response '200', 'Pair already finished race, location not created' do
        let(:data) { { lat: '-15.19750', lng: '108.35723' } }
        let!(:user1) { create(:user, pair: pair) }
        let!(:user2) { create(:user, pair: pair) }
        let(:pair) { create(:pair, pair_nr: 2, finished: true) }

        let(:Authorization) { "Bearer #{Login::JwtEncrypter.new.call(user1)}" }

        it 'doesnt create location', save: :data, save_response: true do |example|
          submit_request(example.metadata)
          expect(Location.count).to eq(0)
          assert_response_matches_metadata(example.metadata)
        end

        it 'keeps pair finished as true' do |example|
          submit_request(example.metadata)
          pair.reload
          expect(pair.finished?).to be_truthy
          assert_response_matches_metadata(example.metadata)
        end
      end

      response '201', 'Location created' do
        let!(:user1) { create(:user, pair: pair) }
        let!(:user2) { create(:user, pair: pair) }
        let(:pair) { create(:pair, pair_nr: 2, finished: false) }

        let(:Authorization) { "Bearer #{Login::JwtEncrypter.new.call(user1)}" }
        ENV['FINISH_COORDINATES'] = '50.3525805,19.5614186'

        context 'When new location is within finished race threshold' do
          let(:data) { { lat: '50.3525805', lng: '19.5603243' } }

          it 'creates new location', save: :data, save_response: true do |example|
            submit_request(example.metadata)
            expect(Location.first).to have_attributes(
              lat: data[:lat].to_d,
              lng: data[:lng].to_d
            )
            assert_response_matches_metadata(example.metadata)
          end

          it 'updates pair finished to true' do |example|
            submit_request(example.metadata)
            pair.reload
            expect(pair.finished?).to be_truthy
            assert_response_matches_metadata(example.metadata)
          end
        end

        context 'When new location is beyond finished race threshold' do
          let(:data) { { lat: '-15.19750', lng: '108.35723' } }

          it 'creates new location', save: :data, save_response: true do |example|
            submit_request(example.metadata)
            expect(Location.first).to have_attributes(
              lat: data[:lat].to_d,
              lng: data[:lng].to_d
            )
            assert_response_matches_metadata(example.metadata)
          end

          it 'keeps pair finished as false' do |example|
            submit_request(example.metadata)
            pair.reload
            expect(pair.finished?).to be_falsey
            assert_response_matches_metadata(example.metadata)
          end
        end
      end
    end
  end

  path '/api/v1/locations/latest' do
    get 'Fetches last location for each pair' do
      tags 'Location'
      produces 'application/json'
      parameter name: :Authorization, in: :header, description: 'Bearer <token>', required: true, schema: { type: :string }
      security [Bearer: {}]

      response '401', 'Cant find user for given token', save_response: true do
        let(:Authorization) { 'Bearer bad_token_here' }
        run_test!
      end

      response '200', 'Returns locations sorted by ranking ASC', save_response: true do
        let!(:Authorization) { "Bearer #{Login::JwtEncrypter.new.call(pair.users.first)}" }
        let(:pair) { create(:pair, :with_users, :with_locations,) }

        run_test!
      end
    end
  end
end
