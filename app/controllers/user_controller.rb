class UserController < ApplicationController
  def imported_files
    @imported_files = current_user.import_files.
                        paginate(page: params[:page], per_page: 10).
                        order('created_at DESC')
  end

  def contacts
    @contacts = current_user.contacts.
                  paginate(page: params[:page], per_page: 10).
                  order('name ASC')
  end
end
