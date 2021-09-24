# frozen_string_literal: true

FactoryBot.define do
  factory :import_file do
    status { 'on hold' }
    user { nil }
    after (:build) do |import_file|
      import_file.file.attach(io: File.open(Rails.root.join('spec', 'fixtures',
                                            'files', 'testing_file.csv')),
                              filename: 'testing_file.csv',
                              content_type: 'text/csv')
    end
  end
end
