/**
 * ustwo™ Jenkins Dashboard Front-end scripts.
 * @author: nuno@ustwo.co.uk (Nuno Coelho Santos)
 */

/**
 * Update the numbers on an element incrementally based on it's speed attribute.
 * @param el = the element or array of elements with a number to update.
 */

function updateFigures(el) {

  // Store all the elements on a variable.
  var $numbers = $(el);

  // Per each one of the elements, run functions.
  $numbers.each(function() {
    // Define the text element, the numerical value and the speed in which
    // the numerical value will be increased based on the data-speed attribute.
    var $number = $(this);

    var newValue = parseInt($number.text().replace(',', ''), 10); // Remove commas and convert to an integer.
    var oldValue = parseInt($number.attr('data-old-value').replace(',', ''), 10);  // Remove commas and convert to an integer.
    var currentValue = oldValue;
    var speed = 10;

    if(isNaN(newValue))
    {
      return;
    }

    // Update the text in the element before animating.
    $number.text(oldValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));

    setInterval(function() {

      // If the new value is higher than the old value.
      if (newValue > currentValue) {

        // Increase the new value by one.
        currentValue = currentValue + 1;

        // Update the number and add commas.
        $number.text(currentValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));

      }
      // If the new value is lower than the old value.
      else if (newValue < currentValue) {

        // Decrease the new value by one.
        currentValue = currentValue - 1;

        // Update the number and add commas.
        $number.text(currentValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));

      } else {

        return;

      };

    }, speed);

  });

};

/**
 * Display an array of items sequentially with a specific time gap.
 * @param el = array of elements to display.
 * @param gap = time gap in milliseconds to display the elements.
 * @param callback = a callback method to call when complete.
 */

function displaySequentially(el, gap, callback) {
  console.log("showing")
  // Store elements in a variable.
  var $items = $(el);

  // Hide elements in order to display them later.
  $items.hide();

  // Set interval and gap between animations.
  var interval = 0;
  var increment = gap;

  // On each one of the items.
  $items.each(function() {

    // Store this specific item on a new variable.
    var $item = $(this);

    // Increment the interval to cause delay between animations.
    interval = interval + increment;

    // Set a timeout for this item once its interval has finished.
    setTimeout(function() {
      $item.show();

      if($items.index($item) == $items.length - 1) {
        if(callback) {
          setTimeout(function() {
          callback();
          }, interval);
        }
      }
    }, interval);

  });

};

/**
 * Hide an array of items sequentially with a specific time gap.
 * @param el = array of elements to hide.
 * @param gap = time gap in milliseconds to hide the elements.
 * @param callback = a callback method to call when complete
 */
function hideSequentially(el, gap, callback) {
  // Store elements in a variable.
  var $items = $(el);

  // Set interval and gap between animations.
  var interval = 0;
  var increment = gap;

  // On each one of the items.
  $items.each(function() {

    // Store this specific item o a new variable.
    var $item = $(this);

    // Increment the interval to cause delay between animations.
    interval = interval + increment;

    // Set a timeout for this item once its interval has finished.
    setTimeout(function() {
      $item.addClass('out');

      if($items.index($item) == $items.length - 1) {
        if(callback) {
          setTimeout(function() {
            callback();
          }, interval);
        }
      }

    }, interval);

  });

};


$(document).ready(function(){
  //updateFigures('.figure');
  //displaySequentially('.project-development-stats li', 100);
  // setTimeout(function(){
  //   hideSequentially('.project-development-stats li', 100);
  // }, 12000);

});
