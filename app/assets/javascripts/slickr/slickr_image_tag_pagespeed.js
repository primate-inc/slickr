$(function () {
  $('.slickr_image_tag').each(function(i, obj) {
    var image = obj.getElementsByTagName('img')[0];
    var sourceTags = obj.getElementsByTagName('source');

    for (var i = 0; i < sourceTags.length; i++) {
      var srcSet = sourceTags[i].dataset.srcset;
      sourceTags[i].setAttribute('srcset', srcSet);
    }

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
