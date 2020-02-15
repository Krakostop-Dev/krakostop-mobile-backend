require 'swagger_helper'

describe 'Login' do
  path '/api/v1/login' do
    post 'Sends verification code' do
      tags 'Login'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :data, in: :body, required: true, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          pair_nr: { type: :integer }
        },
        required: %w[email pair_nr]
      }

      response '200', 'Verification code was sent' do
        let(:data) { { email: 'john@example.org', pair_nr: 2 } }

        before do
          expect_any_instance_of(UserMailer).to receive(:verification_code)
        end

        context 'When user and his pair already existed' do
          let!(:user1) { create(:user, email: 'john@example.org', pair: pair) }
          let!(:user2) { create(:user, pair: pair) }
          let(:pair) { create(:pair, pair_nr: 2) }

          before do
            expect_any_instance_of(Login::DownloadAndCreatePair)
              .not_to receive(:call!)
          end

          it 'doesn\'t download pair data',
             save: :data do |example|
            submit_request(example.metadata)
            assert_response_matches_metadata(example.metadata)
          end
        end

        context 'When user and his pair didn\'t exist' do
          let(:fake_pair_data) do
            {
              nr_pair: 2,
              email1: 'john@example.org',
              email2: 'email2@example.com'
            }
          end

          before do
            expect_any_instance_of(Login::FetchPairData)
              .to receive(:call).and_return(fake_pair_data)
          end

          it 'downloads pair data and creates records', save: :data do |example|
            submit_request(example.metadata)

            pair = Pair.find_by(pair_nr: 2)
            expect(pair).not_to be_nil

            user1 = User.joins(:pair)
                        .find_by(email: 'john@example.org',
                                 pairs: { pair_nr: 2 })
            expect(user1).not_to be_nil

            user2 = User.joins(:pair)
                        .find_by(email: 'email2@example.com',
                                 pairs: { pair_nr: 2 })
            expect(user2).not_to be_nil

            assert_response_matches_metadata(example.metadata)
          end
        end
      end

      response '401', 'Wrong credentials, verification code wasn\'t sent' do
        let(:data) { { email: 'bad_user@example.org', pair_nr: 2 } }

        let(:fake_pair_data) { nil }

        before do
          expect_any_instance_of(UserMailer).not_to receive(:verification_code)
          expect_any_instance_of(Login::FetchPairData)
            .to receive(:call).and_return(fake_pair_data)
        end

        it 'doesn\'t download pair data',
           save: :data,
           save_response: true do |example|
          submit_request(example.metadata)
          assert_response_matches_metadata(example.metadata)
        end
      end

      response '503', 'Error with connection to external api occured,
               verification code wasn\'t sent' do
        let(:data) { { email: 'john@example.org', pair_nr: 2 } }

        before do
          expect_any_instance_of(UserMailer).not_to receive(:verification_code)
          expect(HTTParty).to receive(:get).and_raise(SocketError)
        end

        it 'doesn\'t download pair data',
           save: :data,
           save_response: true do |example|
          submit_request(example.metadata)
          assert_response_matches_metadata(example.metadata)
        end
      end
    end

    patch 'Returns authentication token' do
      tags 'Login'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :data, in: :body, required: true, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          verification_code: { type: :integer }
        },
        required: %w[email pair_nr]
      }

      response '200',
               'Verification code and emails are correct, token is returned' do
        let(:data) do
          { email: 'john@example.org', verification_code: '123456' }
        end

        let!(:user1) do
          create(:user, email: 'john@example.org',
                        pair: pair,
                        verification_code: '123456')
        end
        let!(:user2) { create(:user, pair: pair) }
        let(:pair) { create(:pair, pair_nr: 2) }

        it 'returns token',
           save: :data,
           save_response: true do |example|
          submit_request(example.metadata)
          assert_response_matches_metadata(example.metadata)
        end
      end

      response '401',
               'Verification code and emails are incorrect,
               error is returned' do
        let(:data) do
          { email: 'john@example.org', verification_code: '123456' }
        end

        it 'returns token',
           save: :data,
           save_response: true do |example|
          submit_request(example.metadata)
          assert_response_matches_metadata(example.metadata)
        end
      end
    end
  end
end
