# frozen_string_literal: true

FactoryBot.define do
  factory :failed_register do
    error { 'MyText' }
     association :import_file, factory: :import_file
  end
end
