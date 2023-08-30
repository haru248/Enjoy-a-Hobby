window.addEventListener('load', function() {
  const agreeCheckBox = document.getElementById('agree_check_box');
  const registerBtn = document.getElementById('register_btn');
  registerBtn.disabled = true;

  agreeCheckBox.addEventListener('change', function() {
    if (this.checked) {
      registerBtn.disabled = false;
    } else {
      registerBtn.disabled = true;
    }
  }, false);
}, false);