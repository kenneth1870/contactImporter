require 'rails_helper'

RSpec.describe ImportFile, type: :model do
  let(:user) { create(:user) }
  let(:import_file) { build(:import_file, user: user) }
  describe '#validations' do
    it 'test that is invalid empty fields' do
      aggregate_failures do
        import_file.status = ''
        import_file.user = nil
        expect(import_file).not_to be_valid
        expect(import_file.errors[:user]).to include('must exist')
        expect(import_file.errors[:status]).to include("can't be blank")
      end
    end

    it 'test that factory object is valid' do
      expect(import_file).to be_valid
    end

    it 'test that has valid status' do
      aggregate_failures do
        import_file.status = "on hold"
        expect(import_file).to be_valid
        import_file.status = "processing"
        expect(import_file).to be_valid
        import_file.status = "failed"
        expect(import_file).to be_valid
        import_file.status = "finished"
        expect(import_file).to be_valid
      end
    end

    it 'test that has invalid status' do
      aggregate_failures do
        import_file.status = "some state"
        expect(import_file).not_to be_valid
        expect(import_file.errors[:status]).to include("some state is not a valid status")
        import_file.status = "21231234"
        expect(import_file).not_to be_valid
      end
    end

    it 'test that import_file has a valid attached file' do
      aggregate_failures do
        expect(import_file.file).to be_attached
        expect(import_file).to be_valid
      end
    end

    it 'test that check invalid type attached file' do
      import_file.file.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'gatsby.png')),
                              filename: 'gatsby.png')
      expect(import_file).not_to be_valid
    end
  end

  describe '#processing' do
    it 'test that correctly process a csv file' do
      aggregate_failures do
        import_file.column = { "name" => "name", "birthdate" => "birthdate", "phone" => "phone",
          "address" => "address", "credit_card" => "credit_card", "email" => "email" }
        import_file.save
        expect(import_file.status).to eq("on hold")
        expect(FailedRegister.all.count).to eq(0)
        expect(Contact.all.count).to eq(0)
        import_file.processing
        expect(import_file.status).to eq("finished")
        expect(FailedRegister.all.count).to eq(0)
        expect(Contact.all.count).to eq(8)
      end
    end
  end

  describe '#private methods' do
    it 'test that stores a failed register' do
      aggregate_failures do
        expect(FailedRegister.all.count).to eq(0)
        import_file.set_failed_register("Birthdate wrong date format")
        expect(FailedRegister.all.count).to eq(1)
      end
    end

    it 'test that do not stores a failed register' do
      aggregate_failures do
        expect(FailedRegister.all.count).to eq(0)
        import_file.set_failed_register("")
        expect(FailedRegister.all.count).to eq(0)
      end
    end

    it 'test true in has_valid_headers?' do
      aggregate_failures do
        import_file.column = { "name" => "name", "birthdate" => "birthdate", "phone" => "phone",
                             "address" => "address", "credit_card" => "credit_card", "email" => "email" }
        import_file.save
        headers = ["name", "email", "address", "phone", "credit_card", "birthdate"]
        expect(import_file.has_valid_headers?(headers)).to eq(true)
      end
    end

    it 'test false in has_valid_headers?' do
      aggregate_failures do
        import_file.column = { "name" => "nombre", "birthdate" => "fecha", "phone" => "tele",
                             "address" => "dir", "credit_card" => "tarjeta", "email" => "correo" }
        import_file.save
        headers = ["name", "email", "address", "phone", "credit_card", "birthdate"]
        expect(import_file.has_valid_headers?(headers)).to eq(false)
      end
    end

    it 'test return a franchise key in hash' do
      aggregate_failures do
        attributes = { name: "James Bond", birthdate: "19750202", phone: "(+07) 123 123 12 12",
                      address: "some street", credit_card: "4111111111111111", "email" => "james@example.com" }
        expect(import_file.get_franchise(attributes[:credit_card])).to eq({ franchise: "Visa" })
        attributes[:credit_card] = "371449635398431"
        expect(import_file.get_franchise(attributes[:credit_card])).to eq({ franchise: "American Express" })
        attributes[:credit_card] = "6011111111111117"
        expect(import_file.get_franchise(attributes[:credit_card])).to eq({ franchise: "Discover" })
        attributes[:credit_card] = "30569309025904"
        expect(import_file.get_franchise(attributes[:credit_card])).to eq({ franchise: "Diners Club" })
        attributes[:credit_card] = "3530111333300000"
        expect(import_file.get_franchise(attributes[:credit_card])).to eq({ franchise: "JCB" })
        attributes[:credit_card] = "5555555555554444"
        expect(import_file.get_franchise(attributes[:credit_card])).to eq({ franchise: "MasterCard" })
      end
    end

    it 'test return a franchise nil in hash' do
      aggregate_failures do
        attributes = { name: "James Bond", birthdate: "19750202", phone: "(+07) 123 123 12 12",
                      address: "some street", credit_card: "4411111111111111", "email" => "james@example.com" }
        expect(import_file.get_franchise(attributes[:credit_card])).to eq({ franchise: nil })
      end
    end

    it 'test return an encrypted credit_card string' do
      aggregate_failures do
        credit_card = "4111111111111111"
        expect(import_file.encrypt_cc(credit_card)).to eq("************1111")
      end
    end

    it 'test return a hash with contacts attributes' do
      aggregate_failures do
        import_file.column = { "name" => "nombre", "birthdate" => "fecha", "phone" => "tele",
                              "address" => "dir", "credit_card" => "tarjeta", "email" => "correo" }
        row = { "nombre" => "James Bond", "fecha" => "19750202", "tele" => "(+07) 123 123 12 12",
                "dir" => "some street", "tarjeta" => "371449635398431", "correo" => "james@example.com" }
        result = { name: "James Bond", birthdate: "19750202", phone: "(+07) 123 123 12 12",
                  address: "some street", credit_card: "***********8431",
                  email: "james@example.com", franchise: "American Express" }
        expect(import_file.get_contact_attributes(row)).to eq(result)
      end
    end

    it 'test that return a "finished" ImportFile status after reading a csv' do
      aggregate_failures do
        import_file.column = { "name" => "name", "birthdate" => "birthdate", "phone" => "phone",
          "address" => "address", "credit_card" => "credit_card", "email" => "email" }
        import_file.save
        expect(FailedRegister.all.count).to eq(0)
        expect(Contact.all.count).to eq(0)
        result = import_file.read_csv_file
        expect(FailedRegister.all.count).to eq(0)
        expect(Contact.all.count).to eq(8)
        expect(result).to eq({ status: "finished"})
      end
    end

    it 'test that return a "failed" ImportFile status after reading a csv by bad headers' do
      aggregate_failures do
        import_file.file.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'bad_headers.csv')),
                                filename: 'bad_headers.csv', content_type: 'text/csv')
        import_file.column = { "name" => "name", "birthdate" => "birthdate", "phone" => "phone",
          "address" => "address", "credit_card" => "credit_card", "email" => "email" }
        import_file.save
        expect(FailedRegister.all.count).to eq(0)
        expect(Contact.all.count).to eq(0)
        result = import_file.read_csv_file
        expect(FailedRegister.all.count).to eq(1)
        expect(Contact.all.count).to eq(0)
        expect(result).to eq({ status: "failed"})
      end
    end

    it 'test that return a "failed" ImportFile status after reading a csv by bad data' do
      aggregate_failures do
        import_file.file.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'bad_data.csv')),
                                filename: 'bad_data.csv', content_type: 'text/csv')
        import_file.column = { "name" => "name", "birthdate" => "birthdate", "phone" => "phone",
          "address" => "address", "credit_card" => "credit_card", "email" => "email" }
        import_file.save
        expect(FailedRegister.all.count).to eq(0)
        expect(Contact.all.count).to eq(0)
        result = import_file.read_csv_file
        expect(FailedRegister.all.count).to eq(8)
        expect(Contact.all.count).to eq(0)
        expect(result).to eq({ status: "failed"})
      end
    end

    it 'test that return a "finished" ImportFile status after reading a csv by partial bad data' do
      aggregate_failures do
        import_file.file.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'partial_bad_data.csv')),
                                filename: 'partial_bad_data.csv', content_type: 'text/csv')
        import_file.column = { "name" => "name", "birthdate" => "birthdate", "phone" => "phone",
                            "address" => "address", "credit_card" => "credit_card", "email" => "email" }
        import_file.save
        expect(FailedRegister.all.count).to eq(0)
        expect(Contact.all.count).to eq(0)
        result = import_file.read_csv_file
        expect(FailedRegister.all.count).to eq(6)
        expect(Contact.all.count).to eq(2)
        expect(result).to eq({ status: "finished"})
      end
    end

    it 'test that return a "failed" ImportFile status after reading a csv by contact repeated email' do
      aggregate_failures do
        import_file.file.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'repeated_email.csv')),
                                filename: 'repeated_email.csv', content_type: 'text/csv')
        import_file.column = { "name" => "nombre", "birthdate" => "fecha", "phone" => "telefono",
                              "address" => "direccion", "credit_card" => "tarjeta", "email" => "correo" }
        import_file.save
        expect(FailedRegister.all.count).to eq(0)
        expect(Contact.all.count).to eq(0)
        result = import_file.read_csv_file
        expect(FailedRegister.all.count).to eq(0)
        expect(Contact.all.count).to eq(1)
        expect(result).to eq({ status: "finished"})
        result = import_file.read_csv_file
        expect(FailedRegister.all.count).to eq(1)
        expect(Contact.all.count).to eq(1)
        expect(result).to eq({ status: "failed"})
      end
    end

    it 'test that return a "finished" ImportFile status after reading a csv by one new contact and one repeated' do
      aggregate_failures do
        # initial storage to database 1 contact gets inserted not repeated
        import_file.file.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'repeated_email.csv')),
                                filename: 'repeated_email.csv', content_type: 'text/csv')
        import_file.column = { "name" => "nombre", "birthdate" => "fecha", "phone" => "telefono",
                              "address" => "direccion", "credit_card" => "tarjeta", "email" => "correo" }
        import_file.save
        expect(FailedRegister.all.count).to eq(0)
        expect(Contact.all.count).to eq(0)
        result = import_file.read_csv_file
        expect(FailedRegister.all.count).to eq(0)
        expect(Contact.all.count).to eq(1)
        expect(result).to eq({ status: "finished"})
        # second import file should increase failed register (repeated email) and new contact by 1
        another_import = build(:import_file, user: user)
        another_import.column = import_file.column
        another_import.file.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'one_contact.csv')),
                                filename: 'one_contact.csv', content_type: 'text/csv')
        another_import.save
        expect(FailedRegister.all.count).to eq(0)
        expect(Contact.all.count).to eq(1)
        result = another_import.read_csv_file
        expect(FailedRegister.all.count).to eq(1)
        expect(Contact.all.count).to eq(2)
        expect(result).to eq({ status: "finished"})
      end
    end
  end
end
