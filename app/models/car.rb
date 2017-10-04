class Car < ApplicationRecord
  validates_inclusion_of :status, in: ['available', 'checked_out', 'reserved'], default: 'available'
  validates_length_of :registration_number, is: 7, uniqueness: true
  has_many :reservations

  def self.search(term)
    if term
      where('model LIKE ? OR manufacturer LIKE ? OR status LIKE ?', "%#{term}%", "%#{term}%", "%#{term}%")
    else
      all
    end
  end
end
