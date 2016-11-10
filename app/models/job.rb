class Job < ActiveRecord::Base

  # before_create :custom_job_id_assign
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
  belongs_to :event_type
  belongs_to :celebrity

  scope :all_pending_jobs, -> { where('status =?', ApplicationHelper::JOBSTATUS[1]) }

  private
  # def custom_job_id_assign
  #   self.customer_job_id = ((Time.now.to_i).to_s + generate_password(6).to_s)
  # end

  # def generate_password(length=6)
  #   chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ23456789'
  #   password = ''
  #   length.times { |i| password << chars[rand(chars.length)] }
  #   password
  # end

end
