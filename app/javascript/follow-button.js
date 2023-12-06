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
    const currentId = self.data('current-id');
    const following = self.data('follows');
    const isCurrentUser = self.data('is-current-user');
    const isSideUser = self.data('is-side-user');
    const inFollowing = self.data('in-following');
    const inFollowers = self.data('in-followers');
    const targetRow = $(".row-user[data-user-id='" + userId + "']");
    const targetRowCurrent = $(".row-user[data-user-id='" + currentId + "']");

    let followersCount = $('.followers_count');
    let followingCount = $('.following_count');

    if (following) {
      self.text('Follow');
      self.removeClass('btn-unfollow').addClass('btn-follow');
      if (isCurrentUser) {
        followingCount.text(parseInt(followingCount.text(), 10) - 1);
        if (inFollowing) {
          targetRow.remove();
          const followersContainer = document.querySelector(".followers-container");
          if (followersContainer.querySelectorAll('.row-user').length === 0) {

            const followersContainer = document.querySelector(".followers-container");
            const newDiv = document.createElement('div');

            newDiv.style.margin= '20px 45px';
            newDiv.textContent = 'No users found';
            followersContainer.appendChild(newDiv);
          } 
        }

      } else if (isSideUser) {
        followersCount.text(parseInt(followersCount.text(), 10) - 1);
        if (inFollowers) {
          targetRowCurrent.remove();

          const followersContainer = document.querySelector(".followers-container");
          if (followersContainer.querySelectorAll('.row-user').length === 0) {
            const followersContainer = document.querySelector(".followers-container");
            const newDiv = document.createElement('div');
            newDiv.classList.add('.no-followers');

            newDiv.style.margin= '20px 45px';
            newDiv.textContent = 'No users found';
            followersContainer.appendChild(newDiv);
          } 
        }
      }
      $.ajax({
        url: '/relationships/' + userId,
        method: 'DELETE',
        data: {
          relationship: {
            followed_id: userId
          }
        },
      })
    }

    else {
      self.text('Unfollow');
      self.removeClass('btn-follow').addClass('btn-unfollow');
      if (isCurrentUser) {
        followingCount.text(parseInt(followingCount.text(), 10) + 1);
      } else if (isSideUser) {
        followersCount.text(parseInt(followersCount.text(), 10) + 1);
      }
      $.ajax({
        url: '/relationships',
        method: 'POST',
        data: {
          relationship: {
            followed_id: userId
          }
        },
        success: function(data) {
          if (isSideUser && inFollowers) {
            const followersContainer = document.querySelector(".followers-container");

            if (followersContainer.querySelectorAll('.row-user').length === 0) {
              const secondChild = followersContainer.children[1];
              secondChild.remove();
            }
            const tempContainer = document.createElement('div');
            tempContainer.innerHTML = data.attachment_partial;
            followersContainer.appendChild(tempContainer.firstChild);
          }
        },
      })
    }
    self.data('follows', !following);
  });
}); 
