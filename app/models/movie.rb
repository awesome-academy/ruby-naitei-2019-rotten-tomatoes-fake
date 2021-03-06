class Movie < ApplicationRecord
  include Search
  after_create :create_medium

  has_one :medium, as: :reviewable, dependent: :destroy

  mount_uploader :poster, PosterUploader

  scope :create_desc, ->{order updated_at: :desc}
  scope :create_top_score, (
    lambda do
      sort_by{|m| [m.score(:critic), m.score(:normal)]}.reverse
    end)

  scope :load_all, (
  lambda do
    joins(:celebrities).all.select("movies.id, "\
    "celebrities.name, movies.name as film_name,movies.release_date")
  end)
  scope :list_search, ->(movies_id){find(movies_id)}

  scope :celebrities_list, (
    lambda do |movie_id|
      Celebrity.where(
        id: includes(medium:
          [celebrity_media: :celebrity]).where(id: movie_id)
                                        .pluck("celebrities.id")
      )
    end)

  ATTR = %i(name release_date critic_score audience_score info poster).freeze
  validates :name, presence: true,
    length: {maximum: Settings.movies.name_max_length}
  validates :info, presence: true,
    length: {maximum: Settings.movies.info_max_length}

  def score user_role
    medium.reviews
          .joins(:user).merge(User.role(user_role))
          .average(:score) || Settings.not_review_yet
  end
end
