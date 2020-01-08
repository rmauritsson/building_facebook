# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :comments
  has_many :likes
  has_many :sent_requests, foreign_key: :sender_id, class_name: 'Friendship'
  has_many :received_requests, foreign_key: :receiver_id, class_name: 'Friendship'

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }

  def already_like?(post)
    Like.exists?(user_id: id, post_id: post.id)
  end

  def like(post)
    return if already_like?(post)

    likes.create(post_id: post.id)
  end

  def unlike(post)
    like = Like.find_by(user_id: id, post_id: post.id)
    like&.destroy
  end

  def friends
   friends_array = received_requests.map do  |u|
   u.sender if u.confirmed
   end
   friends_array = friends_array + sent_requests.map do |u|
   u.receiver if u.confirmed
   end
   friends_array.compact
 end
end
