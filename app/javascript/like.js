$(document).ready(function() {
  $(document).on('click', '.btn-like', function() {
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
      $.ajax({
        url: `/${likeableType.toLowerCase()}s/${likeableId}/likes`,
        method: 'DELETE',
        data: {
          likeable_id: likeableId,
          likeable_type: likeableType,
        }
      })
    } else {
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
