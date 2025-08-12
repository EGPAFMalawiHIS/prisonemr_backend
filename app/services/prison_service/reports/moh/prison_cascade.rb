# frozen_string_literal: true

module PrisonService
  module Reports
    module Moh
      # Prison Cascade report
      class PrisonCascade
        include PrisonService::Reports::PrisonReportBuilder
        attr_accessor :start_date, :end_date
        DATE_INITIATED_ART = 'Start date 1st line ARV'
        ART_NUMBER = 'Art number'
        NEXT_SCHEDULED_VISIT = 'Next scheduled visit',
        CURRENT_REGIMEN = 'ARV regimen type'
        TYPE_OF_MMD = 'Type of message'
        VIRAL_LOAD_ELIGIBLE = 'Any other blood test'
        DATE_VIRAL_LOAD_COLLECTED = 'Order viral load'
        DATE_OF_NEXT_VIRAL_SAMPLE_COLLECTION = 'Date collected'
        VIRAL_LOAD_RESULTS = 'Viral load'
        VIRAL_LOAD_COPIES = 'Last Viral Load < 1000'
        REGISTRATION = 'Registration date'
        ELIGIBLE_FOR_TESTING = 'HTS Entry Code'
        TEST_OFFERED = 'Testing'
        TEST_ACCEPTED = 'Concept request existing answer'
        TEST_RESULT = 'Lab test result'
        TB_ENTRANTS = 'Screened for Tuberculosis'
        TB_SCREENING_REASON = 'TB screening criteria'
        TB_SCREENED_DATE = 'TB diagnosis date'
        TB_SCREENING_RESULT = 'TB screening'
        TB_LAB_RESULTS = 'TB treatment outcome'
        TB_TREATMENT_STATUS = 'Tb current treatment type'
        STI_PROGRAM = 'STI program'
        TB_INVESTIGATION_TYPE = 'Test type'
        STI_TESTING_DONE  = 'HIV testing done'
        STI_TESTING_RESULT  = 'Result of HIV test'
        STI_TREATMENT_STATUS = 'Treatment status'
        STI_SYMPTOMS = 'STI symptoms'
        CXCA_PROGRAM = 'Cervical cancer'
        CXCA_RESULTS = 'Outcome'
        CXCA_TREATMENT_STATUS = 'Currently in treatment'
        CXCA_TREATMENT = 'Treatment'
        CXCA_TREATMENT_DATE = 'Date collected'
        CXCA_PROCEDURES = 'Procedure type'
        CXCA_SCREEN_TYPE = 'Type'
        CXCA_TREATMENT_START_DATE = 'Start date'
        CXCA_ORDERED_TESTS = 'Tests ordered'
        CXCA_NO_SCREENING_REASON = 'Other reason for not seeking services'
        CXCA_VIA_RESULTS = 'VIA Results'
        CXCA_NEXT_APPOINTMENT_DATE = 'Appointment date'
        CXCA_NO_TREATMENT_REASON = 'Reason treatment stopped comment'
        TB_TPT = 'Tuberculosis Preventive Treatment (TPT)'
        HEPATITIS_B_TESTED = 'Hepatitis test'
        HEPATITIS_B_RESULTS = 'Given lab results'
        HEPATITIS_B_TREATMENT_STARTED = 'Treatment status'
        HEPATITIS_B_REFFERED_FOR_CONFIRMATION = 'Patient referred to another site'
        TEST_REASON = 'Reason for test'
        TESTING_ENCOUNTER = EncounterType.find_by_name('HIV Testing').encounter_type_id
        TAKEN_ARVS_BEFORE = 'Taken ARV before'
        TAKEN_PREP_BEFORE = 'Taken PrEP before'
        TAKEN_PEP_BEFORE = 'Taken PEP before'
        BREASTFEEDING = 'Breastfeeding'
        LINKED_CONCEPT = 'Linked'
        HIV_STATUS = 'HIV status'
        HTS_ACCESS_TYPE = 'HTS Access Type'
        LOCATION_WHERE_TEST_TOOK_PLACE = 'Location where test took place'
        TESTING_DATE = 'Date of general test'

        INDICATORS = [
          { name: 'date_iniated_art', concept: DATE_INITIATED_ART, concept_id: ConceptName.find_by_name(DATE_INITIATED_ART).concept_id, value: 'value_datetime', join: 'LEFT', encounter_type_id: EncounterType.find_by_name('HIV CLINIC REGISTRATION').encounter_type_id },
          { name: 'art_number', concept: ART_NUMBER, concept_id: ConceptName.find_by_name(ART_NUMBER).concept_id, value: 'value_text', join: 'LEFT', encounter_type_id: EncounterType.find_by_name('HIV CLINIC REGISTRATION').encounter_type_id },
          { name: 'current_regimen', concept: CURRENT_REGIMEN, concept_id: ConceptName.find_by_name(CURRENT_REGIMEN).concept_id, value: 'value_text', join: 'LEFT', encounter_type_id: EncounterType.find_by_name('HIV CLINIC REGISTRATION').encounter_type_id},
          { name: 'viral_load_eligiblity', concept: VIRAL_LOAD_ELIGIBLE, concept_id: ConceptName.find_by_name(VIRAL_LOAD_ELIGIBLE).concept_id, value: 'value_text', join: 'LEFT', encounter_type_id: EncounterType.find_by_name('HIV CLINIC REGISTRATION').encounter_type_id},
          { name: 'date_vl_collected', concept: DATE_VIRAL_LOAD_COLLECTED, concept_id: ConceptName.find_by_name(DATE_VIRAL_LOAD_COLLECTED).concept_id, value: 'value_datetime', join: 'LEFT', encounter_type_id: EncounterType.find_by_name('HIV CLINIC REGISTRATION').encounter_type_id },
          { name: 'vl_results', concept: VIRAL_LOAD_RESULTS, concept_id: ConceptName.find_by_name(VIRAL_LOAD_RESULTS).concept_id, value: 'value_text', join: 'LEFT', encounter_type_id: EncounterType.find_by_name('HIV CLINIC REGISTRATION').encounter_type_id },
          { name: 'vl_copies', concept: VIRAL_LOAD_COPIES, concept_id: ConceptName.find_by_name(VIRAL_LOAD_COPIES).concept_id, value: 'value_text', join: 'LEFT', encounter_type_id: EncounterType.find_by_name('HIV CLINIC REGISTRATION').encounter_type_id },
          #{ name: 'next_scheduled_visit', concept: NEXT_SCHEDULED_VISIT, value: 'value_datetime', join: 'LEFT', encounter_name: 'HIV CLINIC REGISTRATION' },
          #{ name: 'type_mmd', concept: TYPE_OF_MMD, value: 'value_text', join: 'LEFT',encounter_name: 'HIV CLINIC REGISTRATION' },
          #{ name: 'next_vl_collection', concept: DATE_OF_NEXT_VIRAL_SAMPLE_COLLECTION,value: 'value_datetime', join: 'LEFT',encounter_name: 'HIV CLINIC REGISTRATION' },
          { name: 'hepatitis_b_tested', concept: HEPATITIS_B_TESTED, concept_id: ConceptName.find_by_name(HEPATITIS_B_TESTED).concept_id, value: 'value_text', join: 'LEFT', encounter_type_id: EncounterType.find_by_name('HIV CLINIC REGISTRATION').encounter_type_id },
          { name: 'hepatitis_b_results', concept: HEPATITIS_B_RESULTS, concept_id: ConceptName.find_by_name(HEPATITIS_B_RESULTS).concept_id, value: 'value_text', join: 'LEFT', encounter_type_id: EncounterType.find_by_name('HIV CLINIC REGISTRATION').encounter_type_id },
          { name: 'hepatitis_b_treatment', concept: HEPATITIS_B_TREATMENT_STARTED, concept_id: ConceptName.find_by_name(HEPATITIS_B_TREATMENT_STARTED).concept_id, value: 'value_text', join: 'LEFT', encounter_type_id: EncounterType.find_by_name('HIV CLINIC REGISTRATION').encounter_type_id },
          { name: 'hepatitis_b_reffered_confirmation', concept: HEPATITIS_B_REFFERED_FOR_CONFIRMATION, concept_id: ConceptName.find_by_name(HEPATITIS_B_REFFERED_FOR_CONFIRMATION).concept_id, value: 'value_text', join: 'LEFT', encounter_type_id: EncounterType.find_by_name('HIV CLINIC REGISTRATION').encounter_type_id },
          { name: 'eligible_for_hts_testing', concept: ELIGIBLE_FOR_TESTING, concept_id: ConceptName.find_by_name(ELIGIBLE_FOR_TESTING).concept_id, value: 'value_text', join: 'LEFT', encounter_type_id: EncounterType.find_by_name('HTS Visit').encounter_type_id },
          { name: 'hts_test_reason', concept: TEST_REASON, concept_id: ConceptName.find_by_name(TEST_REASON).concept_id, value: 'value_text', join: 'LEFT', encounter_type_id: EncounterType.find_by_name('HTS Visit').encounter_type_id },
          { name: 'hts_test_accepted', concept: TEST_ACCEPTED, concept_id: ConceptName.find_by_name(TEST_ACCEPTED).concept_id, value: 'value_text', join: 'LEFT', encounter_type_id: EncounterType.find_by_name('HTS Visit').encounter_type_id },
          { name: 'hts_testing_date', concept: TESTING_DATE, concept_id: ConceptName.find_by_name(TESTING_DATE).concept_id, value: 'value_datetime', join: 'LEFT', encounter_type_id: EncounterType.find_by_name('HTS Visit').encounter_type_id },
          { name: 'hts_test_result', concept: TEST_RESULT, concept_id: ConceptName.find_by_name(TEST_RESULT).concept_id, value: 'value_text', join: 'LEFT', encounter_type_id: EncounterType.find_by_name('HTS Visit').encounter_type_id },
          { name: 'prisoner_test_offered', concept: TEST_OFFERED, concept_id: ConceptName.find_by_name(TEST_OFFERED).concept_id, value: 'value_text', join: 'LEFT', encounter_type_id: EncounterType.find_by_name('HTS Visit').encounter_type_id },
          { name: 'eligible_for_tb_screening', concept: TB_ENTRANTS, concept_id: ConceptName.find_by_name(TB_ENTRANTS).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('TB REGISTRATION').encounter_type_id },
          { name: 'tb_screened_date', concept: TB_SCREENED_DATE, concept_id: ConceptName.find_by_name(TB_SCREENED_DATE).concept_id, value: 'value_datetime', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('TB REGISTRATION').encounter_type_id },
          { name: 'tb_screening_result', concept: TB_SCREENING_RESULT, concept_id: ConceptName.find_by_name(TB_SCREENING_RESULT).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('TB REGISTRATION').encounter_type_id },
          { name: 'tb_investigated', concept: TB_INVESTIGATION_TYPE, concept_id: ConceptName.find_by_name(TB_INVESTIGATION_TYPE).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('TB REGISTRATION').encounter_type_id },
          { name: 'tb_lab_results', concept: TB_LAB_RESULTS, concept_id: ConceptName.find_by_name(TB_LAB_RESULTS).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('TB REGISTRATION').encounter_type_id },
          { name: 'tb_treatment_status', concept: TB_TREATMENT_STATUS, concept_id: ConceptName.find_by_name(TB_TREATMENT_STATUS).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('TB REGISTRATION').encounter_type_id },
          { name: 'tb_screaning_reason', concept: TB_SCREENING_REASON, concept_id: ConceptName.find_by_name(TB_SCREENING_REASON).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('TB REGISTRATION').encounter_type_id },
          { name: 'tb_preventive_therapy_date', concept: TB_TPT, concept_id: ConceptName.find_by_name(TB_TPT).concept_id, value: 'value_datetime', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('TB REGISTRATION').encounter_type_id },
          { name: 'eligible_for_sti_screening', concept: STI_PROGRAM, concept_id: ConceptName.find_by_name(STI_PROGRAM).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('HIV Testing').encounter_type_id },
          { name: 'sti_testing', concept: STI_TESTING_DONE, concept_id: ConceptName.find_by_name(STI_TESTING_DONE).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('HIV Testing').encounter_type_id },
          { name: 'sti_test_results', concept: STI_TESTING_RESULT, concept_id: ConceptName.find_by_name(STI_TESTING_RESULT).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('HIV Testing').encounter_type_id },
          { name: 'sti_symptoms', concept: STI_SYMPTOMS, concept_id: ConceptName.find_by_name(STI_SYMPTOMS).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('HIV Testing').encounter_type_id },
          { name: 'sti_treatment_status', concept: STI_TREATMENT_STATUS, concept_id: ConceptName.find_by_name(STI_TREATMENT_STATUS).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('HIV Testing').encounter_type_id },
          { name: 'sti_testing_reason', concept: TEST_REASON, concept_id: ConceptName.find_by_name(TEST_REASON).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('HIV Testing').encounter_type_id },
          { name: 'cxca_eligible_screening', concept: CXCA_PROGRAM, concept_id: ConceptName.find_by_name(CXCA_PROGRAM).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('CERVICAL CANCER SCREENING').encounter_type_id },
          { name: 'cxa_procedure', concept: CXCA_PROCEDURES, concept_id: ConceptName.find_by_name(CXCA_PROCEDURES).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('CERVICAL CANCER SCREENING').encounter_type_id},
          { name: 'cxca_screening_results', concept: CXCA_RESULTS, concept_id: ConceptName.find_by_name(CXCA_RESULTS).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('CERVICAL CANCER SCREENING').encounter_type_id },
          { name: 'cxca_screened_date', concept: CXCA_TREATMENT_DATE, concept_id: ConceptName.find_by_name(CXCA_TREATMENT_DATE).concept_id, value: 'value_datetime', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('CERVICAL CANCER SCREENING').encounter_type_id },
          { name: 'cxca_treatment_start_date', concept: CXCA_TREATMENT_START_DATE, concept_id: ConceptName.find_by_name(CXCA_TREATMENT_START_DATE).concept_id, value: 'value_datetime', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('CERVICAL CANCER SCREENING').encounter_type_id },
          { name: 'cxa_screen_type', concept: CXCA_SCREEN_TYPE, concept_id: ConceptName.find_by_name(CXCA_SCREEN_TYPE).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('CERVICAL CANCER SCREENING').encounter_type_id },
          { name: 'cxa_ordered_tests', concept: CXCA_ORDERED_TESTS, concept_id: ConceptName.find_by_name(CXCA_ORDERED_TESTS).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('CERVICAL CANCER SCREENING').encounter_type_id },
          { name: 'cxa_no_screening_reason', concept: CXCA_NO_SCREENING_REASON, concept_id: ConceptName.find_by_name(CXCA_NO_SCREENING_REASON).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('CERVICAL CANCER SCREENING').encounter_type_id },
          { name: 'cxa_via_results', concept: CXCA_VIA_RESULTS, concept_id: ConceptName.find_by_name(CXCA_VIA_RESULTS).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('CERVICAL CANCER SCREENING').encounter_type_id },
          { name: 'cxa_treatment_started', concept: CXCA_TREATMENT_STATUS, concept_id: ConceptName.find_by_name(CXCA_TREATMENT_STATUS).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('CERVICAL CANCER SCREENING').encounter_type_id },
          { name: 'cxa_treatment', concept: CXCA_TREATMENT, concept_id: ConceptName.find_by_name(CXCA_TREATMENT).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('CERVICAL CANCER SCREENING').encounter_type_id },
          { name: 'cxca_next_appointment_date', concept: CXCA_NEXT_APPOINTMENT_DATE, concept_id: ConceptName.find_by_name(CXCA_NEXT_APPOINTMENT_DATE).concept_id, value: 'value_datetime', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('CERVICAL CANCER SCREENING').encounter_type_id },
          { name: 'cxca_no_treatment_reason', concept: CXCA_NO_TREATMENT_REASON, concept_id: ConceptName.find_by_name(CXCA_NO_TREATMENT_REASON).concept_id, value: 'value_text', join: 'LEFT',encounter_type_id: EncounterType.find_by_name('CERVICAL CANCER SCREENING').encounter_type_id },




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
              { fifty_five_to_fifty_nine: '55 plus years' },
            ].freeze
        
        def initialize(start_date:, end_date:)
          @start_date = start_date&.to_date&.beginning_of_day
          @end_date = end_date&.to_date&.end_of_day
          @data = {
            'pp_opening_day_quarter' => [], 
            'pp_new_entrants_firstmonth' => [], 
            'pp_new_entrants_secondmonth' => [],
            'pp_new_entrants_thirdmonth' => [],
            'number_of_hiv_new_entrants' => [],
            'number_of_female_inmates' => [],
            'number_of_inmates_screened_via' => [],
            'number_of_hiv_new_entrants_prev_hiv_positive' => [], 
            'number_of_hiv_new_entrants_prev_hiv_negative' => [],
            'number_of_hiv_new_entrants_eligible_for_testing' => [], 
            'number_of_hiv_new_entrants_tested' => [],
            'number_of_hiv_new_entrants_tested_hiv_positive' => [], 
            'number_of_hiv_new_entrants_linked_to_care' => [],
            'number_of_tb_new_entrants'=> [],
            'number_of_new_entrants_screened_for_tb' => [],
            'number_of_new_entrants_presumptive_tb' => [],
            'number_of_new_entrants_investigated_tb' => [],
            'number_of_new_entrants_confirmed_tb' => [],
            'number_of_new_entrants_confirmed_tb_and_ontreatment' => [],
            'number_of_sti_new_entrants'=> [],
            'number_of_new_entrants_screened_for_sti' => [],
            'number_of_new_entrants_symptomatic_sti' => [],
            'number_of_new_entrants_sti_symptomatic_hiv_positive' => [],
            'number_of_new_entrants_sti_symptomatic_ontreatment' => [],
            'number_of_inmates_prev_hiv_pos'=>[],
            'number_of_inmates_prev_hiv_onart'=> [],
            'number_of_inmates_known_hiv_negative' => [],
            'number_of_inmates_eligible_for_testing' =>[],
            'number_of_inmates_tested' => [],
            'number_of_inmates_tested_hiv_positive' => [],
            'number_of_inmates_linked_to_care' => [],
            'number_of_tb_inmates_eligible_tb'=> [],
            'number_of_inmates_screened_for_tb' => [],
            'number_of_inmates_presumptive_tb' => [],
            'number_of_inmates_investigated_tb_xray' => [],
            'number_of_inmates_investigated_tb_genexpeert' => [],
            'number_of_inmates_investigated_tb_urine_lam' => [],
            'number_of_inmates_investigated_tb_utra_sound_scan' => [],
            'number_of_inmates_investigated_tb_microscopy' => [],
            'number_of_inmates_diagnosed_by_xray' => [],
            'number_of_inmates_diagnosed_by_genexpert' => [],
            'number_of_inmates_confirmed_by_genexpert' => [],
            'number_of_inmates_confirmed_by_urine_lam' => [],
            'number_of_inmates_diagnosed_by_utra_scan' => [],
            'number_of_inmates_confirmed_by_microscopy' => [],
            'number_of_inmates_confirmed_tb_and_ontreatment' => [],
            'number_of_inmates_ontreatment_hivpositive' => [],
            'number_of_tb_inmates_eligible_cxca'=> [],
            'number_of_inmates_screened_cxca_pos' => [],
            'number_of_inmates_screened_cxca_neg' => [],
            'number_of_inmates_suspected_cxca' => [],
            'number_of_inmates_via_cxca_treated' => [],
            'number_of_inmates_with_large_lesions' => [],
            'number_of_inmates_alive_onart' =>[],
            'number_of_inmates_new_ontpt' =>[],
            'number_of_sti_eligible' =>[],
            'number_of_inmates_screened_for_sti'=> [],
            'number_of_inmates_symptomatic_sti' =>[],
            'number_of_inmates_genital_ud'=>[],
            'number_of_urethral_discharge' => [],
            'number_of_abdominal_virginal_discharge'=> [],
            'number_of_lower_abdominal_pain' => [],
            'number_of_ano_rectal_presentations' => [],
            'number_of_syphilis' => [],
            'number_of_sti_balanitis' => [],
            'number_of_sti_bubo' => [],
            'number_of_sti_acute_scrotal_swelling' => [],
            'number_of_treated_sti' => [],
            'sti_inmates_tested_hiv_positive' =>[],
            'inmates_tested_hb' =>[],
            'inmates_hb_negative' =>[],
            'inmates_hb_positive' =>[],
            'hb_inmates_referred' =>[],
            'hb_inmates_confirmed' =>[],
            'hb_inmates_treatement' =>[],
            'hb_inmates_hiv_positive' =>[],
            'inmates_on_dtg_regimen' =>[],
            'vl_onart' => [],
            'viral_expected' => [],
            'eligible_vl' =>[],
            'vl_sample_collected' => [],
            'vl_sample_with_results' => [],
            'vl_sample_less_thousand_copies' => [],
            'vl_sample_ldl_results' => [],
            'vl_sample_hvl_results' => [],
            'enrolled_eac' => [],
            'inmates_exiting_prison' => [],
            'exited_tested_hiv' => [],
            'exited_test_hiv_pstv' => [],
            'exited_linked_treatment' => [],
            'exited_test_tb' => [],
            'exited_diagnosed_tb' => [],
            'exited_test_hpb' => [],
            'exited_test_hpb_pstv' => [],
            'exited_test_sti' => [],
            'exited_test_sti_symptomatic' => [],
            'exited_test_sti_symptomatic_treatment' => [],
          }
        end



        def data
          init_report
          fetch_prison_population
          track_hiv_screening_services
          track_tb_entrants_screened
          track_sti_entrants_screened
          track_all_tb_screened_inmates
          track_cervical_screening_services
          track_tb_preventive_therapy_inmates
          track_sti_inmates_screened
          track_hepatitis_b_inmates
          track_viral_load_inmates
          track_exited_inmates
          set_unique
        end

        private
   
        def init_report
           @allprisoners = prison_population_entrants
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

        def fetch_prison_population
              quarter_start = @start_date.beginning_of_quarter
              opening_population = @allprisoners.select do |person|
                  next false unless person["prison_entry_date"].present?
                  Date.parse(person["prison_entry_date"]) <= quarter_start rescue false
              end
            @data["pp_opening_day_quarter"] = disaggregate_by_age_and_gender(opening_population)

            entrants = @allprisoners.select do |person|
                  next false unless person["prison_entry_date"].present?
                  d = Date.parse(person["prison_entry_date"]) rescue nil
                  d && d >= quarter_start && d <= @end_date
            end

            first_month_range = quarter_start..quarter_start.end_of_month
            second_month_range = quarter_start.next_month.beginning_of_month..quarter_start.next_month.end_of_month
            third_month_range = quarter_start.next_month.next_month.beginning_of_month..quarter_start.next_month.next_month.end_of_month
            
            first_month = entrants.select do |p|
                next false unless p["prison_entry_date"].present?
                    d = Date.parse(p["prison_entry_date"]) rescue nil
                    d && first_month_range.cover?(d)
            end

            second_month = entrants.select do |p|
              next false unless p["prison_entry_date"].present?
              d = Date.parse(p["prison_entry_date"]) rescue nil
              d && second_month_range.cover?(d)
            end

            third_month = entrants.select do |p|
               next false unless p["prison_entry_date"].present?
               d = Date.parse(p["prison_entry_date"]) rescue nil
               d && third_month_range.cover?(d)
            end

           @data["pp_new_entrants_firstmonth"] = disaggregate_by_age_and_gender(first_month)
           @data["pp_new_entrants_secondmonth"] = disaggregate_by_age_and_gender(second_month)
           @data["pp_new_entrants_thirdmonth"] = disaggregate_by_age_and_gender(third_month)
        end
        def track_hiv_screening_services
          @data['number_of_hiv_new_entrants'] = disaggregate_by_age_and_gender(filter_hash('prisoner_test_offered', 'Yes'))
          @data['number_of_hiv_new_entrants_prev_hiv_positive'] = disaggregate_by_age_and_gender(filter_hash('hiv_status_at_entry', 'KP'))
          @data['number_of_hiv_new_entrants_prev_hiv_negative'] = disaggregate_by_age_and_gender(filter_hash('hiv_status_at_entry', 'KN'))
          @data['number_of_hiv_new_entrants_eligible_for_testing'] = disaggregate_by_age_and_gender(filter_hash('eligible_for_hts_testing', 'Yes'))
          @data['number_of_hiv_new_entrants_tested'] = disaggregate_by_age_and_gender(filter_hash('hts_test_accepted', 'Yes'))
          @data['number_of_hiv_new_entrants_tested_hiv_positive'] = disaggregate_by_age_and_gender(filter_hash('hts_test_result', 'NP'))
          @data['number_of_hiv_new_entrants_linked_to_care'] = disaggregate_by_age_and_gender(
               filter_hash('hts_test_result', 'NP').select do |q|
                q['date_iniated_art'] != nil
            end)
        end

        def track_tb_entrants_screened
          @data['number_of_tb_new_entrants'] = disaggregate_by_age_and_gender(filter_hash('tb_history', 'Yes'))
          @data['number_of_new_entrants_screened_for_tb'] = disaggregate_by_age_and_gender(filter_hash('eligible_for_tb_screening', 'Yes'))
          @data['number_of_new_entrants_presumptive_tb'] = disaggregate_by_age_and_gender(filter_hash('tb_screening_result', 'presumptive'))
          @data['number_of_new_entrants_investigated_tb'] = disaggregate_by_age_and_gender(
             @query.select do |q| q['tb_investigated'] != nil
          end)
          @data['number_of_new_entrants_confirmed_tb'] = disaggregate_by_age_and_gender(filter_hash('tb_lab_results', 'pTB'))
          @data['number_of_new_entrants_confirmed_tb_and_ontreatment'] = disaggregate_by_age_and_gender(filter_hash('tb_treatment_status', 'TB treatment initiated'))
        end

        def track_sti_entrants_screened
          @data['number_of_sti_new_entrants'] = disaggregate_by_age_and_gender(filter_hash('sti_history', 'Yes'))
          @data['number_of_new_entrants_screened_for_sti'] = disaggregate_by_age_and_gender(filter_hash('sti_testing', 'Yes'))
          @data['number_of_new_entrants_symptomatic_sti'] = disaggregate_by_age_and_gender(filter_hash('sti_test_results', 'Positive'))
          @data['number_of_new_entrants_sti_symptomatic_hiv_positive'] = disaggregate_by_age_and_gender(filter_hash('sti_test_results', 'Positive').select do |q|
            q['hiv_status_at_entry'] == "Yes"
          end)
          @data['number_of_new_entrants_sti_symptomatic_ontreatment'] = disaggregate_by_age_and_gender(filter_hash('sti_test_results', 'Positive').select do |q|
            q['sti_treatment_status'] == "Yes" 
          end)
        end

        def track_all_screened_inmates
          @data['number_of_inmates_prev_hiv_pos'] = disaggregate_by_age_and_gender(filter_hash('hiv_status_at_entry', 'Yes'))
          @data['number_of_inmates_prev_hiv_onart'] = disaggregate_by_age_and_gender(filter_hash('art_status_at_registration', 'Yes'))
          @data['number_of_inmates_known_hiv_negative'] = disaggregate_by_age_and_gender(filter_hash('hiv_status_at_entry', 'KN'))
          @data['number_of_inmates_eligible_for_testing'] = disaggregate_by_age_and_gender(filter_hash('eligible_for_hts_testing', 'Yes'))
          @data['number_of_inmates_tested'] = disaggregate_by_age_and_gender(filter_hash('hts_test_accepted', 'Yes'))
          @data['number_of_inmates_tested_hiv_positive'] = disaggregate_by_age_and_gender(filter_hash('hts_test_result', 'NP'))
          @data['number_of_inmates_linked_to_care'] = disaggregate_by_age_and_gender(filter_hash('prisoner_initiated_on_art', 'Yes'))
        end

        def track_all_tb_screened_inmates
             
          @data['number_of_tb_inmates_eligible_tb'] = disaggregate_by_age_and_gender(filter_hash('eligible_for_tb_screening', 'Yes'))
          @data['number_of_inmates_screened_for_tb'] = disaggregate_by_age_and_gender(
            @query.select do |q| q['tb_screened_date'] != nil
          end)
          @data['number_of_inmates_presumptive_tb'] = disaggregate_by_age_and_gender(filter_hash('tb_screening_result', 'presumptive'))
          @data['number_of_inmates_investigated_tb_xray'] = disaggregate_by_age_and_gender(filter_hash('tb_investigated', 'X-ray'))
          @data['number_of_inmates_investigated_tb_genexpeert'] = disaggregate_by_age_and_gender(filter_hash('tb_investigated', 'Gen-Xpert'))
          @data['number_of_inmates_investigated_tb_urine_lam'] = disaggregate_by_age_and_gender(filter_hash('tb_investigated', 'Urine LAM'))
          @data['number_of_inmates_investigated_tb_utra_sound_scan'] = disaggregate_by_age_and_gender(filter_hash('tb_investigated', 'Utra Sound Scan'))
          @data['number_of_inmates_investigated_tb_microscopy'] = disaggregate_by_age_and_gender(filter_hash('tb_investigated', 'Microscopy'))
          @data['number_of_inmates_diagnosed_by_xray'] = disaggregate_by_age_and_gender(filter_hash('tb_investigated', 'X-ray').select do |q|
            q['tb_lab_results'] == 'pTB'
          end) 
          @data['number_of_inmates_diagnosed_by_utra_scan'] = disaggregate_by_age_and_gender(filter_hash('tb_investigated','Utra Sound Scan').select do |q|
            q['tb_lab_results'] == 'pTB'
          end) 
          @data['number_of_inmates_confirmed_by_urine_lam'] = disaggregate_by_age_and_gender(filter_hash('tb_investigated', 'Urine LAM').select do |q|
            q['tb_lab_results'] == 'pTB'
          end) 
          @data['number_of_inmates_confirmed_by_genexpert'] = disaggregate_by_age_and_gender(filter_hash('tb_investigated', 'Gen-Xpert').select do |q|
            q['tb_lab_results'] == 'pTB'
          end)
          @data['number_of_inmates_confirmed_by_microscopy'] = disaggregate_by_age_and_gender(filter_hash('tb_investigated', 'Microscopy').select do |q|
            q['tb_lab_results'] == 'pTB'
          end)
          @data['number_of_inmates_confirmed_tb_and_ontreatment'] = disaggregate_by_age_and_gender(filter_hash('tb_lab_results', 'pTB').select do |q|
            q['tb_treatment_status'] == 'TB treatment initiated'
          end)
          @data['number_of_inmates_ontreatment_hivpositive'] = disaggregate_by_age_and_gender(filter_hash('tb_history', 'Yes').select do |q|
            q['hiv_status_at_entry'] == 'Yes'
          end)

        end

        def track_cervical_screening_services
           @data['number_of_female_inmates'] = disaggregate_by_age_and_gender(@allprisoners.select do |person|
                person['gender'] == 'F'
            end)
           @data['number_of_tb_inmates_eligible_cxca'] = disaggregate_by_age_and_gender(filter_hash('cxca_eligible_screening', 'Yes'))
           @data['number_of_inmates_screened_via'] = disaggregate_by_age_and_gender(filter_hash('cxa_procedure', 'VIA').select do |q|
               q['gender'] == 'F'
          end)
           @data['number_of_inmates_screened_cxca_pos'] = disaggregate_by_age_and_gender(filter_hash('cxa_procedure', 'VIA').select do |q|
               q['cxca_screening_results'] == 'Positive' && q['gender'] == 'F'
          end)
          @data['number_of_inmates_screened_cxca_neg'] = disaggregate_by_age_and_gender(filter_hash('cxa_procedure', 'VIA').select do |q|
              q['cxca_screening_results'] == 'Negative' && q['gender'] == 'F'
          end)
          @data['number_of_inmates_suspected_cxca'] = disaggregate_by_age_and_gender(filter_hash('cxca_screening_results', 'Suspected Cancer').select do |q|
               q['gender'] == 'F'
          end)
          @data['number_of_inmates_via_cxca_treated'] = disaggregate_by_age_and_gender(filter_hash('cxa_procedure', 'VIA').select do |q|
              q['gender'] == 'F' && q['cxca_treatment_start_date'] != nil
          end)
          @data['number_of_inmates_with_large_lesions'] = disaggregate_by_age_and_gender(filter_hash('cxa_via_results', 'Large lesion').select do |q|
               q['gender'] == 'F'
          end)
        end

        def track_tb_preventive_therapy_inmates
            categorized_patients = categorize_tpt_patients
            @data['number_of_inmates_alive_onart'] = disaggregate_by_age_and_gender(
                 @query.select do |q| q['date_iniated_art'] != nil 
            end)
            @data['number_of_inmates_new_ontpt'] = disaggregate_by_age_and_gender(categorized_patients[:new_ontpt]) 
            @data['number_of_inmates_cont_tpt'] = disaggregate_by_age_and_gender(categorized_patients[:cont_tpt])
            @data['number_of_inmates_completed_tpt'] = disaggregate_by_age_and_gender(
                    categorized_patients[:cont_tpt].select do |data|
                          @data['number_of_inmates_presumptive_tb'].include?(data[:person_id]) 
                    end
            )
        end

        def track_sti_inmates_screened
          categorized_symptoms = captured_sti_symptoms
          @data['number_of_sti_eligible'] = disaggregate_by_age_and_gender(filter_hash('eligible_for_sti_screening', 'Yes'))
          @data['number_of_inmates_screened_for_sti'] = disaggregate_by_age_and_gender(filter_hash('sti_testing', 'Yes'))
          @data['number_of_inmates_symptomatic_sti'] = disaggregate_by_age_and_gender(filter_hash('sti_test_results', 'Positive'))
          @data['number_of_inmates_genital_ud'] = disaggregate_by_age_and_gender(categorized_symptoms[:sti_genital]) 
          @data['number_of_urethral_discharge'] = disaggregate_by_age_and_gender(categorized_symptoms[:sti_urethral])
          @data['number_of_abdominal_virginal_discharge'] = disaggregate_by_age_and_gender(categorized_symptoms[:sti_abnormal]) 
          @data['number_of_lower_abdominal_pain'] =  disaggregate_by_age_and_gender(categorized_symptoms[:sti_abnormal]) 
          @data['number_of_ano_rectal_presentations'] = disaggregate_by_age_and_gender(categorized_symptoms[:sti_rectal]) 
          @data['number_of_syphilis'] = disaggregate_by_age_and_gender(categorized_symptoms[:sti_syphilis]) 
          @data['number_of_sti_balanitis'] = disaggregate_by_age_and_gender(categorized_symptoms[:sti_balanitis]) 
          @data['number_of_sti_bubo'] = disaggregate_by_age_and_gender(categorized_symptoms[:sti_bubo]) 
          @data['number_of_sti_acute_scrotal_swelling'] = disaggregate_by_age_and_gender(categorized_symptoms[:sti_scrotal])
          @data['sti_inmates_tested_hiv_positive'] = disaggregate_by_age_and_gender(filter_hash('sti_test_results', 'Positive').select do |q|
                q['hts_test_result'] == 'NP'
           end)
          @data['number_of_treated_sti'] = disaggregate_by_age_and_gender(filter_hash('sti_treatment_status', 'Yes'))
        end

        def track_hepatitis_b_inmates
          @data['inmates_tested_hb'] = disaggregate_by_age_and_gender(filter_hash('hepatitis_b_tested', 'Yes'))
          @data['inmates_hb_positive'] = disaggregate_by_age_and_gender(filter_hash('hepatitis_b_results', 'Positive'))
          @data['inmates_hb_negative'] = disaggregate_by_age_and_gender(filter_hash('hepatitis_b_results', 'Negative'))
          @data['hb_inmates_treatement'] = disaggregate_by_age_and_gender(filter_hash('hepatitis_b_treatment', 'Yes'))
          @data['hb_inmates_referred'] = disaggregate_by_age_and_gender(filter_hash('hepatitis_b_reffered_confirmation', 'Yes'))
          @data['hb_inmates_confirmed'] = disaggregate_by_age_and_gender(filter_hash('hepatitis_b_results', 'Positive'))
          @data['hb_inmates_hiv_positive'] = disaggregate_by_age_and_gender(filter_hash('hepatitis_b_results', 'Positive').select do |q|
            q['hts_test_result'] == 'NP'
          end)
          @data['inmates_on_dtg_regimen'] = disaggregate_by_age_and_gender(
            @query.select do |q| ["12A", "13A", "14A", "15A"].include?(q["current_regimen"])
          end)
        end

        def track_viral_load_inmates
          @data['vl_onart'] = disaggregate_by_age_and_gender(
            @query.select do |q| q['date_iniated_art'] != nil 
          end)
          @data['eligible_vl'] = disaggregate_by_age_and_gender(filter_hash('viral_load_eligiblity', 'Yes'))
          @data['viral_expected'] = disaggregate_by_age_and_gender(filter_hash('viral_load_eligiblity', 'Yes'))
          @data['vl_sample_collected'] = disaggregate_by_age_and_gender(
            @query.select do |q| q['date_vl_collected'] != nil 
          end)
          @data['vl_sample_with_results'] = disaggregate_by_age_and_gender(
            @query.select do |q| q['vl_results'] != nil 
          end)
          @data['vl_sample_less_thousand_copies'] = disaggregate_by_age_and_gender(
             @query.select { |q| q['vl_copies'].to_i < 1000 }
          )
          @data['vl_sample_ldl_results'] = disaggregate_by_age_and_gender(filter_hash('vl_results', 'LDL'))
          @data['vl_sample_hvl_results'] = disaggregate_by_age_and_gender(filter_hash('vl_results', 'HVL'))
          @data['enrolled_eac'] = disaggregate_by_age_and_gender(
            @query.select { |q| q['vl_copies'].to_i > 1000 }
          )
        end

        def track_exited_inmates
            #data = exited_patients
            #@data['inmates_exiting_prison'] = disaggregate_by_age_and_gender(
             # @query.select do |q|
               # data.any? { |t| t[:person_id].to_i == q["person_id"].to_i }
            #end)
            @data['inmates_exiting_prison'] = disaggregate_by_age_and_gender(filter_hash('sti_testing_reason', 'Exit'))
            @data['exited_tested_hiv'] = disaggregate_by_age_and_gender(
               filter_hash('hts_test_accepted', 'Yes').select do |q|
                q['hts_test_reason'] == 'Exit'
            end)
            @data['exited_test_hiv_pstv'] = disaggregate_by_age_and_gender(
               filter_hash('hts_test_accepted', 'Yes').select do |q|
                q['hts_test_reason'] == 'Exit' && q['hts_test_result'] == 'NP'
            end)

            @data['exited_linked_treatment'] = disaggregate_by_age_and_gender(
               filter_hash('sti_testing_reason', 'Exit').select do |q|
                q['date_iniated_art'] != nil
            end)
            @data['exited_test_tb'] = disaggregate_by_age_and_gender(filter_hash('tb_screaning_reason', 'Exit'))
            @data['exited_diagnosed_tb'] = disaggregate_by_age_and_gender(filter_hash('tb_screaning_reason', 'Exit').select do |q|
              q['tb_lab_results'] == 'pTB'
            end)

            @data['exited_test_hpb'] = disaggregate_by_age_and_gender(filter_hash('sti_testing_reason', 'Exit').select do |q|
              q['hepatitis_b_tested'] == 'Yes'
            end)

            @data['exited_test_hpb_pstv'] = disaggregate_by_age_and_gender(filter_hash('sti_testing_reason', 'Exit').select do |q|
              q['hepatitis_b_results'] == 'Positive'
            end)
            @data['exited_test_sti'] = disaggregate_by_age_and_gender(filter_hash('sti_testing_reason', 'Exit'))
            @data['exited_test_sti_symptomatic'] = disaggregate_by_age_and_gender(filter_hash('sti_testing_reason', 'Exit').select do |q|
                  q['sti_symptoms'] != nil
            end)
            @data['exited_test_sti_symptomatic_treatment'] = disaggregate_by_age_and_gender(filter_hash('sti_testing_reason', 'Exit').select do |q|
              q['sti_treatment_status'] == 'Yes'
            end)
        end

        def exited_patients
          exited = []
          Person.where(death_date: @start_date..@end_date, dead: 1)
                .where.not(cause_of_death: ConceptName.find_by_name('Died').concept_id)
                .pluck(:person_id, :gender, :birthdate, :cause_of_death)
                .each do |person_id, gender, birthdate, cause_of_death|
                  exited << {
                    person_id: person_id,
                    gender: gender,
                    birthdate: birthdate,
                    exit_reason: ConceptName.find_by_concept_id(cause_of_death).name
                  }
                end
          exited          
        end

        def prison_population_entrants
             entry_date_type = PersonAttributeType.find_by_name('Entry Date')

              Person.joins("INNER JOIN person_attribute pa ON pa.person_id = person.person_id
                         AND pa.person_attribute_type_id = #{entry_date_type.id}")
                 .where.not(birthdate: [nil])
                 .pluck(:person_id, :gender, :birthdate, :value)
                 .map do |person_id, gender, birthdate, value|
                {
                   "person_id" => person_id,
                      "gender" => gender,
                   "birthdate" => birthdate,
                   "prison_entry_date" => value
                 }
              end
        end

        def captured_sti_symptoms
             genital, urethral, abnormal, lower, rectal, syphilis, balanitis, bubo, scrotal = Array.new(9) { [] }
             @query.select do |q| 
               if q['sti_symptoms'] != nil 
                   genital << q if q['sti_symptoms'].include?("Genital Ulcer Disease")
                  urethral << q if q['sti_symptoms'].include?("Urethral Discharge")
                  abnormal << q if q['sti_symptoms'].include?("Abnormal Vaginal Discharge")
                     lower << q if q['sti_symptoms'].include?("Lower Abdominal Pain")
                    rectal << q if q['sti_symptoms'].include?("Ano-rectal presentations")
                  syphilis << q if q['sti_symptoms'].include?("Syphilis")
                 balanitis << q if q['sti_symptoms'].include?("Balanitis")
                      bubo << q if q['sti_symptoms'].include?("Bubo")
                   scrotal << q if q['sti_symptoms'].include?("Acute Scrotal Swelling")
               end
            end
            { sti_genital: genital, sti_urethral: urethral,
              sti_abnormal: abnormal, sti_lower:lower,
            sti_rectal:rectal,sti_syphilis:syphilis,
           sti_balanitis:balanitis,sti_bubo:bubo,sti_scrotal:scrotal }
        end
        def categorize_tpt_patients
          new_ontpt = []
          cont_tpt = []
        
          @query.each do |q|
            next if q['tb_preventive_therapy_date'].nil?
        
            tpt_dates = tb_preventive_therapy(q['person_id']).pluck(:value_datetime)
            if tpt_dates.one? && (@start_date..@end_date).cover?(tpt_dates.first)
              new_ontpt << q
            elsif tpt_dates.many?
              cont_tpt << q
            end
          end
        
          { new_ontpt: new_ontpt, cont_tpt: cont_tpt }
        end
        
        def tb_preventive_therapy(personId)
           Observation.joins("INNER JOIN encounter ON encounter.voided = 0 AND encounter.patient_id = obs.person_id")
                      .where(obs: { concept_id: concept('Tuberculosis Preventive Treatment (TPT)').concept_id,
                                     person_id: personId },
                                   encounter: {
                          encounter_datetime: ..@end_date,
                              encounter_type: EncounterType.find_by_name('TB REGISTRATION'),
                                  program_id: Program.find_by_name('ART PROGRAM').id
                         })
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
