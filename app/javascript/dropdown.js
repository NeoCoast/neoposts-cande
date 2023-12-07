$(document).ready(function() {
  $(document).on('click', '.btn-dropdown', function() {
    $('.dropdown-menu').toggle();
  });

  $(document).on('click', '.dropdown-item, .btn-apply, .btn-clear', function() {
    $('.dropdown-menu').hide();

    if ($(this).hasClass('dropdown-item')) {
      var sortBy = $(this).data('sort-by');
    } else if ($(this).hasClass('btn-apply') || $(this).hasClass('btn-clear')) {
      var sortBy = $('.btn-dropdown').text();
    } 

    if ( $(this).hasClass('btn-clear'))  {
      $('input[name="date_filter"]:checked').prop('checked', false);
      $('.body-filter').val('');
      $('.title-filter').val('');
      $('.author-filter').val('');
    }

    let authorFilter = $('.author-filter').val();
    let titleFilter = $('.title-filter').val();
    let bodyFilter = $('.body-filter').val();
    let dateFilter = $('input[name="date_filter"]:checked').val();

    $.ajax ({
      url: '/posts',
      method: 'GET',
      data: {
        sort_by: sortBy,
        author_filter: authorFilter,
        title_filter: titleFilter,
        body_filter: bodyFilter,
        date_filter: dateFilter
      },
      dataType: 'json',
      success: function(data) {
        $('.posts-container').html(data.attachment_partial);
        if (data.attachment_partial === ' ') {
          const postsContainer = document.querySelector(".posts-container");
          const newDiv = document.createElement('div');
          newDiv.style.margin= '20px 45px';
          newDiv.textContent = 'No posts found';
          postsContainer.appendChild(newDiv);
        }
        applyButtonStyling();
        $('.btn-dropdown').text(sortBy);
      }
    });
  });

  function applyButtonStyling() {
    $('.btn-like').each(function() {
      const self = $(this);
      const liked = self.data('liked');
      const styleClass = liked ? 'btn-unlike' : 'btn-like';
      self.removeClass('btn-like btn-unlike').addClass(styleClass);
    });
  }
});
