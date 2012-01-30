module IssueQueryPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method_chain :available_filters, :closed_date
      alias_method_chain :available_filters, :complete_date

      class << self
        alias_method_chain :available_columns, :closed_date
        alias_method_chain :available_columns, :complete_date
      end
    end
  end

  module InstanceMethods
    def available_filters_with_closed_date
      filters = available_filters_without_closed_date
      filters['closed_date'] = {:type => :date, :order => 7} unless filters.include? 'closed_date'
      filters
    end

    def available_filters_with_complete_date
      filters = available_filters_without_complete_date
      filters['complete_date'] = {:type => :date, :order => 8} unless filters.include? 'complete_date'
      filters
    end
  end

  module ClassMethods
    def available_columns_with_closed_date
      columns = available_columns_without_closed_date
      has_date_closed = columns.find_all { |column| column.name == :closed_date }
      columns << QueryColumn.new(:closed_date, :sortable => "#{Issue.table_name}.closed_date", :groupable => true, :caption => :field_closed_date) unless has_date_closed.size() > 0
      columns
    end

    def available_columns_with_complete_date
      columns = available_columns_without_complete_date
      has_date_completed = columns.find_all { |column| column.name == :complete_date }
      columns << QueryColumn.new(:complete_date, :sortable => "#{Issue.table_name}.complete_date", :groupable => true, :caption => :field_complete_date) unless has_date_completed.size() > 0
      columns
    end
  end
end
