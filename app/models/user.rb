# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:,
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  has_many :import_files
  has_many :contacts
end
