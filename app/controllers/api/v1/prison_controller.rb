# frozen_string_literal: true

require 'utils/remappable_hash'
require 'zebra_printer/init'
require 'net/http'
require 'timeout'

class Api::V1::PrisonController < ApplicationController
 
   def ping_google

         url = URI.parse('http://www.google.com')
        http = Net::HTTP.new(url.host, url.port)
        http.open_timeout = 10
        http.read_timeout = 10
        result = 404

        begin
              response = http.get(url.request_uri)

             result = 200 if response.code == '200'
             rescue Net::OpenTimeout, Net::ReadTimeout
             rescue StandardError => e
             puts "An error occurred: #{e.message}"
        end

          render json: result

   end
  
  def population
        
        location_id = params.require(:location_id).permit!.values
        site = PrisonService.count_available_inmates location_id
        render json: site

  end

  def compare_population

  	    site_count = params.require(:inmates).permit!.values 
  	    location_id = params.require(:location_id).permit!.values
  	    server_count = PrisonService.count_available_inmates location_id  	       
        render json: server_count.size == site_count.size ? true : false

  end


  
end

