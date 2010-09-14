$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

require 'rubygems'
require 'rest_client'
require 'yaml'
require 'cas_rest_client/cas_rest_client.rb'