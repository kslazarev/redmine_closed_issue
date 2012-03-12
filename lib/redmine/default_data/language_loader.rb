module Redmine
  module DefaultData
    class DataAlreadyLoaded < Exception; end

    module LanguageLoader
      include Redmine::I18n

      class << self
        # Returns true if no data is already loaded in the database
        # otherwise false
        def no_data?
          !Language.find(:first)
        end

        # Loads the default data
        # Raises a RecordNotSaved exception if something goes wrong
        def load(lang=nil)
          raise DataAlreadyLoaded.new("Some language data is already loaded.") unless no_data?
          set_language_if_valid(lang)

          Language.transaction do
            translation_languages = %w(
              ru en de fr es
              it ja cn ua by
              pl bg az sa am
              hu nl el ge il
              kz kg kr lv pt
              ro rs si tj tr
              tm fi hr cs sw
            )

            translation_languages.each_with_index{|language, index|
              Language.create! :name => l([:translation_languages, language].join('.')), :position => index + 1
            }
          end

          true
        end
      end
    end

    #module LanguageLoader
    #  include Redmine::I18n
    #
    #  class << self
    #    # Returns true if no data is already loaded in the database
    #    # otherwise false
    #    def no_data?
    #      !Language.find(:first)
    #    end
    #
    #    # Loads the default data
    #    # Raises a RecordNotSaved exception if something goes wrong
    #    def load(lang=nil)
    #      raise DataAlreadyLoaded.new("Some language data is already loaded.") unless no_data?
    #      set_language_if_valid(lang)
    #
    #      Language.transaction do
    #        translation_languages = %w(
    #          ru en de fr es
    #          it ja cn ua by
    #          pl bg az sa am
    #          hu nl el ge il
    #          kz kg kr lv pt
    #          ro rs si tj tr
    #          tm fi hr cs sw
    #        )
    #
    #        translation_languages.each_with_index{|language, index|
    #          Language.create! :name => l([:translation_languages, language].join('.')), :position => index + 1
    #        }
    #      end
    #
    #      true
    #    end
    #  end
    #end
  end
end
