window.addEventListener('load', function() {
  const destroyBtn = document.getElementById('destroy_btn');
  const confirmDate = document.getElementById('confirm_date').value;
  const localStorageReset = document.getElementById('local_storage_reset');

  destroyBtn.addEventListener('click', function() {
    let check = confirm(confirmDate);
    if(check) {
      removeLocalStorage();
      document.getElementById('user_destroy').click();
    }
  });

  localStorageReset.addEventListener('click', function() {
    removeLocalStorage();
  });
  
  function removeLocalStorage() {
    localStorage.removeItem('LIVE_Pl@nning_preset_modal_first_display_on_or_not');
    localStorage.removeItem('LIVE_Pl@nning_inventory_list_modal_first_display_on_or_not');
    localStorage.removeItem('LIVE_Pl@nning_purchase_list_modal_first_display_on_or_not');
    localStorage.removeItem('LIVE_Pl@nning_schedule_modal_first_display_on_or_not');
    localStorage.removeItem('LIVE_Pl@nning_property_modal_first_display_on_or_not');
  }
}, false);