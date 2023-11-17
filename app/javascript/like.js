$(document).ready(function() {
  $('.btn-like').each(function() {
    const self = $(this);
   // const following = self.data('follows');
   // const styleClass = following ? 'btn-unfollow' : 'btn-follow';
   // self.addClass(styleClass);
  });

  $(document).on('click', '.btn-like', function() {
    const self = $(this);
    const liked = self.data('liked');
    const InteractionsRow = event.target.closest('.interactions');
    const followingCount = InteractionsRow.querySelector('.likes_count');
    let currentCount = parseInt(followingCount.textContent, 10) || 0;
    liked ? currentCount -- : currentCount ++;
    followingCount.textContent = currentCount;
    const likeableId  = $(event.target).data('liakeable-id');
    const likeableType  = $(event.target).data('likeable-type');

    if (liked) {
      if (likeableType == 'Post') {
        $.ajax({
          url: '/posts/' + likeableId + '/likes',
          method: 'DELETE',
          data: {
            likeable_id: likeableId,}
        })
      }
      else {
        $.ajax({
          url: '/comments/' + likeableId + '/likes',
          method: 'DELETE',
          data: {
            likeable_id: likeableId,}
        })
      }
    } else {
      if (likeableType == 'Post') {
        $.ajax({
          url: '/posts/' + likeableId + '/likes',
          method: 'POST',
          data: {
            likeable_type: likeableType,
            likeable_id: likeableId,
          },
        })
      } else{
        $.ajax({
          url: '/comments/' + likeableId + '/likes',
          method: 'POST',
          data: {
            likeable_type: likeableType,
            likeable_id: likeableId,
          },
        })
      }
    }
    self.data('liked', !liked);
  });
});
