ENV['RACK_ENV'] ||= "development"

require 'sinatra'
require 'sinatra/reloader' if development?
require File.expand_path("../app", __FILE__)

run Sinatra::Application