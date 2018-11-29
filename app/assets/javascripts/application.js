// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require activestorage
//= require_tree .

$(document).ready(function() {
  var requestInProgress = false;
  var requestPending = false;
  var searchText;

  function getCSRFTokenValue() {
    return $("[name=csrf-token]").attr("content");
  }

  function searchSpells(searchText) {
    if (requestInProgress) {
      requestPending = $(".js-spell-search").val();
    } else {
      makeAjaxRequest(searchText);
    }
  }

  function makeAjaxRequest(searchText) {
    requestInProgress = true;
    var csrfToken = getCSRFTokenValue();

    $.ajax({
      url: "spells/search",
      method: "POST",
      data: {
        search_text: searchText
      },
      beforeSend: function(xhr) {
        xhr.setRequestHeader("X-CSRF-Token", csrfToken);
      },
      success: function(data) {
        $(".js-spell-results").html(data);
      },
      error: function(data) {
        console.log(data)
      },
      complete: function() {
        requestInProgress = false;
        if (requestPending) {
          makeAjaxRequest(requestPending)
          requestPending = false;
        }
      }
    });
  }

  $(".js-spell-search").on("keyup", function() {
    searchSpells($(this).val());
  });

  $(window).on("load", function() {
    var searchTimer = $(".js-spell-search").val();
    if (searchTimer) {
      searchSpells(searchTimer);
    }
  });
});