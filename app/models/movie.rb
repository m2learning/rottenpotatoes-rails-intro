class Movie < ActiveRecord::Base
  def self.all_ratings
    Movie.select(:rating).distinct.map {|m| m.rating}
  end
end
