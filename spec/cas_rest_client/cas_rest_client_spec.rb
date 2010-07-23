require File.dirname(__FILE__) + '/../../lib/cas_rest_client'

options = {:uri => 'http://tst.srv/v1/tickets', 
           :domain => 'locaweb',
           :username => 'lw_tst',
           :password => 'inicial1234'}

describe CasRestClient do

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

  it "should post a resource with cookies" do
    crc = CasRestClient.new(options)
    RestClient.should_receive(:send).with("post", "tst.app", {:opt => :opts}, :cookies => "blabla").and_return("resource")
    crc.instance_variable_set("@cookies", "blabla")
    crc.post("tst.app", {:opt => :opts}).should == "resource"
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

  it "should go after a tgt if none" do
    crc = CasRestClient.new(options)
    RestClient.should_receive(:send).with("get", "tst.app", :cookies => nil).and_raise(RestClient::Request::Unauthorized.new("pan"))
    response = mock()
    response.should_receive(:headers).and_return({:location => "tgt.url"})
    opts = options.dup
    RestClient.should_receive(:post).with(opts.delete(:uri), opts).and_return(response)
    RestClient.should_receive(:post).with("tgt.url", :service => "tst.app").and_return("ticket1")
    response2 = mock()
    response2.should_receive(:cookies).and_return({:cookie1 => "value"})
    RestClient.should_receive(:send).with("get", "tst.app?ticket=ticket1", {}).and_return(response2)
    crc.get("tst.app").should == response2
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
