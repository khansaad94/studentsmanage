class AddColumnToProfile < ActiveRecord::Migration
  def change
    add_attachment :profiles, :avatar
    add_column :profiles, :is_approved, :boolean
    add_column :profiles, :about_me, :text
    add_column :profiles, :age, :string
    add_column :profiles, :body_type, :string
    add_column :profiles, :hair, :string
    add_column :profiles, :eyes, :string
    add_column :profiles, :school_standings, :string
    add_column :profiles, :study_focus, :string
    add_column :profiles, :smokes, :string
    add_column :profiles, :drinks, :string
    add_column :profiles, :first_date, :text
    add_column :profiles, :hobbies, :text
    add_column :profiles, :free_time, :text
    add_column :profiles, :best_words, :text
    add_column :profiles, :see_you_five_years, :text
    add_column :profiles, :where_why_travel, :text
    add_column :profiles, :food, :text

  end
end
