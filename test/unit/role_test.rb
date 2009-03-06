require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_required_name
    role = Role.create(:name => nil)
    assert role.errors.on(:name)
  end

  def test_no_required_is_admin
    role = Role.create(:is_admin => nil)
    assert !role.errors.on(:is_admin)
  end

  def test_no_required_is_default
    role = Role.create(:is_default => nil)
    assert !role.errors.on(:is_default)
  end

  def test_no_required_forum_ids
    role = Role.create(:forum_ids => nil)
    assert !role.errors.on(:forum_ids)
  end

  def test_no_required_rights_to_own_topic
    role = Role.create(:rights_to_own_topic_create => nil, :rights_to_own_topic_update => nil, :rights_to_own_topic_update => nil)
    assert !role.errors.on(:rights_to_own_topic_create)
    assert !role.errors.on(:rights_to_own_topic_update)
    assert !role.errors.on(:rights_to_own_topic_delete)
  end

  def test_on_required_right_to_other_topic
    role = Role.create(:rights_to_other_topic_create => nil, :rights_to_other_topic_update => nil, :rights_to_other_topic_update => nil)
    assert !role.errors.on(:rights_to_other_topic_create)
    assert !role.errors.on(:rights_to_other_topic_update)
    assert !role.errors.on(:rights_to_other_topic_delete)
  end

  def test_no_required_rights_to_own_post
    role = Role.create(:rights_to_own_post_create => nil, :rights_to_own_post_update => nil, :rights_to_own_post_update => nil)
    assert !role.errors.on(:rights_to_own_post_create)
    assert !role.errors.on(:rights_to_own_post_update)
    assert !role.errors.on(:rights_to_own_post_delete)
  end

  def test_on_required_right_to_other_post
    role = Role.create(:rights_to_other_post_create => nil, :rights_to_other_post_update => nil, :rights_to_other_post_update => nil)
    assert !role.errors.on(:rights_to_other_post_create)
    assert !role.errors.on(:rights_to_other_post_update)
    assert !role.errors.on(:rights_to_other_post_delete)
  end

  def test_user_has_right_to_own_post_create
    assert roles(:user).right_to?(true, :post, :create)
  end

  def test_user_has_not_right_to_own_post_update
    assert !roles(:user).right_to?(true, :post, :update)
  end

  def test_user_has_not_right_to_own_post_delete
    assert !roles(:user).right_to?(true, :post, :delete)
  end

  def test_user_has_not_right_to_other_post_all_operations
    assert !roles(:user).right_to?(false, :post, :create)
    assert !roles(:user).right_to?(false, :post, :update)
    assert !roles(:user).right_to?(false, :post, :delete)
  end

  def test_user_has_not_right_to_own_topic_create
    assert roles(:user).right_to?(true, :topic, :create)
  end

  def test_user_has_not_right_to_own_topic_update
    assert !roles(:user).right_to?(true, :topic, :update)
  end

  def test_user_has_not_right_to_own_topic_delete
    assert !roles(:user).right_to?(true, :topic, :delete)
  end

  def test_user_has_not_right_to_other_topic_all_operations
    assert !roles(:user).right_to?(false, :topic, :create)
    assert !roles(:user).right_to?(false, :topic, :update)
    assert !roles(:user).right_to?(false, :topic, :delete)
  end

  def test_admin_has_right_to_own_post_all_operations
    assert roles(:admin).right_to?(true, :post, :create)
    assert roles(:admin).right_to?(true, :post, :update)
    assert roles(:admin).right_to?(true, :post, :delete)
  end

  def test_admin_has_right_to_other_post_all_operations
    assert roles(:admin).right_to?(false, :post, :create)
    assert roles(:admin).right_to?(false, :post, :update)
    assert roles(:admin).right_to?(false, :post, :delete)
  end

  def test_admin_has_right_to_own_topic_all_operations
    assert roles(:admin).right_to?(true, :topic, :create)
    assert roles(:admin).right_to?(true, :topic, :update)
    assert roles(:admin).right_to?(true, :topic, :delete)
  end

  def test_admin_has_right_to_other_topic_all_operations
    assert roles(:admin).right_to?(false, :topic, :create)
    assert roles(:admin).right_to?(false, :topic, :update)
    assert roles(:admin).right_to?(false, :topic, :delete)
  end

end
