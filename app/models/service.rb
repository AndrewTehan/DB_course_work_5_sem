# frozen_string_literal: true

class Service < ApplicationRecord
  has_many :service_visits, dependent: :destroy
  has_many :visits, through: :service_visits

  has_many :master_services, dependent: :destroy
  has_many :masters, through: :master_services

  monetize :price_cents

  validates_uniqueness_of :service_name

  validate :not_negative_price, :empty_service_name

  def not_negative_price
    errors.add(:price, "shouldn't be negative") if price.negative?
  end

  def empty_service_name
    errors.add(:service_name, "shoundn't be empty") if service_name == ''
  end

  def self.export_data
    file = "/home/andrew/Documents/Saloon/public/service_data.csv"
    
    services = connection.execute("select * from AllServices()")
    
    headers = ["name_service", "service_price", "currency_price"]
    
    CSV.open(file, 'wb', write_headers: true, headers: headers) do |writer|
      services.each do |service|
        writer << [service["name_service"], service["service_price"], service["currency_price"]]
      end
    end
  end
end
