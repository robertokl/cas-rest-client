$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

require 'rubygems'
require 'rest_client'
require 'lib/cas_rest_client'