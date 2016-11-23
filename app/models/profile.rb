class Profile < ActiveRecord::Base
  belongs_to :user
  has_attached_file :avatar, :styles => {:medium => '250x250#', :thumb => '150x150#', :icon => '25x25#', :other => '640x563#'}, :default_url => "/images/:style/missing.png",

                    :path => ":attachment/:id/:style/:basename.:extension",
                    :storage => :s3,
                    :s3_credentials => {
                        :bucket => "celebvidy",
                        :access_key_id => "AKIAJYXDUV3IMTNDGIPQ",
                        :secret_access_key => "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"
                    }

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

end
