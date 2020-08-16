document.addEventListener("click", function (event) {
  var toggle = document.getElementById("dropdown-toggle");
  var menu = document.getElementById("navigation");

  if (!menu.contains(event.target) && toggle.checked == true) {
    toggle.checked = false;
  }
});
