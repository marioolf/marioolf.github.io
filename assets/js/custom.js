document.addEventListener('DOMContentLoaded', function () {
  var anchors = document.querySelectorAll('a[href]');

  anchors.forEach(function (anchor) {
    var href = anchor.getAttribute('href');
    var url;

    if (!href || href.charAt(0) === '#') {
      return;
    }

    if (href.indexOf('mailto:') === 0 || href.indexOf('tel:') === 0 || href.indexOf('javascript:') === 0) {
      return;
    }

    url = new URL(href, window.location.origin);

    if (url.origin === window.location.origin) {
      anchor.removeAttribute('target');
      anchor.removeAttribute('rel');
      return;
    }

    anchor.setAttribute('target', '_blank');
    anchor.setAttribute('rel', 'noopener noreferrer');
  });
});