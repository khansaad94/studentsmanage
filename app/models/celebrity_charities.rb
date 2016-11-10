class CelebrityCharities < ActiveRecord::Base

  has_one :celebrity
  has_one :charity_account

end
