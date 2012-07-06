CasRestClient
===========

A simple HTTP and REST client to interact with services using [CAS](http://www.jasig.org/cas) for authentication. Strongly based on [RestClient](http://github.com/archiloque/rest-client).


### Basic Usage:

The simplest usage is creating an instance of CasRestClient with the credentials for your app and use it every time you need to interact with the CASified application.

    require 'rubygems'  
    require 'cas_rest_client'    

    client = CasRestClient.new :uri => 'https://some-cas-server.com/tickets', :username => 'user', password => 'pass'  

    client.post 'http://service.using.cas', some_xml, :content_type => :xml  

When the CasRestClient instance is created it'll automatically create a Ticket-Granting Ticket (tgt) and use it during its lifetime. If the credentials provided are not valid, a *RestClient::Request::Unauthorized* exception will be raised.


### Passing custom parameters to CAS
You can pass any custom parameter by adding it to the initialization hash. Doing so, CasRestClient will use these parameters to create the Ticket-Granting Ticket on CAS.

For example, to pass a 'domain' custom parameter just add:

    params = {:uri => 'https://some-cas-server.com/tickets', :username => 'user', password => 'pass', :domain => "myDomain"}
    client = CasRestClient.new params

    client.post 'http://service.using.cas', some_xml, :content_type => :xml 


### Custom parameters for the CASified app

Since CasRestClient uses [RestClient](http://github.com/archiloque/rest-client) to make HTTP requests, you can set any parameters that RestClient accepts while interacting with the CASified application.

For example, to pass additional HTTP headers:

    client = CasRestClient.new :uri => 'https://some-cas-server.com/tickets', :username => 'user', password => 'pass'

    headers = {:content_type => 'text/xml', :user_agent => 'my_app', 'Accept-Language' => 'en_US'}  
    client.post 'http://service.using.cas', some_xml, headers


### Additional options
#### :service => 'some_string' (default to CASified app URI)
By default, CasRestClient uses the URI of the CASified app as the *service* parameter to create service tickets. To change this just provide the **:service** param: 

    client = CasRestClient.new :uri => 'https://some-cas-server.com/tickets', :service => "http://my_svc.com"

    client.post 'http://service.using.cas', some_xml, headers

With this example configuration, CasRestClient will always create service tickets for the **http://my_svc.com** service.


#### :ticket_header => "header_name"
By default, the ticket will be sent as a parameter in query string. If you have to send the ticket in the request header you might configure the header name that you want it uses.

    client = CasRestClient.new :uri => 'https://some-cas-server.com/tickets', :ticket_header => "header_name"

    client.post 'http://service.using.cas', some_xml, headers


#### use_cookie => Boolean (default true)
By default, the first time you make a request to the CASified app CasRestClient will save all cookies from the response and give it back in all other requests. This prevents 2 extra CAS requests for every single CASified app request: your application won't need to ask CAS for a new service ticket and the CASified app won't need to check if the ticket is valid.

If you want to prevent this behaviour, just set **:use_cookies** to false:

    client = CasRestClient.new :uri => 'https://some-cas-server.com/tickets', :use_cookies => false

    client.post 'http://service.using.cas', some_xml, headers



### Configuration file
You can place all your CAS auth configuration in a file **config/cas_rest_client.yml**. CasRestClient will look for this file to get its configuration. For example:

    uri: https://some-cas-server.com/tickets  
    domain: some_domain  
    username: some_user  
    password: pass  
    use_cookies: false  

And then:

    CasRestClient.new.post 'http://service.using.cas', some_xml, headers


If you want to override parameters, you just need to pass it when creating the object. The parameter read from **config/cas_rest_client.yml** will be overwritten. For example,

    client = CasRestClient.new :use_cookies => true

will use cookies.

In a Rails app, you can even define parameters according to the current Rails.env:

    development:  
      uri: https://some-cas-server.com/tickets  
      domain: some_domain  
      username: some_user  
      password: pass  
      use_cookies: false  

    test:  
      uri: https://some-test-cas-server.com/tickets  
      domain: test_domain  
      username: test_user  
      password: test_pass  
      use_cookies: true  



### Project info
Written by [Antonio Marques](http://github.com/acmarques) and [Roberto Klein](http://github.com/robertokl). Contributions and feedback are welcomed.

#### Contributions
[Thiago Morello](http://github.com/morellon)
