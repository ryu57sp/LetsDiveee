class DiveComment < ApplicationRecord
  belongs_to :user
  belongs_to :dive
end