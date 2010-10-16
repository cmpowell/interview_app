// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
document.on("click", "a[popup]", function(event, element) {
  if (event.stopped) return; 
  window.open($(element).href); 
  event.stop(); 
});