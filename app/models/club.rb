class Club < ActiveRecord::Base
  has_many :sessions
  validates :name, presence: { message: "cannot be blank" }
end
