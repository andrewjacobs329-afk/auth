class Contact < ApplicationRecord
  # connects to the contacts table
  validates :company_id, presence: true
end
