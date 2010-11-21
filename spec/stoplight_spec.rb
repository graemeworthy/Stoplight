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
  describe 'The security model' do
      
      it 'should let you lock a stoplight' do
      end
      it 'POST /myapp?secret=something makes a stoplight that requires a key' do
          post 'myapp', :secret => 'something'
          put  'myapp', :status => 'green'
          last_response.status.should == 403
      end
      it 'PUT /myapp?secret=something&status=green makes a stoplight that requires a key' do
          delete 'myapp', :secret => 'something'
          put 'myapp', :status => 'green', :secret => 'something'
          put 'myapp', :status => 'red'
          get 'myapp'
          last_response.body.should == 'green'

      end
      describe 'the locked stoplight' do
          before(:all) do
              delete 'myapp', :secret => 'something'
              post 'myapp', :secret => 'something'
          end
          after(:all) do
          #    delete 'myapp', :secret => 'something'
          end
          it 'should not accept puts without the key' do
              put 'myapp', :status => 'green'
              last_response.status.should == 403
              get 'myapp'
              last_response.body.should == ''
          end
          it 'should accept puts with the key' do
              put 'myapp', {:status => 'green', :secret => 'something'}
              last_response.status.should == 200
              get 'myapp'
              last_response.body.should == 'green'
          end
          it 'should accept GET without the key' do
              get 'myapp'
              last_response.body.should == 'green'
          end
          it 'should accept GET with the key' do
              get 'myapp', :secret => 'something'
              last_response.body.should == 'green'

          end
          it 'should not accept delete without the key' do
              delete 'myapp'
              last_response.status.should == 403
              get 'myapp'
              last_response.body.should == 'green'

          end
          it 'should accept delete with the key' do
              delete 'myapp', :secret => 'something'
              last_response.status.should == 200
              get 'myapp'
              last_response.body.should == ''

          end
      end
      describe 'using a lock on something unlocked' do
        before(:all) do
             post 'myapp'
        end
        after(:all) do
             delete 'myapp'
        end
        it 'should return a 410 GONE on a put' do
              put 'myapp', {:status => 'green', :secret => 'something'}
              last_response.status.should == 410
        end

        it 'should return a 410 GONE on a post' do            
              post 'myapp', {:secret => 'something'}
              last_response.status.should == 410
        end
        it 'should return a 410 GONE on a delete' do
            
              delete 'myapp', {:secret => 'something'}
              last_response.status.should == 410
        end
        it 'should return a 410 GONE on a get' do

              get 'myapp', {:secret => 'something'}
              last_response.status.should == 410
        end
      end
      describe 'using a lock on something with a different lock' do
        before(:all) do
            post 'myapp', :secret => 'goodsecret'
        end
        after(:all) do
            delete 'myapp', :secret => 'goodsecret'
        end
        it 'should return a 403 FORBIDDEN on a put' do
            put 'myapp', :secret => 'badsecret', :status => 'green'
            last_response.status.should == 403
        end

        it 'should return a 403 FORBIDDEN on a post' do
            post 'myapp', :secret => 'badsecret'
            last_response.status.should == 403
        end
            
        it 'should return a 403 FORBIDDEN on a delete' do
            delete 'myapp', :secret => 'badsecret'
            last_response.status.should == 403
        end
            
        it 'should return a 403 FORBIDDEN on a get' do
            get 'myapp', :secret => 'badsecret'
            last_response.status.should == 403
        end
      end
  end
end
