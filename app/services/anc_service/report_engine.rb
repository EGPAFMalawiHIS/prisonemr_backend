# frozen_string_literal: true

module AncService
  class ReportEngine
    attr_reader :program

    LOGGER = Rails.logger

    REPORTS = {
      'COHORT' => AncService::Reports::Cohort,
      'MONTHLY' => AncService::Reports::Monthly,
      'ANC_COHORT_DISAGGREGATED' => AncService::Reports::CohortDisaggregated,
      'VISITS' => AncService::Reports::VisitsReport
    }.freeze

    def generate_report(type:, **kwargs)
      call_report_manager(:build_report, type:, **kwargs)
    end

    def find_report(type:, **kwargs)
      call_report_manager(:find_report, type:, **kwargs)
    end

    def cohort_disaggregated(date, start_date)
      start_date = start_date.to_date.beginning_of_month
      end_date = start_date.to_date.end_of_month
      cohort = REPORTS['ANC_COHORT_DISAGGREGATED'].new(type: 'disaggregated',
                                                       name: 'disaggregated', start_date:,
                                                       end_date:, rebuild: false)

      cohort.disaggregated(date, start_date, end_date)
    end

    private

    def call_report_manager(method, type:, **kwargs)
      start_date = kwargs.delete(:start_date)
      end_date = kwargs.delete(:end_date)
      name = kwargs.delete(:name)

      report_manager = REPORTS[type.upcase].new(
        type:, name:, start_date:, end_date:
      )
      method = report_manager.method(method)
      if kwargs.empty?
        method.call
      else
        method.call(**kwargs)
      end
    end
  end
end
