# frozen_string_literal: true

module Slickr
  # Rubbish class
  class Rubbish
    @@restorable_classes = []

    def self.add_restorable(restorable)
      @@restorable_classes << restorable
      Slickr::Rubbish.define_singleton_method(restorable[:restorable_method]) do
        restorable[:restorable_model].name.classify.constantize.discarded
      end
    end

    def self.restorable_classes
      @@restorable_classes
    end

    @@restorable_classes.each do |restorable|
      Slickr::Rubbish.define_singleton_method(restorable[:restorable_method]) do
        restorable[:restorable_model].name.classify.discarded
      end
    end
  end
end
