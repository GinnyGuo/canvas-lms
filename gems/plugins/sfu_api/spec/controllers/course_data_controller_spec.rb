require_relative '../spec_helper'

describe CourseDataController, :course_data_mock => true do
  describe 'GET #search' do
    before :each do
      account_with_admin_logged_in
    end

    it 'should be successful' do
      get :search, :term => '9999', :format => :json
      expect(response).to have_http_status(:success)
    end

    it 'should find all courses for the term' do
      get :search, :term => '9999', :format => :json
      expect(json_parse.size).to eq(7)
    end

    it 'should find only TEST courses' do
      get :search, :term => '9999', :query => 'TEST', :format => :json
      expect(json_parse.map { |course| course['name'] }.uniq!).to contain_exactly('TEST')
    end

    it 'should find TEST 100' do
      get :search, :term => '9999', :query => 'test100', :format => :json
      expect(json_parse.first['key']).to eq('9999:::test:::100:::d100:::Test Course 100')
    end

    it 'should find all TEST 300 courses' do
      get :search, :term => '9999', :query => 'test300', :format => :json
      expect(json_parse.size).to eq(2)
    end

    it 'should find TEST 200 by name' do
      get :search, :term => '9999', :query => 'Test Course 200', :format => :json
      expect(json_parse.first['key']).to eq('9999:::test:::200:::d200:::Test Course 200')
    end

    it 'should return no MATH courses' do
      get :search, :term => '9999', :query => 'MATH', :format => :json
      expect(json_parse.size).to eq(0)
    end

    it 'should return name in ALL CAPS' do
      get :search, :term => '9999', :query => 'test355', :format => :json
      expect(json_parse.first['name']).to eq('TEST')
    end

    it 'should return number in ALL CAPS' do
      get :search, :term => '9999', :query => 'test355', :format => :json
      expect(json_parse.first['number']).to eq('355W')
    end

    it 'should return section in ALL CAPS' do
      get :search, :term => '9999', :query => 'test355', :format => :json
      expect(json_parse.first['section']).to eq('D100')
    end

    it 'should return key in the correct capitalization' do
      get :search, :term => '9999', :query => 'test355', :format => :json
      expect(json_parse.first['key']).to eq('9999:::test:::355w:::d100:::Test Course 355w')
    end

    it 'should return sis_source_id in the correct capitalization' do
      get :search, :term => '9999', :query => 'test355', :format => :json
      expect(json_parse.first['sis_source_id']).to eq('9999-test-355w-d100')
    end
  end
end
