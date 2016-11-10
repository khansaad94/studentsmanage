class CharityAccount < ActiveRecord::Base

  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :celebrity_charitieses

end
