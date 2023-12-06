$(document).ready(function() {
  $('#post_comment').on('keypress', function(event) {
    if (event.which === 13) { // 13 is the key code for Enter
      addComment();
    }
    function addComment() {
      const commentText = $('#post_comment').val();
      const parentId  = $('#post_comment').data('parent-id');

      if (commentText === '') {
        alert ('comment cannot be blank');
        return
      }

      let commentsCount = $('.comments_count');
      commentsCount.text(parseInt(commentsCount.text(), 10) + 1);

      $.ajax({
        url: '/posts/' + parentId + '/comments',
        method: 'POST',
        data: {
          comment: {
            content: commentText,
          },
          commentable_type: 'Post',
          commentable_id: parentId,
        },
        success: function(data) {
          const commentsContainer = document.querySelector('.comments-container');
          const tempContainer = document.createElement('div');
          tempContainer.innerHTML = data.attachment_partial;
          commentsContainer.insertAdjacentHTML('afterbegin', tempContainer.innerHTML);
          
          $('#post_comment').val('');
        },
      })
    }
  });

  $(document).on('keypress', '.comment_comment', function(event) {
    
    if (event.which === 13) {
      addComment();
    }
    function addComment() {
      const commentText = $(event.target).val();
      const parentId  = $(event.target).data('parent-id');

      if (commentText === '') {
        alert ('comment cannot be blank');
        return
      }

      $.ajax({
        url: '/comments/' + parentId + '/comments',
        method: 'POST',
        data: {
          comment: {
            content: commentText,
          },
          commentable_type: 'Comment',
          commentable_id: parentId,
        },
        success: function(data) {
          const newCommentRow = $(event.target).closest('.new-comment-row');
          const interactions = newCommentRow.next('.interactions.comment');
        
          const commentsComments = interactions.next('.comments-comments');
         
          const tempContainer = document.createElement('div');
          tempContainer.innerHTML = data.attachment_partial
          commentsComments.prepend(tempContainer);

          const linkToComments = interactions.find('.link-to-comments');
          const commentsCountElement = linkToComments.find('.comment-count');
          let currentCount = parseInt(commentsCountElement.text(), 10) || 0;
          currentCount++;
          commentsCountElement.text(currentCount.toString());

          commentsComments.show();
  
          $(event.target).val('');
        },
      })
    }
  });

  $(document).on('click', '.link-to-comments', function(event) {
    const interactions = $(event.target).closest('.interactions.comment');
    const commentsComments = interactions.next('.comments-comments');
    commentsComments.slideToggle();
  });
});
