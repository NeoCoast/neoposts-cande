$(document).ready(function() {

  let cleanupData = localStorage.getItem('cleanupData');

  if (cleanupData) {
    localStorage.removeItem('cleanupData');

    window.location.reload();
  }

  $(window).on('beforeunload', function () {
    localStorage.setItem('cleanupData', 'some data');
  });

  $(document).on('click', '.btn-delete', function() {
    const modal = $(event.target).next('.modal');
    modal.show();
  });

  $(document).on('click', '.close-modal', function() {
    $('.modal').hide();
  });

  $('.btn-delete-post').on('click', function () {
    const self = $(this);
    let postId = self.data('post-id');
    let inIndex = self.data('in-index');
    $('#modalId').hide();
    $.ajax({
      url: '/posts/' + postId,
      type: 'DELETE',
      success: function (result) {
        $('.modal').hide();

        if (inIndex) {
          self.closest('.row').remove();
          const postsContainer = document.querySelector(".posts-container");
          if (! postsContainer.querySelectorAll('.row-user').length) {
            const newDiv = document.createElement('div');
            newDiv.style.margin= '20px 45px';
            newDiv.textContent = 'No posts found';
            postsContainer.appendChild(newDiv);
          } 
        }
        else {
          window.history.back();
          $(window).on('beforeunload', function () {
            $(window).off('beforeunload');
                
            setTimeout(function () {
              window.location.reload();
            }, 1000); 
          });
        }
      }
    });
  });

  $(document).on('click', '.back-btn', function() {
    window.history.back();
  });
});
