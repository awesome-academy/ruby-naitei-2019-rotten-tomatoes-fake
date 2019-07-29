class Episode < ApplicationRecord
  belongs_to :season
  has_one :medium, as: :reviewable, dependent: :destroy

  validates :info, presence: true,
    length: {maximum: Settings.episodes.info_max_length}

  scope :season, ->(season_id){where(season_id: season_id)}
  scope :season_critic_score, ->(id){season(id).average(:critic_score)}
  scope :season_audien_score, ->(id){season(id).average(:audience_score)}
end
