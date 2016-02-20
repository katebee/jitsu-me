class Session < ActiveRecord::Base
  belongs_to :club
  belongs_to :location
end
