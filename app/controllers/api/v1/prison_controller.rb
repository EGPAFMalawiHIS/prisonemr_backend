# frozen_string_literal: true

require 'utils/remappable_hash'
require 'zebra_printer/init'
require 'net/http'
require 'timeout'
require 'active_support/inflector'
require 'csv'

module Api
  module V1
    class PrisonController < ApplicationController
      def ping_google
        url = URI.parse('http://www.google.com')
        http = Net::HTTP.new(url.host, url.port)
        http.open_timeout = 10
        http.read_timeout = 10
        result = 404
        manageregimendata

        begin
          response = http.get(url.request_uri)

          result = 200 if response.code == '200'
        rescue Net::OpenTimeout, Net::ReadTimeout
        rescue StandardError => e
          puts "An error occurred: #{e.message}"
        end

        render json: result
      end

      def manageregimendata

        status = 200
        
        # Update Zomba Prison to Zomba Central Prison Clinic
        old_zomba_location = Location.find_by(name: "Zomba Prison")
        new_zomba_location = Location.find_by(name: "Zomba Central Prison Clinic")

      if old_zomba_location && new_zomba_location
           PersonAttribute.where(value: "Zomba Prison").find_each do |site|
                     site.update!(value: "Zomba Central Prison Clinic")
        end

        PatientIdentifier.where(location_id: old_zomba_location.location_id).find_each do |site|
                     site.update!(location_id: new_zomba_location.location_id)
        end
      else
         puts "One of the Zomba locations was not found."
      end

       # Update Chichiri Prison to Chichiri Prison Clinic
       old_chichiri_location = Location.find_by(name: "Chichiri Prison")
       new_chichiri_location = Location.find_by(name: "Chichiri Prison Clinic")

      if old_chichiri_location && new_chichiri_location
            PersonAttribute.where(value: "Chichiri Prison").find_each do |site|
                      site.update!(value: "Chichiri Prison Clinic")
             end

          PatientIdentifier.where(location_id: old_chichiri_location.location_id).find_each do |site|
                      site.update!(location_id: new_chichiri_location.location_id)
          end
      else
          puts "One of the Chichiri locations was not found."
      end

        CSV.foreach("./public/databaseupdated.csv",headers:true) do |row|
             status = row[0]
        end

        return if status != 200

      end

      
      def population
        location_id = params.require(:location_id)
        site = PrisonService.count_available_inmates location_id
        render json: site
      end

      def facility_inmates
        site = PrisonService::PrisonManager.get_all_registered_inmates 
        render json: site
      end

      def compare_population
        site_count = params.require(:inmates)
        location_id = params.require(:location_id)
        server_count = PrisonService.count_available_inmates location_id
        render json: server_count.size == site_count.size
      end

      def scan_changes
        search_date = params[:last_scanned]
        patients = []

        model_names = %w[obs encounters patients persons person_names person_attributes]
        model_names.each do |model_name|
          singular_model_name = ActiveSupport::Inflector.singularize(model_name).classify

          model_class = singular_model_name.constantize unless singular_model_name == 'Ob'

          model_class = Observation if model_name == 'obs'

          column_name = if model_class == Observation
                          'obs_datetime'
                        else
                          'date_changed'
                        end

          next unless model_class.table_exists? # Skip if the table doesn't exist for this model

          # results = model_class.where("#{column_name} >= ? OR date_created >= ?", search_date,search_date)
          results = model_class.where("#{column_name} >= ?", search_date)

          next if results.empty?

          # puts "Results from #{model_name} table:"
          results.each do |row|
            if row[:date_created] != row[column_name.to_s]
              patients.push(row[:person_id], row[:patient_id]).uniq!
            end
          end
        end

        render json: patients.compact!
      end
    end
  end
end
