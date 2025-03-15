# frozen_string_literal: true

module PrisonService
  module Reports
    module Moh
      # Prison Cascade report
      class CxcaReport
        include PrisonService::Reports::PrisonReportBuilder
        attr_accessor :start_date, :end_date
        CXCA_PROGRAM = 'Cervical cancer'
        CXCA_RESULTS = 'Outcome'
        CXCA_TREATMENT_STATUS = 'Currently in treatment'
        CXCA_TREATMENT_DATE = 'Date collected'
        CXCA_PROCEDURES = 'Procedure type'
        CXCA_TREATMENT_START_DATE = 'Start date'

        INDICATORS = [
         
          { name: 'inmates_eligible_cxca_screening', concept: CXCA_PROGRAM, concept_id: ConceptName.find_by_name(CXCA_PROGRAM).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('CERVICAL CANCER SCREENING').encounter_type_id },
          { name: 'inmates_cxa_procedure', concept: CXCA_PROCEDURES, concept_id: ConceptName.find_by_name(CXCA_PROGRAM).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('CERVICAL CANCER SCREENING').encounter_type_id},
          { name: 'inmates_screening_results', concept: CXCA_RESULTS, concept_id: ConceptName.find_by_name(CXCA_RESULTS).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('CERVICAL CANCER SCREENING').encounter_type_id },
          { name: 'inmates_cxca_screened_date', concept: CXCA_TREATMENT_DATE, concept_id: ConceptName.find_by_name(CXCA_TREATMENT_DATE).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('CERVICAL CANCER SCREENING').encounter_type_id },
          { name: 'inmates_cxca_treatment_start_date', concept: CXCA_TREATMENT_START_DATE, concept_id: ConceptName.find_by_name(CXCA_TREATMENT_START_DATE).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('CERVICAL CANCER SCREENING').encounter_type_id },
          # {
          #   name: 'outcome',
          #   concept: 'Antiretroviral status or outcome',
          #   value: 'value_coded',
          #   join: 'LEFT',
          #   max: true
          # }
        ].freeze

        # map prison attributes 
        PERSONAL_ATTRIBUTES = [
          { name: 'current_place_residence', person_attribute_type_id: PersonAttributeType.find_by_name('Current Place Of Residence').person_attribute_type_id },
          { name: 'registration_date', person_attribute_type_id: PersonAttributeType.find_by_name('Registration date').person_attribute_type_id },
          { name: 'prison_entry_date', person_attribute_type_id: PersonAttributeType.find_by_name('Entry Date').person_attribute_type_id },
          { name: 'prisoner_registration_type', person_attribute_type_id: PersonAttributeType.find_by_name('Registration Type').person_attribute_type_id },
          { name: 'prisoner_criminal_number', person_attribute_type_id: PersonAttributeType.find_by_name('Criminal Justice Number').person_attribute_type_id },
          { name: 'hiv_status_at_entry', person_attribute_type_id: PersonAttributeType.find_by_name('HIV status at entry').person_attribute_type_id },
          { name: 'art_status_at_registration', person_attribute_type_id: PersonAttributeType.find_by_name('ART status at registration').person_attribute_type_id },
          { name: 'tb_history', person_attribute_type_id: PersonAttributeType.find_by_name('TB History').person_attribute_type_id },
          { name: 'sti_history', person_attribute_type_id: PersonAttributeType.find_by_name('STI History').person_attribute_type_id },
          { name: 'prisoner_initiated_on_art', person_attribute_type_id: PersonAttributeType.find_by_name('Initiate on ART').person_attribute_type_id }
         ].freeze

        GENDER_TYPES = %w[F M].freeze
        AGE_GROUPS = [
              { one_to_nine: '1-9 years' },
              { ten_to_fourteen: '10-14 years' },
              { fifteen_to_nineteen: '15-19 years' },
              { twenty_to_twenty_four: '20-24 years' },
              { twenty_five_to_twenty_nine: '25-29 years' },
              { thirty_to_thirty_four: '30-34 years' },
              { thirty_five_to_thirty_nine: '35-39 years' },
              { fourty_to_fourty_four: '40-44 years' },
              { fourty_five_to_fourty_nine: '45-49 years' },
              { fifty_to_fifty_four: '50-54 years' },
              { fifty_five_to_fifty_nine: '55-60 years' },
              { sixty_to_sixty_four: '60-64 years' },
              { sixty_five_to_sixty_nine: '65-69 years' },
              { seventy_to_seventy_four: '70-74 years' },
              { seventy_five_to_seventy_nine: '75-79 years' },
              { eighty_to_eighty_four: '80-84 years' },
              { eighty_five_to_eighty_nine: '85-89 years' },
              { ninety_plus: '90+ years' }
            ].freeze
        
        def initialize(start_date:, end_date:)
          @start_date = start_date&.to_date&.beginning_of_day
          @end_date = end_date&.to_date&.end_of_day
          @data = {
            'first_screen' => [], 
            'rescreen' => [],
            'followup_screen' => [], 
            'cxca_eligible'=> [],
            'cxca_positive' => [],
            'cxca_negative' => [],
            'suspected_cxca' => [],
            'cxca_treated_sameday' => [],            
            'cxca_on_leep' => [],
            'inmates_on_thermocoagulation' => [],
            'inmates_on_cryotherapy'=> [],
            'inmates_suspected_cxca' => [],
          }
        end



        def data
          init_report
          track_cervical_screening_services
          set_unique
        end

        private
   
        def init_report
           @query = his_patients_revs(INDICATORS)
           query_person_attributes(@query)
        end

        def set_unique
          @data.each do |key, gender_data|
            next unless gender_data.is_a?(Hash)
        
            gender_data.each do |gender, age_ranges|
              next unless age_ranges.is_a?(Hash)
        
              age_ranges.each do |age_range, ids|
                age_ranges[age_range] = ids.is_a?(Array) ? ids.compact.uniq : []
              end
            end
          end
          @data
        end
        

        def filter_hash(key, value)
          return @query.select { |q| q[key[0]] == value && q[key[1]] == value } if key.is_a?(Array)
          @query.select { |q| q[key]&.to_s&.strip&.downcase == value&.to_s&.strip&.downcase }
        end

        def get_diff(obs_time, time_since)
          (obs_time&.to_date&.- time_since&.to_date).to_i
        rescue StandardError
          -1
        end

        def birthdate_to_age(birthdate)
          today = Date.today
          today.year - birthdate.year
        end

        def query_person_attributes(patients)
          person_ids = patients.map { |entry| entry["person_id"] }
          attributes = PersonAttribute.where(person_id: person_ids)
          grouped_attributes = attributes.group_by(&:person_id)
          
          patients.each do |person|
              grouped_attributes[person["person_id"]].each do |obj|
                    
                desired_attribute = PERSONAL_ATTRIBUTES.select { |attribute| attribute[:person_attribute_type_id] == obj[:person_attribute_type_id] }
                   if desired_attribute.present?
                      val = obj[:value]
                      name = desired_attribute[0][:name]
                      person[name] = val
                   end

              end

          end
        end

        def track_cervical_screening_services
           @data['number_of_tb_inmates_eligible_cxca'] = disaggregate_by_age_and_gender(filter_hash('inmates_eligible_cxca_screening', 'Yes'))
           @data['number_of_inmates_screened_cxca_pos'] = disaggregate_by_age_and_gender(filter_hash('inmates_cxa_procedure', 'VIA').select do |q|
               q['inmates_screening_results'] == 'Positive'
          end)
          @data['number_of_inmates_screened_cxca_neg'] = disaggregate_by_age_and_gender(filter_hash('inmates_cxa_procedure', 'VIA').select do |q|
              q['inmates_screening_results'] == 'Negative'
          end)
          @data['number_of_inmates_suspected_cxca'] = disaggregate_by_age_and_gender(filter_hash('inmates_screening_results', 'Suspected Cancer'))
          @data['number_of_inmates_cxca_treated_sameday'] = disaggregate_by_age_and_gender(filter_hash('inmates_cxa_procedure', 'VIA').select do |q|
              q['inmates_screening_results'] == 'Positive' && q['inmates_cxca_screened_date'] == q['inmates_cxca_treatment_start_date']
          end)
        end
        
        def disaggregate_by_age_and_gender(data)
          result = {}
        
          GENDER_TYPES.each do |gender|
            result[gender] = {}
        
            AGE_GROUPS.each do |age_group|
              age_range = age_group.values.first
              age_category = age_group.keys.first
        
              result[gender][age_range] = data.select do |record|
                record['gender'] == gender &&
                  age_in_range?(birthdate_to_age(record['birthdate']), age_category)
              end.map { |entry| entry['person_id'] }
            end
          end
        
          result
        end

        def age_in_range?(age, category)
          case category
          when :one_to_nine
            (1..9).include?(age)
          when :ten_to_fourteen
            (10..14).include?(age)
          when :fifteen_to_nineteen
            (15..19).include?(age)
          when :twenty_to_twenty_four
            (20..24).include?(age)
          when :twenty_five_to_twenty_nine
            (25..29).include?(age)
          when :thirty_to_thirty_four
            (30..34).include?(age)
          when :thirty_five_to_thirty_nine
            (35..39).include?(age)
          when :fourty_to_fourty_four
            (40..44).include?(age)
          when :fourty_five_to_fourty_nine
            (45..49).include?(age)
          when :fifty_to_fifty_four
            (50..54).include?(age)
          when :fifty_five_to_fifty_nine
            age >= 55
          else
            false
          end
        end
        

      end
    end
  end
end
