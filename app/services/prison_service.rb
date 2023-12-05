# frozen_string_literal: true
require 'csv'

class PrisonService

  def self.count_available_inmates(location_id)

         return  Patient.joins('INNER JOIN patient_identifier ON patient_identifier.patient_id = patient.patient_id
                                INNER JOIN person ON person.person_id = patient_identifier.patient_id
                                INNER JOIN person_name ON person_name.person_id = person.person_id')
                        .where(patient_identifier:{location_id:location_id,identifier_type:3})
                        .select("person.person_id pid,person.gender sex,person.birthdate dob,person_name.given_name fname,person_name.family_name lname")
                        .map do |client| 
                                               
                                 {
                                     firstname:client.fname,
                                     lastname:client.lname,
                                     birthdate:client.dob,
                                     gender:client.sex,
                                     person_id:client.pid

                                 }                                           

                    end               
    
  end

  def create_person_unique_identifier(person,person_attributes)

     
        file = Rails.root.join("./public/mapping_table.csv")
        unless File.exist?(file)
            CSV.open("#{file}", "wb") do |csv|
                csv << ['local_person_id','location','remote_person_id']                 
            end
        end

        if person_attributes.has_key?('local_person_id')

            CSV.open("#{file}", "a+") do |csv|
              
                    csv.add_row([person_attributes[:local_person_id],person_attributes[:prison_name],person.person_id])  
            end

        end
    

  end


  

end
