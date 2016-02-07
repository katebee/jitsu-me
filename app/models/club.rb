class Club < ActiveRecord::Base
  has_many :sessions, dependent: :destroy
  validates :name, presence: { message: "cannot be blank" }
end
