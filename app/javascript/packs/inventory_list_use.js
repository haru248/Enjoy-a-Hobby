window.onload = function(){
  let checkboxs = document.getElementsByName('check');
  document.getElementById('checked_hide_true').onclick = function(){
    let rbtncheck = document.getElementById('checked_hide_true');
    if(rbtncheck.checked){
      for(let i = 0; i < checkboxs.length; i++){
        if(checkboxs[i].checked){
          document.getElementsByClassName(checkboxs[i].value)[0].style.display = 'none';
        }
      }
    }
  }
  document.getElementById('checked_hide_false').onclick = function(){
    let rbtncheck = document.getElementById('checked_hide_false');
    if(rbtncheck.checked){
      for(let i = 0; i < checkboxs.length; i++){
        document.getElementsByClassName(checkboxs[i].value)[0].style.display = 'block';
      }
    }
  }
  for(let n = 0; n < checkboxs.length; n++){
    document.getElementsByName('check')[n].onclick = function(){
      let rbtncheck = document.getElementById('checked_hide_true');
      if(rbtncheck.checked){
        for(let i = 0; i < checkboxs.length; i++){
          if(checkboxs[i].checked){
            document.getElementsByClassName(checkboxs[i].value)[0].style.display = 'none';
          }
        }
      }
    }
  }
}