# frozen_string_literal: true
require 'csv'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  def full_name
    "#{first_name} #{last_name}"
  end

  validate :first_name_cannot_be_blank, :last_name_cannot_be_blank, :phone_number_cannot_be_blank, :email_cannot_be_blank

  def first_name_cannot_be_blank
    errors.add(:first_name, "shouldn't be empty") if first_name.blank?
  end

  def last_name_cannot_be_blank
    errors.add(:last_name, "shouldn't be empty") if last_name.blank?
  end

  def phone_number_cannot_be_blank
    errors.add(:phone_number, "shouldn't be empty") if phone_number.blank?
  end

  def email_cannot_be_blank
    errors.add(:email, "shouldn't be empty") if email.blank?
  end

  def self.export_data
    file = "/home/andrew/Documents/Saloon/public/user_data.csv"
    
    users = connection.execute("select * from AllUsers()")
    
    headers = [ "First name", "Last name", "Email", "Phone number"]
    
    CSV.open(file, 'wb', write_headers: true, headers: headers) do |writer|
      users.each do |user|
        writer << [ user["user_first_name"], user["user_last_name"], user["user_email"], user["user_phone_number"]]
      end
    end
  end
end
