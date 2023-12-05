# frozen_string_literal: true

require 'utils/remappable_hash'
require 'zebra_printer/init'
require 'net/http'
require 'timeout'
require 'active_support/inflector'

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
        
        location_id = params.require(:location_id)
        site = PrisonService.count_available_inmates location_id
        render json: site

  end

  def compare_population

  	    site_count = params.require(:inmates) 
  	    location_id = params.require(:location_id)
  	    server_count = PrisonService.count_available_inmates location_id  	       
        render json: server_count.size == site_count.size ? true : false

  end

  def scan_changes

        search_date = params[:last_scanned]
        patients = []
      
        model_names = ["obs","encounters", "patients", "persons","person_names", "person_attributes"]

        model_names.each do |model_name|
        singular_model_name = ActiveSupport::Inflector.singularize(model_name).classify

        model_class = singular_model_name.constantize unless singular_model_name == "Ob"

        model_class = Observation if model_name == 'obs'

        column_name = if model_class == Observation
                          'obs_datetime'
                      else
                          'date_changed'
                      end
  
      next unless model_class.table_exists? # Skip if the table doesn't exist for this model
  
         #results = model_class.where("#{column_name} >= ? OR date_created >= ?", search_date,search_date)
         results = model_class.where("#{column_name} >= ?",search_date)
  
          unless results.empty?
                #puts "Results from #{model_name} table:"
                results.each do |row|         

                    if row[:date_created] != row["#{column_name}"]
                        patients.push(row[:person_id], row[:patient_id]).uniq!
                        puts row.inspect
                    end
               end
          end
     end

     render json: patients.compact!
  

  end
  
end

