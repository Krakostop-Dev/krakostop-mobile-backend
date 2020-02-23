require 'swagger_helper'

describe 'Locations' do
  path '/api/v1/profile' do
    get 'Returns information about current user' do
      tags 'Profile'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :"Authorization", in: :header, description: 'Bearer <token>', required: true, schema: { type: :string }

      response '401', 'Cant find user for given token', save_response: true do
        let(:"Authorization") { "Bearer bad_token_here" }
        run_test!
      end

      response '200', 'Returns serialized current_user' do
        let!(:user1) { create(:user, pair: pair) }
        let!(:user2) { create(:user, pair: pair) }
        let(:pair) { create(:pair, pair_nr: 2, finished: true) }

        let(:"Authorization") { "Bearer #{Login::JwtEncrypter.new.call(user1)}" }

        it 'returns json', save: :data, save_response: true do |example|
          submit_request(example.metadata)
          expect(response.body).to eq(user1.serializable_hash.to_json)
          assert_response_matches_metadata(example.metadata)
        end
      end
    end

    put 'Updates current user attributes' do
      tags 'Profile'
      consumes 'multipart/form-data'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :"Authorization", in: :header, description: 'Bearer <token>', required: true, schema: { type: :string }
      parameter name: :first_name, required: false, in: :formData, schema: { type: :string }
      parameter name: :last_name, required: false, in: :formData, schema: { type: :string }
      parameter name: :phone, required: false, in: :formData, schema: { type: :string }
      parameter name: :city, required: false, in: :formData, schema: { type: :string }
      parameter name: :messenger, required: false, in: :formData, schema: { type: :string }
      parameter name: :avatar, required: false, in: :formData, schema: { type: :string }

      response '401', 'Cant find user for given token', save_response: true do
        let(:first_name) {'lol'}
        let(:last_name) {'lol'}
        let(:phone) {'lol'}
        let(:city) {'lol'}
        let(:messenger) {'lol'}
        let(:"Authorization") { "Bearer bad_token_here" }
        run_test!
      end

      response '200', 'updates and returns current_user json' do
        let(:first_name) {'lol'}
        let(:last_name) {'lol'}
        let(:phone) {'lol'}
        let(:city) {'lol'}
        let(:messenger) {'lol'}
        let(:data) do
          {
            first_name: first_name,
            last_name: last_name,
            phone: phone,
            city: city,
            messenger: messenger
          }
        end


        let!(:user1) { create(:user, pair: pair) }
        let!(:user2) { create(:user, pair: pair) }
        let(:pair) { create(:pair, pair_nr: 2, finished: true) }

        let(:"Authorization") { "Bearer #{Login::JwtEncrypter.new.call(user1)}" }

        it 'returns json', save_response: true do |example|
          submit_request(example.metadata)
          user1.reload

          response_json = JSON.parse(response.body)
          compare_json = JSON.parse(user1.serializable_hash.to_json)
          expect(response_json).to eq(compare_json)
          assert_response_matches_metadata(example.metadata)
        end

        it 'updates basic info', save_response: true do |example|
          submit_request(example.metadata)
          user1.reload
          expect(user1).to have_attributes(data)
          assert_response_matches_metadata(example.metadata)
        end
      end
    end
  end
end
