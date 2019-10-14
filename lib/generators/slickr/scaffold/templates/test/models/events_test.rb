require "test_helper"

class NewsArtcileTest < ActiveSupport::TestCase
  context "relations" do
    should have_one(:event_header_image)
    should have_one(:event_thumbnail)
  end

  context "validations" do
    should validate_presence_of(:title)
    should validate_presence_of(:category)
    should validate_inclusion_of(:category).in_array(::Event::CATEGORIES.map(&:to_s))
  end

  context "database" do
    should have_db_column(:slug).of_type(:string)
    should have_db_column(:title).of_type(:string)
    should have_db_column(:header).of_type(:text)
    should have_db_column(:featured).of_type(:boolean).with_options(null: false, default: false)
    should have_db_column(:category).of_type(:string)
    should have_db_column(:header_image).of_type(:string)
    should have_db_column(:thumbnail).of_type(:string)
    should have_db_column(:content).of_type(:text)
    should have_db_column(:start_time).of_type(:datetime)
    should have_db_column(:end_time).of_type(:datetime)
    should have_db_column(:location).of_type(:string)

    should have_db_column(:created_at).of_type(:datetime)
    should have_db_column(:updated_at).of_type(:datetime)

    should have_db_index(:slug)
  end
end
