$(document).ready(function() {
  $('.btn-follow').each(function() {
    const self = $(this);
    const following = self.data('follows');
    const styleClass = following ? 'btn-unfollow' : 'btn-follow';
    self.addClass(styleClass);
  });

  $(document).on('click', '.btn-follow, .btn-unfollow', function() {
    const self = $(this);
    const userId = self.data('user-id');
    const following = self.data('follows');
    if (following) {
      self.text('Follow');
      self.removeClass('btn-unfollow').addClass('btn-follow');
      $.ajax({
        url: '/relationships/' + userId,
        method: 'DELETE',
        data: {
          relationship: {
            followed_id: userId
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
            followed_id: userId
          }
        }
      });
    }
    self.data('follows', !following);
  });
}); 
