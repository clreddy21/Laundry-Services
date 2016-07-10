module StatusHelper
  def alternate_statuses(user)
    alternate_statuses = []
    if user.status == 'active'
      alternate_statuses = ['Blacklist', 'Suspend']
    elsif user.status == 'balcklisted'
      alternate_statuses = ['Activate', 'Suspend']
    elsif user.status == 'suspended'
      alternate_statuses = ['Activate', 'Blacklist']
    end
    alternate_statuses
    # raise user.status
    # raise alternate_statuses.inspect
  end
end
