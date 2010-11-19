require 'rubygems'
require 'sinatra' 
require 'erubis'

@@apps = {}

def setup(app)
    @@apps
    @name = app
    @myapp = @@apps[@name]
end
get "/" do
  erb :index
end

get "/all" do
  erb :all, :locals => {:apps => @@apps}
end

get '/*/front' do
  @name =  params[:splat][0]
  erb :front, :locals => {:name => @name}
  
end       


get '/:myapp' do
    setup(params[:myapp])
    return 404 unless @myapp
    @myapp[:status] 
end

post '/:myapp' do 
    setup(params[:myapp])
    @myapp ||= @@apps[@name] = {}   
    return 200
end

put '/:myapp' do
   setup(params[:myapp])
   @myapp ||= @@apps[@name] = {}   
  
   case params[:status]
   when 'green'
       @myapp[:status] = 'green'
   when 'red'
       @myapp[:status] = 'red'
   else
       return 400
   end
   @myapp[:status]
end

delete '/:myapp' do
   setup(params[:myapp])
    'deleting ' + params[:myapp]
    @@apps[@name] = {}
    return 200
end
