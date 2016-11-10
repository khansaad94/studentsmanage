class Celebrity < ActiveRecord::Base


  has_attached_file :avatar, :styles => {:medium => '250x250#', :thumb => '150x150#', :icon => '25x25#', :other => '640x563#'}, :default_url => "/images/:style/missing.png",

                    :path => ":attachment/:id/:style/:basename.:extension",
                    :storage => :s3,
                    :s3_credentials => {
                        :bucket => "celebvidy",
                        :access_key_id => "AKIAJYXDUV3IMTNDGIPQ",
                        :secret_access_key => "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"
                    }

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  #validates :avatar, :attachment_presence => true
  #validates_with AttachmentPresenceValidator, :attributes => :avatar
  #validates_with AttachmentSizeValidator, :attributes => :avatar, :greater_than => 1.megabytes
  has_attached_file :video,
                    :path => ":attachment/:id/:style/:basename.:extension",
                    :storage => :s3,
                    :s3_credentials => {
                        :bucket => "celebvidy",
                        :access_key_id => "AKIAJYXDUV3IMTNDGIPQ",
                        :secret_access_key => "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",
                        :s3_headers =>  { "Content-Type" => "video/mp4" }
                    }
  validates_attachment_content_type :video,
                                    :content_type => ['video/mp4','application/mp4', 'video/webm', 'video/mkv', 'video/m4p', 'video/m4v', 'video/rm', 'video/avi', 'video/mov', 'video/drc', 'video/ogg', 'video/ogv', 'video/rmvb', 'video/svi'],
                                    :message => "Sorry, right now we only support mp4, mov,rm,etc video"

  belongs_to :user
  has_many :jobs, :dependent => :destroy
  has_one :celebrity_charities
  has_one :industry
  has_one :payment_address
end
