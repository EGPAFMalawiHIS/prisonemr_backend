# frozen_string_literal: true

module ArtService
  module Reports
    # Returns all patients alive and on treatment within a given
    # time period (Tx Curr).
    class PatientsAliveAndOnTreatment
      attr_accessor :start_date, :end_date

      include ArtService::Constants

      def initialize(start_date:, end_date:, **_kwargs)
        @start_date = start_date
        @end_date = end_date
      end

      def find_report
        query.map(&:patient_id)
      end

      def query
        PatientState.joins(:patient_program)
                    .where(patient_program: { program_id: PROGRAM_ID },
                           state: States::ON_ANTIRETROVIRALS)
                    .where('start_date <= ? AND (end_date >= ? OR end_date IS NULL)', start_date, end_date)
                    .select(:patient_id)
      end
    end
  end
end
