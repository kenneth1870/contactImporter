# frozen_string_literal: true

class ImportFileWorker 
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(import_hash)
    import_file = ImportFile.find_by(id: import_hash['id'])
    if import_file
      import_file.column = import_hash['column']
      import_file.processing
    end
  end
end
