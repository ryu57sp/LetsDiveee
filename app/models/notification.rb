class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :dive, optional: true
  belongs_to :dive_comment, optional: true
  belongs_to :room, optional: true
  belongs_to :message, optional: true

  belongs_to :visitor, class_name: "User", optional: true
  belongs_to :visited, class_name: "User", optional: true
end
