class Chat < ApplicationRecord
  
  belongs_to        :room
  belongs_to        :user
  
  validates :user_id,         presence: true
  validates :room_id,         presence: true
  validates :chat_comment,    presence: true
end
