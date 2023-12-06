$(document).ready(function() {

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
          if ( postsContainer.querySelectorAll('.row').length === 0) {
            const newDiv = document.createElement('div');
            newDiv.style.margin= '20px 45px';
            newDiv.textContent = 'No posts found';
            postsContainer.appendChild(newDiv);
          }
          document.querySelector(".post-count").textContent = parseInt(document.querySelector(".post-count").textContent) - 1;
        }
        else {
          let previousPageUrl = document.referrer;

          window.location.href = previousPageUrl;

          setTimeout(function () {
            window.location.reload();
          }, 1000);
        }
      }
    });
  });

  $(document).on('click', '.back-btn', function() {
    let previousPageUrl = document.referrer;

    window.location.href = previousPageUrl;

    setTimeout(function () {
      window.location.reload();
    }, 1000);
  });
});
