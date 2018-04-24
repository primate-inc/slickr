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

  /******************************************************************
  // Only show Page options if Parent type is Page for new Navigation
  /******************************************************************/
  $('#slickr_navigation_root_type').on('change', function(){
    if($(this).val() === 'Page') {
      $('#slickr_navigation_slickr_page_id_input').show();
    } else {
      $('#slickr_navigation_slickr_page_id_input').hide();
      $('#slickr_navigation_slickr_page_id').val('');
    }
  });
  if($('#slickr_navigation_root_type').length ) {
    $('#slickr_navigation_slickr_page_id_input').hide();
  }
  if($('#slickr_navigation_root_type').val() === 'true' ) {
    $('#slickr_navigation_slickr_page_id_input').show();
  }
})
