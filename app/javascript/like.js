$(document).ready(function() {
  $('.btn-like').each(function() {
    const self = $(this);
    const liked = self.data('liked');
    const styleClass = liked ? 'btn-unlike' : 'btn-like';
    self.addClass(styleClass);
  });

  $(document).on('click', '.btn-like, .btn-unlike', function() {
    const self = $(this);
    const liked = self.data('liked');
    const interactionsRow = event.target.closest('.interactions');
    const likeCount = interactionsRow.querySelector('.likes_count');
    let currentCount = parseInt(likeCount.textContent, 10) || 0;
    liked ? currentCount-- : currentCount++;
    likeCount.textContent = currentCount;
    const likeableId  = self.data('likeable-id');
    const likeableType = self.data('likeable-type');

    if (liked) {
      self.removeClass('btn-unlike').addClass('btn-like');
      $.ajax({
        url: `/${likeableType.toLowerCase()}s/${likeableId}/likes`,
        method: 'DELETE',
        data: {
          likeable_id: likeableId,
          likeable_type: likeableType,
        }
      })
    } else {
      self.removeClass('btn-like').addClass('btn-unlike');
      $.ajax({
        url: `/${likeableType.toLowerCase()}s/${likeableId}/likes`,
        method: 'POST',
        data: {
          likeable_type: likeableType,
          likeable_id: likeableId,
        },
      })
    } 
    self.data('liked', !liked);
  });
});
