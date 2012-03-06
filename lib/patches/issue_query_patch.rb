module Patches
  module IssueQueryPatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :available_filters, :closed_date
        alias_method_chain :available_filters, :complete_date
        alias_method_chain :available_filters, :translation_language
        alias_method_chain :available_filters, :source_language

        class << self
          alias_method_chain :available_columns, :closed_date
          alias_method_chain :available_columns, :complete_date
          alias_method_chain :available_columns, :translation_language
          alias_method_chain :available_columns, :source_language
          alias_method_chain :available_columns, :attachments_translation_volumes
          alias_method_chain :available_columns, :attachments_translation_rates
          alias_method_chain :available_columns, :attachments_translation_prices
          alias_method_chain :available_columns, :attachments_layout_volumes
          alias_method_chain :available_columns, :attachments_layout_rates
          alias_method_chain :available_columns, :attachments_layout_prices
          alias_method_chain :available_columns, :attachments_prices
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

      def available_filters_with_translation_language
        filters = available_filters_without_translation_language
        filters['translation_language_id'] = {
          :type => :list_optional,
          :order => 1,
          :values => Language.all().map{|language| [language.name, language.id]}
        } unless filters.include? 'translation_language_id'
        filters
      end

      def available_filters_with_source_language
        filters = available_filters_without_source_language
        filters['source_language_id'] = {
          :type => :list_optional,
          :order => 2,
          :values => Language.all().map{|language| [language.name, language.id]}
        } unless filters.include? 'source_language_id'
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

      def available_columns_with_translation_language
        columns = available_columns_without_translation_language
        has_translation_languages = columns.find_all { |column| column.name == :translation_language }
        columns << QueryColumn.new(:translation_language,
          :sortable => "#{Language.table_name}.name",
          :groupable => true,
          :caption => :field_translation_language
        ) unless has_translation_languages.size() > 0
        columns
      end

      def available_columns_with_source_language
        columns = available_columns_without_source_language
        has_source_languages = columns.find_all { |column| column.name == :source_language }
        columns << QueryColumn.new(:source_language,
          :sortable => "#{Language.table_name}.name",
          :groupable => true,
          :caption => :field_source_language
        ) unless has_source_languages.size() > 0
        columns
      end

      def available_columns_with_attachments_translation_volumes
        columns = available_columns_without_attachments_translation_volumes
        has_attachments_translation_volumes = columns.find_all { |column| column.name == :attachments_translation_volumes }
        columns << QueryColumn.new(:attachments_translation_volumes,
          :sortable => false,
          :groupable => true,
          :caption => :field_attachments_translation_volumes
        ) unless has_attachments_translation_volumes.size() > 0
        columns
      end

      def available_columns_with_attachments_translation_rates
        columns = available_columns_without_attachments_translation_rates
        has_attachments_translation_rates = columns.find_all { |column| column.name == :attachments_translation_rates }
        columns << QueryColumn.new(:attachments_translation_rates,
          :sortable => false,
          :groupable => true,
          :caption => :field_attachments_translation_rates
        ) unless has_attachments_translation_rates.size() > 0
        columns
      end

      def available_columns_with_attachments_translation_prices
        columns = available_columns_without_attachments_translation_prices
        has_attachments_translation_prices = columns.find_all { |column| column.name == :attachments_translation_prices }
        columns << QueryColumn.new(:attachments_translation_prices,
          :sortable => false,
          :groupable => true,
          :caption => :field_attachments_translation_prices
        ) unless has_attachments_translation_prices.size() > 0
        columns
      end

      def available_columns_with_attachments_layout_volumes
        columns = available_columns_without_attachments_layout_volumes
        has_attachments_layout_volumes = columns.find_all { |column| column.name == :attachments_layout_volumes }
        columns << QueryColumn.new(:attachments_layout_volumes,
          :sortable => false,
          :groupable => true,
          :caption => :field_attachments_layout_volumes
        ) unless has_attachments_layout_volumes.size() > 0
        columns
      end
      def available_columns_with_attachments_layout_rates
        columns = available_columns_without_attachments_layout_rates
        has_attachments_layout_rates = columns.find_all { |column| column.name == :attachments_layout_rates }
        columns << QueryColumn.new(:attachments_layout_rates,
          :sortable => false,
          :groupable => true,
          :caption => :field_attachments_layout_rates
        ) unless has_attachments_layout_rates.size() > 0
        columns
      end
      def available_columns_with_attachments_layout_prices
        columns = available_columns_without_attachments_layout_prices
        has_attachments_layout_prices = columns.find_all { |column| column.name == :attachments_layout_prices }
        columns << QueryColumn.new(:attachments_layout_prices,
          :sortable => false,
          :groupable => true,
          :caption => :field_attachments_layout_prices
        ) unless has_attachments_layout_prices.size() > 0
        columns
      end
      def available_columns_with_attachments_prices
        columns = available_columns_without_attachments_prices
        has_attachments_prices = columns.find_all { |column| column.name == :attachments_prices }
        columns << QueryColumn.new(:attachments_prices,
          :sortable => false,
          :groupable => true,
          :caption => :field_attachments_prices
        ) unless has_attachments_prices.size() > 0
        columns
      end
    end
  end
end
