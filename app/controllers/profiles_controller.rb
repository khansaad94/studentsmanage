class ProfilesController < ApplicationController
  def index
  end
  def new
    @user= current_user
    if @user.profile.present?
      @profile = @user.profile
    else
      @profile = Profile.new
    end
    # @profile = Profile.new
  end

  def create
    @user = current_user
    puts "aaaaaaaaaaaaaaaaaaaaaaaaaaa",@user.inspect
    puts "aaaaaaaaaaaaaaa?aaaaaaaaaaaa",@user.profile.inspect
    puts "aaaaaaaaaaaaaaaaaaaaaaaaaaa",params.inspect
if @user.profile.present?
  @user.profile.update_attributes(params_profile)
  redirect_to "/my-account"
else
  @profile = Profile.create!(params_profile)
  @profile.update_attributes(:user_id => @user.id)
  redirect_to "/my-account"

end

    def show
      @profile = Profile.find(params[:id])
    end



    end
  def update
    @user = current_user
    puts "aaaaaaaaaaaaaaaaaaaaaaaaaaa",@user.inspect
    puts "aaaaaaaaaaaaaaa?aaaaaaaaaaaa",@user.profile.inspect
    puts "aaaaaaaaaaaaaaaaaaaaaaaaaaa",params.inspect
if @user.profile.present?
  @user.profile.update_attributes(params_profile)
  redirect_to "/my-account"

else
  @profile = Profile.create!(params_profile)
  @profile.update_attributes(:user_id => @user.id)
  redirect_to "/my-account"

end


  end

end
private
def params_profile
  params.require(:profile).permit(:avatar, :about_me, :age, :body_type, :hair, :eyes, :school_standings, :study_focus, :smokes, :drinks, :first_date, :hobbies, :free_time, :best_words, :see_you_five_years, :where_why_travel, :food)
  # params.permit(:)
  # "profile"=>{"about_me"=>"as", "age"=>"as", "body_type"=>"as", "hair"=>"as", "eyes"=>"as", "school_standings"=>"as", "study_focus"=>"as", "smokes"=>"as", "drinks"=>"as", "first_date"=>"11/11/2016", "hobbies"=>"as", "free_time"=>"as", "best_words"=>"as", "see_you_five_years"=>"as", "where_why_travel"=>"as", "food"=>"as"}, "commit"=>"Create Profile", "action"=>"create", "controller"=>"profiles"}
  # Completed 500 Internal Server Error in 56ms

end
