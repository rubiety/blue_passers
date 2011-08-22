$(function() {
  BluePassers.initialize();
});

var BluePassers = {
  initialize: function() {
    BluePassers.sort_leaderboard_table();
  },

  sort_leaderboard_table: function() {
    $("#leaderboard table").tablesorter();
  }
};
