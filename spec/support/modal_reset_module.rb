module ModalResetModule
  def modal_reset
    visit current_path
  end
  def local_storage_reset(user)
    visit profile_path(user)
    find('#local_storage_reset').click
  end
end
