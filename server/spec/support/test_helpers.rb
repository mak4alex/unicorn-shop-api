module TestHelpers

  shared_examples 'with meta data' do
    it { expect(json_response).to have_key(:meta) }
    it { expect(json_response[:meta]).to have_key(:sort) }
    it { expect(json_response[:meta]).to have_key(:pagination) }
    it { expect(json_response[:meta][:pagination]).to have_key(:page) }
    it { expect(json_response[:meta][:pagination]).to have_key(:per_page) }
    it { expect(json_response[:meta][:pagination]).to have_key(:total_pages) }
    it { expect(json_response[:meta][:pagination]).to have_key(:total_objects) }
  end

  shared_examples 'data does not exist' do

    it 'renders the json errors on why the data not showed' do
      response = json_response
      expect(response[:errors]).to include 'Resource not found.'
    end

    it { should respond_with 404 }

  end

  shared_examples 'not authenticate' do

    it 'renders the json errors on why the data could not be accessed' do
      response = json_response
      expect(response[:errors]).to include 'Authorized users only.'
    end

    it { should respond_with 401 }

  end

  shared_examples 'access forbidden' do

    it 'renders the json errors on why the data could not be accessed' do
      response = json_response
      expect(response[:errors]).to include 'Error 403 Access Denied/Forbidden.'
    end

    it { should respond_with 403 }

  end

end