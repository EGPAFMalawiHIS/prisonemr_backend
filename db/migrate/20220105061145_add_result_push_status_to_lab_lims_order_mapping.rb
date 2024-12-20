# frozen_string_literal: true

# migration to add a column to the lim order mapping
class AddResultPushStatusToLabLimsOrderMapping < ActiveRecord::Migration[5.2]
  def change
    unless column_exists?(:lab_lims_order_mappings, :result_push_status)
      add_column :lab_lims_order_mappings, :result_push_status, :boolean, default: false
    end
  end
end

