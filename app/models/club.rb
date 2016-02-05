class Club < ActiveRecord::Base
  validates :name, presence: { message: "cannot be blank" }
end
