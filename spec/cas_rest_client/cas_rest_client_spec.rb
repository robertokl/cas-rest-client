require File.dirname(__FILE__) + '/../../lib/cas_rest_client'

options = {:uri => 'http://tst.srv/v1/tickets', 
           :domain => 'some_domain',
           :username => 'lw_tst',
           :password => 'inicial1234'}

describe CasRestClient do
  
  describe 'Lifecycle' do 
    before :each do
      RestClient.should_receive(:post).and_return(mock(:headers => {:location => "http://tgt_uri.com"}))    
    end

    it "should not get the resource with cookies if specified" do
      crc = CasRestClient.new(options.merge(:use_cookies => false))
      crc.should_receive(:execute_with_tgt)
      crc.should_not_receive(:execute_with_cookie)
      crc.get("xpto")
    end

    it "should get the resource with cookies" do
      crc = CasRestClient.new(options)
      RestClient.should_receive(:send).with("get", "tst.app", :cookies => "blabla").and_return("resource")
      crc.instance_variable_set("@cookies", "blabla")
      crc.get("tst.app").should == "resource"
    end
    
    it "should delete the resource with cookies" do
      crc = CasRestClient.new(options)
      RestClient.should_receive(:send).with("delete", "tst.app", :cookies => "blabla").and_return("resource")
      crc.instance_variable_set("@cookies", "blabla")
      crc.delete("tst.app").should == "resource"
    end

    it "should post a resource with cookies" do
      crc = CasRestClient.new(options)
      RestClient.should_receive(:send).with("post", "tst.app", {:opt => :opts}, :cookies => "blabla").and_return("resource")
      crc.instance_variable_set("@cookies", "blabla")
      crc.post("tst.app", {:opt => :opts}).should == "resource"
    end
    
    it "should put a resource with cookies" do
      crc = CasRestClient.new(options)
      RestClient.should_receive(:send).with("put", "tst.app", {:opt => :opts}, :cookies => "blabla").and_return("resource")
      crc.instance_variable_set("@cookies", "blabla")
      crc.put("tst.app", {:opt => :opts}).should == "resource"
    end

    it "should get the resource with already retrieved tgt if cookie fails" do
      crc = CasRestClient.new(options)
      RestClient.should_receive(:send).with("get", "tst.app", :cookies => nil).and_raise(RestClient::Request::Unauthorized.new("pan"))
      crc.instance_variable_set("@tgt", "tgt.url")
      RestClient.should_receive(:post).with("tgt.url", :service => "tst.app").and_return("ticket1")
      response = mock()
      response.should_receive(:cookies).and_return({:cookie1 => "value"})
      RestClient.should_receive(:send).with("get", "tst.app?ticket=ticket1", {}).and_return(response)
      crc.get("tst.app").should == response
    end

    it "should go after a tgt if existing tgt expires" do
      crc = CasRestClient.new(options.merge(:service => "custom.service"))
      crc.instance_variable_set("@tgt", "tgt.url.old")
      RestClient.should_receive(:send).with("get", "tst.app", :cookies => nil).and_raise(RestClient::Request::Unauthorized.new("pan"))
      RestClient.should_receive(:post).with("tgt.url.old", :service => "custom.service").and_raise(RestClient::ResourceNotFound.new("pan"))
      response = mock()
      response.should_receive(:headers).and_return({:location => "tgt.url.new"})
      opts = options.dup
      RestClient.should_receive(:post).with(opts.delete(:uri), opts).and_return(response)
      RestClient.should_receive(:post).with("tgt.url.new", :service => "custom.service").and_return("ticket1")
      response2 = mock()
      response2.should_receive(:cookies).and_return({:cookie1 => "value"})
      RestClient.should_receive(:send).with("get", "tst.app?ticket=ticket1", {}).and_return(response2)
      crc.get("tst.app").should == response2
    end
  end
  
  describe 'Invalid credentials' do
    it "should raise an Unauthorized exception if credentials are not valid" do
      opts = options.dup
      RestClient.should_receive(:post).with(opts.delete(:uri), opts).and_raise(RestClient::Request::Unauthorized)
      
      lambda{CasRestClient.new(options)}.should raise_error(RestClient::Request::Unauthorized)
    end
  end
  
  describe "config file" do
    it "should read its configuration from config/cas_rest_client.yml if it exists" do
      config = {
        "uri"=>"https://casuri.com/v1/tickets", 
        "service"=>"http://someservice.com/orders", 
        "username"=>"user", 
        "domain"=>"some_domain", 
        "use_cookies"=>false, 
        "password"=>"some_password"
      }
      YAML.should_receive(:load_file).with("config/cas_rest_client.yml").and_return(config)
      mock_header = mock()
      mock_header.should_receive(:headers).and_return({:location => "http://some_location.com"})
      RestClient.should_receive(:post).and_return(mock_header)
      
      client = CasRestClient.new
      
      client_config = client.instance_eval('@cas_opts')
      client_config[:uri].should be_eql("https://casuri.com/v1/tickets")
      client_config[:service].should be_eql("http://someservice.com/orders")
      client_config[:username].should be_eql("user")
      client_config[:domain].should be_eql("some_domain")
      client_config[:use_cookies].should be_eql(false)
      client_config[:password].should be_eql("some_password")
    end
    
    it "should overwrite any parameter from configuration file if a new is specified in the constructor" do
      config = {
        "uri"=>"https://casuri.com/v1/tickets", 
        "service"=>"http://someservice.com/orders", 
        "username"=>"user", 
        "domain"=>"some_domain", 
        "use_cookies"=>false, 
        "password"=>"some_password"
      }
      YAML.should_receive(:load_file).with("config/cas_rest_client.yml").and_return(config)
      mock_header = mock()
      mock_header.should_receive(:headers).and_return({:location => "http://some_location.com"})
      RestClient.should_receive(:post).and_return(mock_header)
      
      client = CasRestClient.new :use_cookies => true, :uri => 'https://otheruri.com/v1/tickets'
      
      client_config = client.instance_eval('@cas_opts')
      client_config[:uri].should be_eql('https://otheruri.com/v1/tickets')
      client_config[:service].should be_eql("http://someservice.com/orders")
      client_config[:username].should be_eql("user")
      client_config[:domain].should be_eql("some_domain")
      client_config[:use_cookies].should be_eql(true)
      client_config[:password].should be_eql("some_password")
    end  
    
    it "should read its configuration from config/cas_rest_client.yml in a Rails app with different Rails envs" do
      config = {"development" => 
        {
          "uri"=>"https://casuri.com/v1/tickets", 
          "service"=>"http://someservice.com/orders", 
          "username"=>"user", 
          "domain"=>"some_domain", 
          "use_cookies"=>false, 
          "password"=>"some_password"
        }
      }
      class Rails
        def self.env
          "development"
        end
      end
      
      YAML.should_receive(:load_file).with("config/cas_rest_client.yml").and_return(config)
      mock_header = mock()
      mock_header.should_receive(:headers).and_return({:location => "http://some_location.com"})
      RestClient.should_receive(:post).and_return(mock_header)
      
      client = CasRestClient.new
      
      client_config = client.instance_eval('@cas_opts')
      client_config[:uri].should be_eql("https://casuri.com/v1/tickets")
      client_config[:service].should be_eql("http://someservice.com/orders")
      client_config[:username].should be_eql("user")
      client_config[:domain].should be_eql("some_domain")
      client_config[:use_cookies].should be_eql(false)
      client_config[:password].should be_eql("some_password")
    end  
  end
end
