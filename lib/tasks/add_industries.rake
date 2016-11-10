namespace :db do

  task :seed_industries => :environment do

    Industry.delete_all
    # TV
    # Movie
    # Music
    # Writers
    # Photographers
    # Fashion/Models
    # Artists
    # Chef
    # Entrepreneur/Business
    # Sports
    # Politicians
    # Internet


    ind = Industry.new(:title => 'Television')
    ind.save!
    ind = Industry.new(:title => 'Movie')
    ind.save!
    ind = Industry.new(:title => 'Music')
    ind.save!
    ind = Industry.new(:title => 'Writers')
    ind.save!
    ind = Industry.new(:title => 'Photographers')
    ind.save!
    ind = Industry.new(:title => 'Fashion/Models')
    ind.save!
    ind = Industry.new(:title => 'Artists')
    ind.save!
    ind = Industry.new(:title => 'Chef')
    ind.save!
    ind = Industry.new(:title => 'Entrepreneur/Business')
    ind.save!
    ind = Industry.new(:title => 'Sports')
    ind.save!
    ind = Industry.new(:title => 'Politicians')
    ind.save!
    ind = Industry.new(:title => 'Internet')
    ind.save!


    cel = Celebrity.all
    ind1 = Industry.first
    unless cel.blank?
      cel.each do |cl|
        if cl.industry_id.blank?

          cl.update_attributes(:industry_id => ind1.id)
        end
      end
    end

  end

end