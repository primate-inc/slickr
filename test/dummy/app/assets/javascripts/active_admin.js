//= require active_admin/base
//= require active_admin_slickr
//= require_self

$(document).ready(function(){
  if($(".blank_slate_container").length > 0){
    $(".table_tools").hide()
  }
  var inputs = document.querySelectorAll('.file_modified input');
  Array.prototype.forEach.call(inputs, function(input) {
    var label = input.nextElementSibling,
    labelVal  = label.innerHTML;
    input.addEventListener('change', function(e) {
      var fileName = '';
      if( this.files && this.files.length > 1 )
        fileName = ( this.getAttribute( 'data-multiple-caption' ) || '' ).replace( '{count}', this.files.length );
      else
        fileName = e.target.value.split( '\\' ).pop();
      if(fileName)
        label.nextSibling.innerHTML = "New file name: "+fileName;
      else
        label.innerHTML = labelVal;
    });
  });
})
