$(document).ready(function() {
  $(document).on('click', '.btn-dropdown', function() {
    $('.dropdown-menu').toggle();
  });

  $(document).on('click', '.dropdown-item', function() {
    $('.dropdown-menu').hide();
  });

  $(document).on('click', '.dropdown-item', function() {
    const self = $(this);
    const sortBy = self.data('sort-by');
    $.ajax ({
      url: '/posts',
      method: 'GET',
      data: {
        sort_by: sortBy,
      },
      dataType: 'script',
      success: function(data) {
        $('.posts-container').html(data);
        applyButtonStyling();
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
