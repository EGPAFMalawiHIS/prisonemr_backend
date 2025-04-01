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
        CSV.foreach("./public/databaseupdated.csv",headers:true) do |row|
             status = row[0]
        end

        return if status != 200

        CSV.open("#{Rails.root}/public/next_appointment.csv", "wb") do |csv|
          csv << ["obs_id", "concept_id", "encounter_id", "value_datetime", "value_text"]
           Observation.joins("INNER JOIN encounter ON encounter.voided = 0 AND encounter.patient_id = obs.person_id")
                      .joins("INNER JOIN encounter_type ON  encounter_type.encounter_type_id = encounter.encounter_type")
                      .where(obs: { concept_id: 5096 },
                       encounter: {  encounter_type: EncounterType.find_by_name('HIV CLINIC REGISTRATION'),
                      program_id: Program.find_by_name('ART PROGRAM').id
                      }).each do |q|
                                       csv << [q[:obs_id],q[:concept_id],q[:encounter_id],q[:value_datetime],q[:value_text]]
                              end
        end

        CSV.open("#{Rails.root}/public/current_regimen.csv", "wb") do |csv|
          csv << ["obs_id", "concept_id", "encounter_id", "value_datetime", "value_text"]
           Observation.joins("INNER JOIN encounter ON encounter.voided = 0 AND encounter.patient_id = obs.person_id")
                      .joins("INNER JOIN encounter_type ON  encounter_type.encounter_type_id = encounter.encounter_type")
                      .where(obs: { concept_id: 6882 },
                       encounter: {  encounter_type: EncounterType.find_by_name('HIV CLINIC REGISTRATION'),
                      program_id: Program.find_by_name('ART PROGRAM').id
                      }).each do |q|
                                       csv << [q[:obs_id],q[:concept_id],q[:encounter_id],q[:value_datetime],q[:value_text]]
                              end
        end

        CSV.foreach("./public/current_regimen.csv",headers:true) do |row|                   
                         
                  available = Observation.find_by_obs_id(row[0])                      
                 if available.present?
                     available.concept_id = 5096
                     available.save
                end
        end


        CSV.foreach("./public/next_appointment.csv",headers:true) do |row|                   
                         
            available = Observation.find_by_obs_id(row[0])                      
          if available.present?
                   
                  if row[3] != nil
                    date = Date.parse(row[3])
                    if date.is_a?(Date)
                       available.concept_id = 5096
                       available.save
                    end
                  
                  else
                      available.concept_id = 6882
                      available.save
                  end
          end
       end


       Observation.joins("INNER JOIN encounter ON encounter.voided = 0 AND encounter.patient_id = obs.person_id")
                  .joins("INNER JOIN encounter_type ON  encounter_type.encounter_type_id = encounter.encounter_type")
                  .where(obs: { concept_id: 1786 },
                       encounter: {  encounter_type: EncounterType.find_by_name('CERVICAL CANCER SCREENING'),
                      program_id: Program.find_by_name('ART PROGRAM').id
                      }).each do |q|
                                  q[:concept_id] = 9881;
                                  q.save
                       end
        
            Observation.joins("INNER JOIN encounter ON encounter.voided = 0 AND encounter.patient_id = obs.person_id")
                       .joins("INNER JOIN encounter_type ON  encounter_type.encounter_type_id = encounter.encounter_type")
                       .where(obs: { concept_id: 9881 },
                            encounter: {  encounter_type: EncounterType.find_by_name('HIV testing'),
                           program_id: Program.find_by_name('ART PROGRAM').id
                           }).each do |q|
                                       q[:concept_id] = 1786;
                                       q.save
                            end

       CSV.open("#{Rails.root}/public/databaseupdated.csv", "wb") do |csv|
                csv << ["Updated"]
                csv << [201]
       end


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
