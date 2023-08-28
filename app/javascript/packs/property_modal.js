window.addEventListener('load', function() {
  if(!localStorage.getItem('LIVE_Pl@nning_property_modal_first_display_on_or_not')) {
    localStorage.setItem('LIVE_Pl@nning_property_modal_first_display_on_or_not', 'on');
    const body = document.querySelector('body');
    const bgModalWindow = document.querySelector('.bg_modal_window');
    const modalRedisplay = document.querySelector('.modal_redisplay');
    let modalPage = 1;
    body.classList.add('open_modal');

    bgModalWindow.addEventListener('click', function() {
      changeModal();
    });

    modalRedisplay.addEventListener('click', function() {
      modalPage = 1;
      document.getElementById(`modal${modalPage}`).style.display = 'block';
      for(let i = 1; document.getElementById(`modal${modalPage + i}`); i++) {
        document.getElementById(`modal${modalPage + i}`).style.display = 'none';
      }
      body.classList.add('open_modal');
    });

    function changeModal() {
      modalPage += 1;
      var checkModal = document.getElementById(`modal${modalPage}`)
      if(checkModal) {
        document.getElementById(`modal${modalPage}`).style.display = 'block';
        document.getElementById(`modal${modalPage - 1}`).style.display = 'none';
      } else {
        body.classList.remove('open_modal');
      };
    }
  } else {
    const body = document.querySelector('body');
    const bgModalWindow = document.querySelector('.bg_modal_window');
    const modalRedisplay = document.querySelector('.modal_redisplay');
    let modalPage = 1;

    bgModalWindow.addEventListener('click', function() {
      changeModal();
    });

    modalRedisplay.addEventListener('click', function() {
      modalPage = 1;
      document.getElementById(`modal${modalPage}`).style.display = 'block';
      for(let i = 1; document.getElementById(`modal${modalPage + i}`); i++) {
        document.getElementById(`modal${modalPage + i}`).style.display = 'none';
      }
      body.classList.add('open_modal');
    });

    function changeModal() {
      modalPage += 1;
      var checkModal = document.getElementById(`modal${modalPage}`)
      if(checkModal) {
        document.getElementById(`modal${modalPage}`).style.display = 'block';
        document.getElementById(`modal${modalPage - 1}`).style.display = 'none';
      } else {
        body.classList.remove('open_modal');
      };
    }
  }
}, false);
