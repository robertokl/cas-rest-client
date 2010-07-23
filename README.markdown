# CAS Rest Client #

### Gem para integração com serviços sob autenticação do CAS ###

**CasRestClient** automatiza o [workflow de geração de tickets no CAS](http://confluence.locaweb.com.br/display/TEC0004/Creating+an+order) e fornece uma interface simples para a geração de tickets de serviço para sistemas sob autenticação do CAS.

### Uso
$ irb  
ree > require 'rubygems'  
 => true  
ree > require 'require 'cas_rest_client''  
 => true   
ree > client = CasRestClient.new :uri => 'https://auth.fabrica.locaweb.com.br/v1/tickets', :domain => 'locaweb', :username => 'user', :password => 'inicial1234', :service => "http://service.with.cas"  
 =>  #<CasRestClient:0x10163b418>
ree >  client.post 'http://service.with.cas', xml, :content_type => :xml
 => ""  


### Instalação e configuração
**Usando Bundler**  
Basta adicionar a seguinte linha ao Gemfile:  
*gem 'cas_rest_client', '= 2.0', :git => 'git://git.locaweb.com.br/cas-rest-client/cas-rest-client.git'*

**Instalando a gem no sistema**  
git clone git://git.locaweb.com.br/cas-rest-client/cas-rest-client.git
cd cas-rest-client
rake gem  
cd pkg  
gem install cas-rest-client-2.0.gem  
 