document.addEventListener('turbolinks:load', () => {

  let select = document.getElementById('countries');

  countries.addEventListener('change', (ev) => {
    if(ev.target.value == ''){
      window.location.href = '/';
    }else{
      window.location.href = '/?country='+ev.target.value;
    }
  });

  params = window.location.search.substr(1);
  let urlParams = new URLSearchParams(params);
  let country = urlParams.get('country');
  if(country==null){
    select.value = '';
  }else{
    select.value = country;
  }

});
