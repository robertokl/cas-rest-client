CASRestClient
===========

A simple HTTP and REST client to interact with services using CAS authentication.


### Basic Usage:

The simplest usage is to create a singleton with the credentials for your application and use it every time you need to interact with the cas-protected application.

>require 'rubygems'  
require 'cas_rest_client'    

>client = CasRestClient.new :uri => 'https://some-cas-server.com/tickets', :username => 'user', password => 'pass'  

>client.post 'http://service.using.cas', some_xml, :content_type => :xml  

### Custom parameters for cas
You can pass to cas ticket granting ticket url any custom parameters by adding them to the instantiation hash (the domain parameter on the example):

>require 'rubygems'  
require 'cas_rest_client'
  
>client = CasRestClient.new :uri => 'https://some-cas-server.com/tickets', :username => 'user', password => 'pass', :domain => "myDomain"

>client.post 'http://service.using.cas', some_xml, :content_type => :xml 

### Custom parameters for the cas-protected application

When making a request to the cas-protected application, you can set any parameters that [RestClient](http://github.com/adamwiggins/rest-client) can accept.

### Gem options
#### service => String
If the cas-protected application use a fixed service for all request, you can set this option on the client instantiation. Otherwise, the gem will use the same requested URI as the ticket retrival service.
#### use_cookie => Boolean (default true)
By default, the first time you call the cas-protected application the gem will save all cookies in the response and give it back on all other requests. This will prevent 2 extra request for every request: your application won't need to ask cas for a ticket and the cas-protected application won't need to check if the ticket is valid.
