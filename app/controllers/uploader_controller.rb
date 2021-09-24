class UploaderController < ApplicationController
  def import
    @import_file = ImportFile.new
  end

  def upload
    @import_file = ImportFile.new(import_params)
    @import_file.status = "on hold"
    @import_file.user = current_user
    unless @import_file.column
      flash.now[:notice] = "Missing columns"
      render 'import'
      return
    end
    if @import_file.save
      import_hash = { id: @import_file.id, column: @import_file.column}
      ImportFileWorker.perform_async(import_hash)
      flash[:notice] = "The file was successfully uploaded"
      redirect_to user_imported_files_path
    else
      flash.now[:notice] = "Something went wrong"
      render 'import'
    end
  end

  def failed_registers
    import_file = ImportFile.find_by(id: params[:id])
    if !(import_file) || (import_file.user != current_user)
      render :file => "#{Rails.root}/public/404.html",
              layout: false, status: :not_found
      return
    end
    @failed_registers = import_file.failed_registers.
                          paginate(page: params[:page], per_page: 10)
  end

  private

  def import_params
    params.require(:import_file).
      permit(:file,
              column: [
                :name,
                :birthdate,
                :phone,
                :address,
                :credit_card,
                :email
              ]
            )
  end
end
