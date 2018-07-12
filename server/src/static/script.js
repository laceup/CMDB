$(document).ready(function () {
  console.log('document loaded')
  
  $('#searchTextBox').keyup(function (e) {
    console.log('keyup: ', e.which)
    if (e.which == 13) {
      console.log('key is enter')
      e.preventDefault();
      console.log("navigating to ", "/?search="+$('#searchTextBox').val())
      window.location.replace("/?search="+$('#searchTextBox').val())
    }
  });

  $('#searchButton').click(function (e) {
    e.preventDefault();
    window.location.replace("/?search="+$('#searchTextBox').val())
  });

  $('table.download_table').DataTable({});




});
// CYTOSCAPE

// -----------