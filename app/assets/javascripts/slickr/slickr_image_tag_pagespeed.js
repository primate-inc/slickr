$(function () {
  $('.slickr_image_tag').each(function(i, obj) {
    var image = obj.getElementsByTagName('img')[0];

    if (image.hasAttribute('data-pagespeed-lazy-src')) {
      var minAspectRatio = image.dataset.min_aspect_ratio;
      var width = image.offsetWidth;
      image.style.minHeight = (width * minAspectRatio) + 'px';
    }
  });

  window.addEventListener('resize', function(i, obj) {
    $('.slickr_image_tag').each(function(i, obj) {
      var image = obj.getElementsByTagName('img')[0];

      if (!image.hasAttribute('data-pagespeed-lazy-src')) {
        image.style.minHeight = null
      }
    });
  });
})
