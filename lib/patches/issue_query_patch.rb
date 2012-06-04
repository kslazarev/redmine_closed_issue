module Patches
  module IssueQueryPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :available_filters, :closed_date
        alias_method_chain :available_filters, :complete_date
        alias_method_chain :available_filters, :translation_language
        alias_method_chain :available_filters, :source_language
        alias_method_chain :available_filters, :parent_id

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
        alias_method_chain :available_columns, :attachments_volumes

        alias_method_chain :available_columns, :balance_volume
        alias_method_chain :available_columns, :balance_price

        alias_method_chain :available_columns, :id_for_customer
        alias_method_chain :available_columns, :author_id_for_customer
      end
    end

    module InstanceMethods

      def available_filters_with_parent_id
        filters = available_filters_without_closed_date
        filters['parent_id'] = {:type => :integer, :order => 6} unless filters.include? 'parent_id'
        filters
      end

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
          :values => Language.all().map { |language| [language.name, language.id] }
        } unless filters.include? 'translation_language_id'
        filters
      end

      def available_filters_with_source_language
        filters = available_filters_without_source_language
        filters['source_language_id'] = {
          :type => :list_optional,
          :order => 2,
          :values => Language.all().map { |language| [language.name, language.id] }
        } unless filters.include? 'source_language_id'
        filters
      end

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

        allow_view_translation_statistics? do
          has_translation_languages = columns.find_all { |column| column.name == :translation_language }
          columns << QueryColumn.new(:translation_language,
            :sortable => "#{Language.table_name}.name",
            :groupable => true,
            :caption => :field_translation_language
          ) unless has_translation_languages.size() > 0
        end

        columns
      end

      def available_columns_with_source_language
        columns = available_columns_without_source_language

        allow_view_translation_statistics? do
          has_source_languages = columns.find_all { |column| column.name == :source_language }
          columns << QueryColumn.new(:source_language,
            :sortable => "#{Language.table_name}.name",
            :groupable => true,
            :caption => :field_source_language
          ) unless has_source_languages.size() > 0
        end

        columns
      end

      def available_columns_with_attachments_translation_volumes
        columns = available_columns_without_attachments_translation_volumes

        allow_view_translation_statistics? do
          has_attachments_translation_volumes = columns.find_all { |column| column.name == :attachments_translation_volumes }
          columns << QueryColumn.new(:attachments_translation_volumes,
            :sortable => false,
            :groupable => true,
            :caption => :field_attachments_translation_volumes
          ) unless has_attachments_translation_volumes.size() > 0
        end

        columns
      end

      def available_columns_with_attachments_translation_rates
        columns = available_columns_without_attachments_translation_rates

        allow_view_translation_statistics? do
          has_attachments_translation_rates = columns.find_all { |column| column.name == :attachments_translation_rates }
          columns << QueryColumn.new(:attachments_translation_rates,
            :sortable => false,
            :groupable => true,
            :caption => :field_attachments_translation_rates
          ) unless has_attachments_translation_rates.size() > 0
        end
        columns
      end

      def available_columns_with_attachments_translation_prices
        columns = available_columns_without_attachments_translation_prices

        allow_view_translation_statistics? do
          has_attachments_translation_prices = columns.find_all { |column| column.name == :attachments_translation_prices }
          columns << QueryColumn.new(:attachments_translation_prices,
            :sortable => false,
            :groupable => true,
            :caption => :field_attachments_translation_prices
          ) unless has_attachments_translation_prices.size() > 0
        end

        columns
      end

      def available_columns_with_attachments_layout_volumes
        columns = available_columns_without_attachments_layout_volumes

        allow_view_translation_statistics? do
          has_attachments_layout_volumes = columns.find_all { |column| column.name == :attachments_layout_volumes }
          columns << QueryColumn.new(:attachments_layout_volumes,
            :sortable => false,
            :groupable => true,
            :caption => :field_attachments_layout_volumes
          ) unless has_attachments_layout_volumes.size() > 0
        end

        columns
      end

      def available_columns_with_attachments_layout_rates
        columns = available_columns_without_attachments_layout_rates

        allow_view_translation_statistics? do
          has_attachments_layout_rates = columns.find_all { |column| column.name == :attachments_layout_rates }
          columns << QueryColumn.new(:attachments_layout_rates,
            :sortable => false,
            :groupable => true,
            :caption => :field_attachments_layout_rates
          ) unless has_attachments_layout_rates.size() > 0
        end

        columns
      end

      def available_columns_with_attachments_layout_prices
        columns = available_columns_without_attachments_layout_prices

        allow_view_translation_statistics? do
          has_attachments_layout_prices = columns.find_all { |column| column.name == :attachments_layout_prices }
          columns << QueryColumn.new(:attachments_layout_prices,
            :sortable => false,
            :groupable => true,
            :caption => :field_attachments_layout_prices
          ) unless has_attachments_layout_prices.size() > 0
        end

        columns
      end

      def available_columns_with_attachments_prices
        columns = available_columns_without_attachments_prices

        allow_view_translation_statistics? do
          has_attachments_prices = columns.find_all { |column| column.name == :attachments_prices }
          columns << QueryColumn.new(:attachments_prices,
            :sortable => false,
            :groupable => true,
            :caption => :field_attachments_prices
          ) unless has_attachments_prices.size() > 0
        end

        columns
      end

      def available_columns_with_attachments_volumes
        columns = available_columns_without_attachments_volumes

        allow_view_translation_statistics? do
          has_attachments_volumes = columns.find_all { |column| column.name == :attachments_volumes }
          columns << QueryColumn.new(:attachments_volumes,
            :sortable => false,
            :groupable => true,
            :caption => :field_attachments_volumes
          ) unless has_attachments_volumes.size() > 0
        end

        columns
      end

      def available_columns_with_balance_volume
        columns = available_columns_without_balance_volume

        allow_view_translation_statistics? do
          has_balance_volume = columns.find_all { |column| column.name == :balance_volume }
          columns << QueryColumn.new(:balance_volume,
            :sortable => false,
            :groupable => true,
            :caption => :field_balance_volume
          ) unless has_balance_volume.size() > 0
        end

        columns
      end

      def available_columns_with_balance_price
        columns = available_columns_without_balance_price

        allow_view_translation_statistics? do
          has_balance_price = columns.find_all { |column| column.name == :balance_price }
          columns << QueryColumn.new(:balance_price,
            :sortable => false,
            :groupable => true,
            :caption => :field_balance_price
          ) unless has_balance_price.size() > 0
        end

        columns
      end

      def available_columns_with_id_for_customer
        columns = available_columns_without_id_for_customer

        allow_view_translation_statistics? do
          has_id_for_customer = columns.find_all { |column| column.name == :id_for_customer }
          columns << QueryColumn.new(:id_for_customer,
            :sortable => false,
            :groupable => true,
            :caption => :field_id_for_customer
          ) unless has_id_for_customer.size() > 0
        end

        columns
      end

      def available_columns_with_author_id_for_customer
        columns = available_columns_without_author_id_for_customer

        allow_view_translation_statistics? do
          has_author_id_for_customer = columns.find_all { |column| column.name == :author_id_for_customer }
          columns << QueryColumn.new(:author_id_for_customer,
            :sortable => false,
            :groupable => true,
            :caption => :field_author_id_for_customer
          ) unless has_author_id_for_customer.size() > 0
        end

        columns
      end

      def allow_view_translation_statistics?
        if User.current.allowed_to?(:view_translation_statistics, project) || User.current.allowed_to?(:view_translation_parent, project)
          yield
        end
      end
    end
  end
end
