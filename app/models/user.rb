class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         #:validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  scope :all_non_deleted_users, -> { where('user_type =? AND is_deleted =?', 'user', false) }
  scope :all_active_users, -> { where('user_type =? AND is_active =? AND is_deleted =?', 'user', true, false) }
  scope :all_cel_users, -> { where('user_type =? AND is_deleted =?', 'celebrity', false) }
  scope :all_deactivated_users, -> { where('user_type =? AND is_active =? AND is_deleted =?', 'user', false, false) }
  scope :all_deleted_users, -> { where('user_type =? AND is_deleted =?', 'user', true) }
  scope :all_non_deleted_celebrities, -> { joins(:celebrity).where('user_type =? AND is_deleted =? AND is_active =? AND away_mode =? AND celebrities.verified_account=?', 'celebrity', false, true, false, true) }
  #scope :search_celeb_by_name_or_industry, ->(text) { where('user_type =? AND is_deleted =? AND (first_name ilike ? OR last_name ilike ?) AND industry_id=?', 'celebrity', false, "%#{text}%", "%#{text}%") }
  scope :search_celeb_by_name, ->(text) { joins(:celebrity).where('user_type =? AND is_deleted =? AND is_active =? AND (first_name ilike ? OR last_name ilike ? OR full_name ilike ?) AND celebrities.verified_account=? AND away_mode =?', 'celebrity', false, true, "%#{text}%", "%#{text}%","%#{text}%", true, false) }
  scope :search_celeb_by_name_or_industry, ->(text, ind) { joins(:celebrity).where('user_type =? AND is_deleted =? AND is_active =? AND (first_name ilike ? OR last_name ilike ? OR full_name ilike ?) OR celebrities.industry_id=? AND celebrities.verified_account=? AND away_mode =?', 'celebrity', false, true, "%#{text}%", "%#{text}%", "%#{text}%", ind, true, false) }
  scope :search_celeb_by_name_and_industry, ->(text, ind) { joins(:celebrity).where('user_type =? AND is_deleted =? AND is_active =? AND (first_name ilike ? OR last_name ilike ? OR full_name ilike ?) AND celebrities.industry_id=? AND celebrities.verified_account=? AND away_mode =?', 'celebrity', false, true, "%#{text}%", "%#{text}%", "%#{text}%", ind, true, false) }
  scope :search_celeb_by_name_or_industry_web_service, ->(text, ind) { joins(:celebrity).where('user_type =? AND is_deleted =? AND is_active =? AND (first_name ilike ? OR last_name ilike ? OR full_name ilike ?) OR celebrities.industry_id=? AND celebrities.verified_account=? AND away_mode =?', 'celebrity', false, true, "%#{text}%", "%#{text}%", "%#{text}%", ind, true, false) }
  scope :search_celeb_by_name_and_industry, ->(text, ind) { joins(:celebrity).where('user_type =? AND is_deleted =? AND is_active =? AND (first_name ilike ? OR last_name ilike ? OR full_name ilike ?) AND celebrities.industry_id=? AND celebrities.verified_account=? AND away_mode =?', 'celebrity', false, true, "%#{text}%", "%#{text}%", "%#{text}%", ind, true, false) }
  scope :find_celeb, ->(id) { where('user_type =? AND is_deleted =? AND id =? AND is_active =? AND away_mode =?', 'celebrity', false, id, true, false).first }

  before_save :populate_full_name


  has_one :profile
  has_many :jobs
  has_one :braintree_info
  has_one :celebrity
  accepts_nested_attributes_for :celebrity

  def is_celebrity
    self.user_type == "celebrity"
  end

  def is_user
    self.user_type == "user"
  end

  def is_active_user
    (self.user_type == "user" || self.is_active == true)
  end

  def is_active_celebrity
    (self.user_type == "celebrity" || self.is_active == true)
  end

  def admin?
    self.is_admin == true
  end

  def role?
    if admin?
      return "admin"
    elsif is_user
      return "user"
    elsif is_celebrity
      return "celebrity"
    else
      return "no role"
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      #user.name = auth.info.name # assuming the user model has a name
      #user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  protected

  def populate_full_name
    self.full_name = "#{first_name.present? ? first_name : ""} #{last_name.present? ? last_name : ""}"
  end

end
