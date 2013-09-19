require 'spec_helper'

describe 'counter cache' do
  it 'works' do
    define_model('Topic', name: :string) do
      has_many :topics_trails
      has_many :trails, through: :topics_trails
    end

    define_model('Trail', name: :string, topics_count: :integer) do
      has_many :topics_trails
      has_many :topics, through: :topics_trails
    end

    define_model('TopicsTrail', topic_id: :integer, trail_id: :integer) do
      belongs_to :trail, counter_cache: :topics_count
      belongs_to :topic
    end

    FactoryGirl.define do
      factory :trail do
        name 'MyString'
      end

      factory :topic do
        name 'MyString'
      end
    end

    topics = [FactoryGirl.create(:topic), FactoryGirl.create(:topic)]
    trail = FactoryGirl.create :trail, topics: topics
    trail.reload
    expect(trail.topics_count).to eq 2
  end
end
