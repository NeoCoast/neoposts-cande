const { comment } = require("postcss");

$(document).ready(function() {

  $('#post_comment').on('keypress', function(event) {
    if (event.which === 13) { // 13 is the key code for Enter
      addComment();
    }
    function addComment() {
      const commentText = $('#post_comment').val();
      const parentId  = $('#post_comment').data('parent-id');

      if (commentText === '') {
        return;
      }

      let commentsCount = $('.comments_count');
      commentsCount.text(parseInt(commentsCount.text(), 10) + 1);

      const commentsContainer = document.querySelector('.comments-container');

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
        return;
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
            const newCommentRow = event.target.closest('.new-comment-row');
            const commentsComments = newCommentRow.previousElementSibling;
            const tempContainer = document.createElement('div');
            tempContainer.innerHTML = data.attachment_partial;
            commentsComments.insertBefore(tempContainer.firstChild, commentsComments.firstChild);
            
  
            const commentRowAbove = commentsComments.previousElementSibling;
            const linkelement = commentRowAbove.querySelector('.link-to-comments');
            const commentsCount = linkelement.querySelector('.comment-count');
            let currentCount = parseInt(commentsCount.textContent, 10) || 0;
            currentCount += 1;
            commentsCount.textContent = currentCount;
  
            commentsComments.style.display = 'block';
  
            $(event.target).val('');
        },
      })
    }
  });

  $(document).on('click', '.link-to-comments', function(event) {
    const commentsComments = $(this).closest('.comment-row').next('.comments-comments');
    commentsComments.slideToggle();
  });
});
