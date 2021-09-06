# frozen_string_literal: true

class Visit < ApplicationRecord
  include AASM

  aasm column: 'state' do
    state :sent, initial: true
    state :confirmed
    state :done

    event :accepted do
      transitions from: :sent, to: :confirmed
    end

    event :finished do
      transitions from: :confirmed, to: :done
    end
  end

  belongs_to :client
  belongs_to :master

  has_one :service_visit, dependent: :destroy
  has_one :service, through: :service_visit

  accepts_nested_attributes_for :service_visit

  validate :support_service, :check_date

  def support_service
    errors.add(:service, "isn't supported by selected master") unless master.services.include?(service_visit.service)
  end

  def check_date
    errors.add(:date, 'must be in future') if date < Time.now
  end
end
