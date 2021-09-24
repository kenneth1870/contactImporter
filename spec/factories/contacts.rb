# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    name { 'John Doe' }
    birthdate { '20210408' }
    phone { '(+57) 320 432 05 09' }
    address { '99 Street #55-55 Main Avenue' }
    credit_card { '***********8431' }
    franchise { 'American Express' }
    sequence(:email) { |n| "contact#{n}@example.com" }
    user { nil }
  end
end
