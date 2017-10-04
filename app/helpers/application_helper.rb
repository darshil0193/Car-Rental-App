module ApplicationHelper
  def is_user_admin_or_superadmin?
    current_user.admin? or current_user.superadmin?
  end
end
