# frozen_string_literal: true

require 'utils/remappable_hash'
require 'zebra_printer/init'
require 'net/http'
require 'timeout'

class Api::V1::PrisonController < ApplicationController
  skip_before_action :authenticate, only: %i[print_label]

 
  def ping_google

         result = 404
         timeout_duration = 10
         http = Net::HTTP.new('www.google.com', 80)
         http.read_timeout = timeout_duration


        begin
                 response = Timeout.timeout(timeout_duration) do
                    http.get('/')
                 end
               
                # Check the response
               if response.code == '200'
                   result = 200
               else
                   result = 404
               end
            
              rescue Timeout::Error

                 result = 404

              rescue StandardError => e
                 puts "An error occurred: #{e.message}"
       end    

    render json: result

  end
  
  def population
        
        location_id = params.require(:location_id)
        site = PrisonService.count_available_inmates location_id
        render json: site

  end

  def compare_population

  	    site_count = params.require(:total) 
  	    location_id = params.require(:location_id)
  	    server_count = PrisonService.count_available_inmates location_id  	       
        render json: server_count == site_count ? true : false

  end


  
end

