class Commentary < ApplicationRecord
  belongs_to :user
  belongs_to :forum_post
end
