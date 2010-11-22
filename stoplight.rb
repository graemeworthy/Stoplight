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
    secret = params[:secret]
 
    return 404 unless @myapp
    return 410 if  @myapp && secret && @myapp['secret'] == nil
    return 403 if  @myapp && secret && @myapp['secret'] != secret 
    @myapp[:status] 
end

post '/:myapp' do
    myapp = params[:myapp]
    secret = params[:secret]
    setup(params[:myapp])
    return 403 if @myapp && @myapp['secret'] != nil && @myapp['secret'] != secret
    return 410 if @myapp && secret && @myapp['secret'] == nil
 
    @myapp ||= @@apps[@name] = {}   
   
    if secret

        @myapp['secret'] = secret
        return 201
    end
    return 200
end

put '/:myapp' do
   setup(params[:myapp])
   secret = params[:secret]
   if (secret && !@myapp)
       @myapp = @@apps[@name] = {}
       @myapp['secret'] = secret
   else 
       @myapp ||= @@apps[@name] = {}        
   end
   return 403 if @myapp['secret'] && @myapp['secret'] != secret
   return 410 if secret && @myapp['secret'] == nil
 
  case params[:status]
   when 'green'
       @myapp[:status] = 'green'
   when 'yellow'
       @myapp[:status] = 'yellow'
   when 'red'
       @myapp[:status] = 'red'
   else
       return 400
   end
   @myapp[:status]
end

delete '/:myapp' do
   setup(params[:myapp])
   secret = params[:secret]
   return 403 if  @myapp['secret'] && @myapp['secret'] != secret
   return 410 if  @myapp && secret && @myapp['secret'] == nil
 
    @@apps.delete @name
    return 200
end

class Stoplight
  @@apps = {}
  def initialize()
  end

end
