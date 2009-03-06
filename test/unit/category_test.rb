require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  fixtures :categories, :forums
  
  # Replace this with your real tests.
  def test_required_name
    category = Category.create(:name => nil)
    assert category.errors.on(:name)
  end

  def test_create_category
    category = Category.create(:name => "New category")
    assert !category.new_record?
  end

  def test_forums_association
    forums1 = [forums(:one), forums(:two)].sort { |x, y| x.id <=> y.id }
    forums2 = categories(:one).forums.sort { |x, y| x.id <=> y.id }
    assert_equal forums1, forums2
  end
end
