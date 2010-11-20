require './stoplight'
require 'rubygems'
require 'rspec'
require 'rack/test'

set :environment, :test

describe 'Stoplight' do
  include Rack::Test::Methods
  
  def app
    Sinatra::Application
  end

  it "Think of a name for your app, now think of that name when you see the word 'myapp'" do
  end
  

  describe 'Making an app' do
    it 'Get /myapp when there is nothing registered returns 404' do
        get 'myapp'
        last_response.status.should == 404
    end  
    it "POST /myapp creates an app if there is none (put does this too)" do
        post 'myapp', ''
        last_response.status.should == 200
    end
    it 'Get /myapp when there is something registered returns 200' do
        get 'myapp'
        last_response.status.should == 200
    end  
    it 'Get /myapp when there is something registered but no message returns nil' do
        get 'myapp'
        last_response.body.should == ''
    end  
    it 'PUT /myapp?status=green sets status green ' do
        put 'myapp', :status => 'green'
        last_response.body.should == 'green'      
        get 'myapp'
        last_response.body.should == 'green'
    end    
    it 'PUT /myapp?status=yellow sets status yellow' do
      put 'myapp', :status => 'yellow'
      last_response.body.should == 'yellow'      
      get 'myapp'
      last_response.body.should == 'yellow'
    end
    it 'PUT /myapp?status=red sets status red' do
      put 'myapp', :status => 'red'
      last_response.body.should == 'red'      
      get 'myapp'
      last_response.body.should == 'red'
    end
    it 'DELETE /myapp deletes an app' do
      delete 'myapp'
      last_response.status.should == 200
      get 'myapp'
      last_response.status.should == 404      
    end
  end
end