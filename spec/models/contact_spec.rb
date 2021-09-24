require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe '#validations' do
    let(:user) { create(:user) }
    let(:contact) { build(:contact, user: user) }
    it 'test that factory object is valid' do
      expect(contact).to be_valid
    end

    it 'test that has field empty' do
      aggregate_failures do
        invalid_contact = build(:contact, name: '', birthdate: '', phone: '',
                                address: '', credit_card: '', franchise: '',
                                email: '', user: nil)
        expect(invalid_contact).not_to be_valid
        expect(invalid_contact.errors[:user]).to include('must exist')
        expect(invalid_contact.errors[:name]).to include("can't be blank")
        expect(invalid_contact.errors[:birthdate]).to include("can't be blank")
        expect(invalid_contact.errors[:phone]).to include("can't be blank")
        expect(invalid_contact.errors[:address]).to include("can't be blank")
        expect(invalid_contact.errors[:credit_card]).to include("can't be blank")
        expect(invalid_contact.errors[:franchise]).to include("can't be blank")
        expect(invalid_contact.errors[:email]).to include("can't be blank")
      end
    end

    it 'test that has valid name' do
      aggregate_failures do
        contact.name = 'Jhon'
        expect(contact).to be_valid
        contact.name = 'jane doe'
        expect(contact).to be_valid
        contact.name = 'Jhon-Doe'
        expect(contact).to be_valid
        contact.name = 'JHONY PEARSON'
        expect(contact).to be_valid
      end
    end

    it 'test that has invalid name length' do
      aggregate_failures do
        contact.name = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
                        aaaaaaaaaaaaaaaaaaaaaaaa'
        expect(contact).not_to be_valid
      end
    end

    it 'test that has invalid name format' do
      aggregate_failures do
        contact.name = 'John_Doe'
        expect(contact).not_to be_valid
        contact.name = 'John, Doe'
        expect(contact).not_to be_valid
        contact.name = 'John Do3'
        expect(contact).not_to be_valid
        contact.name = 'John #Doe'
        expect(contact).not_to be_valid
        contact.name = 'John Doe;'
        expect(contact).not_to be_valid
        contact.name = '0123456789'
        expect(contact).not_to be_valid
        contact.name = '[1, 2, 3]'
        expect(contact).not_to be_valid
        contact.name = '[]'
        expect(contact).not_to be_valid
        contact.name = '{}'
        expect(contact).not_to be_valid
        contact.name = '{"key": "value"}'
        expect(contact).not_to be_valid
      end
    end

    it 'test that has valid birthdate format' do
      aggregate_failures do
        contact.birthdate = '19990101'
        expect(contact).to be_valid
        contact.birthdate = '1999-01-01'
        expect(contact).to be_valid
      end
    end

    it 'test that has invalid birthdate format' do
      aggregate_failures do
        contact.birthdate = '2000/12/12'
        expect(contact).not_to be_valid
        expect(contact.errors[:birthdate]).to include('wrong date format')
        contact.birthdate = 'Birthday'
        expect(contact).not_to be_valid
        contact.birthdate = 'May 3, 2000'
        expect(contact).not_to be_valid
        contact.birthdate = '123456789101112'
        expect(contact).not_to be_valid
        contact.birthdate = 'John .Doe'
        expect(contact).not_to be_valid
        contact.birthdate = '[1, 2, 3]'
        expect(contact).not_to be_valid
        contact.birthdate = 'aaaaaaaaaaaa'
        expect(contact).not_to be_valid
        contact.birthdate = '2000$12$12'
        expect(contact).not_to be_valid
        contact.birthdate = '2000.12.12'
        expect(contact).not_to be_valid
        contact.birthdate = '2000_12_12'
        expect(contact).not_to be_valid
        contact.birthdate = '2000-1212'
        expect(contact).not_to be_valid
        contact.birthdate = '2000121-0'
        expect(contact).not_to be_valid
        contact.birthdate = '200-0-1-21-0'
        expect(contact).not_to be_valid
        contact.birthdate = '[1, 2, 3]'
        expect(contact).not_to be_valid
        contact.birthdate = '[]'
        expect(contact).not_to be_valid
        contact.birthdate = '{}'
        expect(contact).not_to be_valid
        contact.birthdate = '{"key": "value"}'
        expect(contact).not_to be_valid
      end
    end

    it 'test that has invalid birthdate value' do
      aggregate_failures do
        contact.birthdate = '2000-99-99'
        expect(contact).not_to be_valid
        expect(contact.errors[:birthdate]).to include('wrong date value')
        contact.birthdate = '20009999'
        expect(contact).not_to be_valid
        expect(contact.errors[:birthdate]).to include('wrong date value')
      end
    end

    it 'test that has valid phone' do
      aggregate_failures do
        contact.phone = '(+00) 000 000 00 00'
        expect(contact).to be_valid
        contact.phone = '(+57) 320 432 05 09'
        expect(contact).to be_valid
        contact.phone = '(+00) 000-000-00-00'
        expect(contact).to be_valid
        contact.phone = '(+57) 320-432-05-09'
        expect(contact).to be_valid
      end
    end

    it 'test that has invalid phone' do
      aggregate_failures do
        contact.phone = 'John_Doe'
        expect(contact).not_to be_valid
        contact.phone = 'a3b4d'
        expect(contact).not_to be_valid
        contact.phone = '2000.12.12'
        expect(contact).not_to be_valid
        contact.phone = '2000-12-12'
        expect(contact).not_to be_valid
        contact.phone = '[1, 2, 3]'
        expect(contact).not_to be_valid
        contact.phone = 'aaaaaaaaaaaaaaaa'
        expect(contact).not_to be_valid
        contact.phone = '(00) 123 123 12 12'
        expect(contact).not_to be_valid
        contact.phone = '(00)1231231212'
        expect(contact).not_to be_valid
        contact.phone = '(00) 123 123 1212'
        expect(contact).not_to be_valid
        contact.phone = '(-00) 123 123 12 12'
        expect(contact).not_to be_valid
        contact.phone = '(+00) 123 123 12 1'
        expect(contact).not_to be_valid
        contact.phone = '(+00) 123 123 12 123'
        expect(contact).not_to be_valid
        contact.phone = '(+57) 123,123-12-12'
        expect(contact).not_to be_valid
        contact.phone = '(+57) 123 123 12-12'
        expect(contact).not_to be_valid
        contact.phone = '(+57) 123-123,12,12'
        expect(contact).not_to be_valid
        contact.phone = '(+57) 123-123-12-1b'
        expect(contact).not_to be_valid
        contact.phone = '(+5A) 123-123,12,12'
        expect(contact).not_to be_valid
        contact.phone = '(+57) 123/123/12/12'
        expect(contact).not_to be_valid
        contact.phone = '(-00) 123 123 12 12'
        expect(contact).not_to be_valid
        contact.phone = '[1, 2, 3]'
        expect(contact).not_to be_valid
        contact.phone = '[]'
        expect(contact).not_to be_valid
        contact.phone = '{}'
        expect(contact).not_to be_valid
        contact.phone = '{"key": "value"}'
        expect(contact).not_to be_valid
      end
    end

    it 'test that has valid credit_card' do
      aggregate_failures do
        contact.credit_card = '******8431'
        expect(contact).to be_valid
        contact.credit_card = '*******5904'
        expect(contact).to be_valid
        contact.credit_card = '********1117'
        expect(contact).to be_valid
        contact.credit_card = '*********0000'
        expect(contact).to be_valid
        contact.credit_card = '**********4444'
        expect(contact).to be_valid
        contact.credit_card = '***********1111'
        expect(contact).to be_valid
      end
    end

    it 'test that has invalid credit_card length' do
      aggregate_failures do
        contact.credit_card = '*****6789'
        expect(contact).not_to be_valid
        contact.credit_card = '****************7890'
        expect(contact).not_to be_valid
      end
    end

    it 'test that has invalid credit_card' do
      aggregate_failures do
        contact.credit_card = 'John Doe Doe Doe'
        expect(contact).not_to be_valid
        contact.credit_card = 'a1b2c3d4e5f6g7h'
        expect(contact).not_to be_valid
        contact.credit_card = 'John Do3'
        expect(contact).not_to be_valid
        contact.credit_card = 'John #Doe'
        expect(contact).not_to be_valid
        contact.credit_card = '7048860f6619'
        expect(contact).not_to be_valid
        contact.credit_card = '[1, 2, 3]'
        expect(contact).not_to be_valid
        contact.credit_card = 'aaaaaaaaaaaaaaaaa'
        expect(contact).not_to be_valid
        contact.credit_card = '(+00) 123 123 12 123'
        expect(contact).not_to be_valid
        contact.credit_card = '(+57) 123,123-12-12'
        expect(contact).not_to be_valid
        contact.credit_card = '[1, 2, 3]'
        expect(contact).not_to be_valid
        contact.credit_card = '[]'
        expect(contact).not_to be_valid
        contact.credit_card = '{}'
        expect(contact).not_to be_valid
        contact.credit_card = '{"key": "value"}'
        expect(contact).not_to be_valid
      end
    end

    it 'test that has valid franchise' do
      aggregate_failures do
        contact.franchise = 'Visa'
        expect(contact).to be_valid
        contact.franchise = 'MasterCard'
        expect(contact).to be_valid
        contact.franchise = 'JCB'
        expect(contact).to be_valid
        contact.franchise = 'Discover'
        expect(contact).to be_valid
        contact.franchise = 'Diners Club'
        expect(contact).to be_valid
        contact.franchise = 'American Express'
        expect(contact).to be_valid
      end
    end

    it 'test that has invalid franchise' do
      aggregate_failures do
        contact.franchise = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
                            aaaaaaaaaaaaaaaaaaaaaaaa'
        expect(contact).not_to be_valid
      end
    end
    
    it 'test that has valid email' do
      aggregate_failures do
        contact.email = 'testingusercheckinglenght@gmail.tech'
        expect(contact).to be_valid
      end
    end

    it 'test that has valid email length' do
      aggregate_failures do
        contact.email = 'testingwithcontactemailifthelengthislongenoughtostoreindatabase@ggggggggmmmmmmmmmaiiiiiiiiiillllllllll.cccccccoooooooommmmmmm'
        expect(contact).not_to be_valid
        expect(contact.errors[:email]).to include("is too long (maximum is 105 characters)")
      end
    end

    it 'test that has invalid email' do
      aggregate_failures do
        contact.email = 'abcd'
        expect(contact).not_to be_valid
        contact.email = 'John_Doe'
        expect(contact).not_to be_valid
        contact.email = '[1, 2, 3]'
        expect(contact).not_to be_valid
        contact.email = '[]'
        expect(contact).not_to be_valid
        contact.email = '{}'
        expect(contact).not_to be_valid
        contact.email = '{"key": "value"}'
        expect(contact).not_to be_valid
        contact.email = '371449635398431'
        expect(contact).not_to be_valid
        contact.email = 'user@'
        expect(contact).not_to be_valid
        contact.email = '(+57) 320 432 05 09'
        expect(contact).not_to be_valid
        contact.email = '1999-01-01'
        expect(contact).not_to be_valid
        contact.email = 'testing%usercheckinglength@gmail.tech'
        expect(contact).not_to be_valid
        contact.email = 'testing user checking length@gmail.tech'
        expect(contact).not_to be_valid
      end
    end
  end
end
