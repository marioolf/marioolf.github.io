document.addEventListener('DOMContentLoaded', function () {
  var postAnchors = document.querySelectorAll('a[href^="/posts/"], a[href^="https://marioolf.github.io/posts/"]');

  postAnchors.forEach(function (anchor) {
    var href = anchor.getAttribute('href');
    var url;

    if (!href) {
      return;
    }

    url = new URL(href, window.location.origin);

    if (!url.pathname.startsWith('/posts/') || url.pathname === '/posts/') {
      anchor.removeAttribute('target');
      anchor.removeAttribute('rel');
      return;
    }

    anchor.setAttribute('target', '_blank');
    anchor.setAttribute('rel', 'noopener noreferrer');
  });
});