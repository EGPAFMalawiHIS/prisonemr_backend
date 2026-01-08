# frozen_string_literal: true
require 'csv'
require 'set'
module PrisonService
    class PrisonManager
      def self.get_all_registered_inmates
        new.available_inmates
        #set_unique
      end
  
      def available_inmates
        @start_date = Date.parse("2022-01-01").beginning_of_day
        @end_date = Time.now.end_of_day
  
        personal_attributes = load_personal_attributes

        # Query to fetch patients along with person attributes
        patients = Patient.joins(person: :person_attributes)
                          .joins("INNER JOIN person_name ON person_name.person_id = person.person_id")
                          .joins("INNER JOIN patient_identifier ON patient_identifier.patient_id = patient.patient_id")
                          .joins("INNER JOIN patient_program ON patient_program.patient_id = patient.patient_id")
                          .joins("LEFT JOIN patient_state ON patient_state.patient_program_id = patient_program.patient_program_id")
                          .where("patient_state.patient_program_id IS NULL")
                          .select(
                                   'patient.patient_id',
                                   'person_name.given_name',
                                   'person_name.family_name',
                                   'person.gender AS sex',
                                   'person.birthdate',
                                   'patient_identifier.identifier AS inmate_identifier',
                                   'GROUP_CONCAT(person_attribute.person_attribute_type_id, ":", person_attribute.value) AS attributes'
                                )
                            .where(patient_program: { program_id: Program.find_by_name('ART PROGRAM').id },patient:{voided:0})
                            .where.not(person:{ birthdate: nil, voided: 1, dead: 1})
                            .group('patient.patient_id, person_name.given_name, person_name.family_name, 
                                    person.gender, person.birthdate, patient_identifier.identifier')
      grouped_patients = patients.map do |record|
            attributes = record[:attributes].split(',').each_with_object({}) do |attr, hash|
              type_id, value = attr.split(':')
              attribute = personal_attributes.find { |a| a[:person_attribute_type_id] == type_id.to_i }
              hash[attribute[:name]] = value if attribute
            end
          
            # Build patient data
            {
              id: record.patient_id,
              firstname: record.given_name,
              familyname: record.family_name,
              gender: record.sex,
              birthdate: record.birthdate,
              prisoner_identifier: record.inmate_identifier,
              **attributes
            }
          end

          unique_grouped_patients = grouped_patients.group_by { |obj| obj[:id] }.map do |_, group|
             group.max_by { |obj| richness_score(obj) }
          end
         

          unique_grouped_patients
      end
  
      private

      def richness_score(obj)
        obj.values.count { |value| !value.to_s.strip.empty? }
      end
  
      def load_personal_attributes
        [
          { name: 'current_place_residence', person_attribute_type_id: find_attribute_id('Current Place Of Residence') },
          { name: 'registration_date', person_attribute_type_id: find_attribute_id('Registration date') },
          { name: 'prison_entry_date', person_attribute_type_id: find_attribute_id('Entry Date') },
          { name: 'prisoner_registration_type', person_attribute_type_id: find_attribute_id('Registration Type') },
          { name: 'prisoner_criminal_number', person_attribute_type_id: find_attribute_id('Criminal Justice Number') },
          { name: 'prisoner_cell_number', person_attribute_type_id: find_attribute_id('Cell Number') }
        ]
      end
  
      def find_attribute_id(attribute_name)
        PersonAttributeType.find_by_name(attribute_name)&.person_attribute_type_id
      end
    end
  end
  
  
  

=begin

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
end

=end
