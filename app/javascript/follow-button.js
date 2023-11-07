import jquery from 'jquery'
window.jQuery = jquery
window.$ = jquery

$(document).ready(function() {
  $('.btn-follow').each(function() {
    var self = $(this);
    var following = self.data('follows');
    var styleClass = following ? 'btn-unfollow' : 'btn-follow';
    self.addClass(styleClass);
  });

  $(document).on('click', '.btn-follow, .btn-unfollow', function() {
    var self=$(this);
    var user_id = self.data('user-id');
    var following = self.data('follows');
    if (following) {
      self.text('Follow');
      self.removeClass('btn-unfollow').addClass('btn-follow');
      $.ajax({
        url: '/relationships/' + user_id,
        method: 'DELETE',
        data: {
          relationship: {
            followed_id: user_id
          }
        }
      });
    }
    else {
      self.text('Unfollow');
      self.removeClass('btn-follow').addClass('btn-unfollow');
      $.ajax({
        url: '/relationships',
        method: 'POST',
        data: {
          relationship: {
            followed_id: user_id
          }
        }
      });
    }
    self.data('follows', !following);
  });
}); 
