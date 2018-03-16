//= require activeadmin_reorderable

$(function () {
  var large_break = 1200;

  /******************************************************************
  // Hide drag/drop handles on smaller tables
  /******************************************************************/
  if($( window ).width() <= large_break) {
    $('.logged_in .index_as_reorderable_table tbody td.reorder-handle-col').parent().hide();
  }
  $(window).bind('resize', function(e) {
    if($( window ).width() <= large_break) {
      $('.logged_in .index_as_reorderable_table tbody td.reorder-handle-col').parent().hide();
    } else {
      $('.logged_in .index_as_reorderable_table tbody td.reorder-handle-col').parent().show();
    }
  });
})
