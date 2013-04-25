var setupImages = function() {
  ['difference', 'animation', 'oldImage', 'newImage'].forEach(function(element) {
    $('body').append('<img id="' + element + '"></img>');
  });
};

var tearDownImages = function() {
  ['difference', 'animation', 'oldImage', 'newImage'].forEach(function(element) {
    $('#' + element).remove();
  });
};

var setupButtonsAndForm = function() {
  var buttons =
    ' <div id="buttonBar" style="width: 400px; margin: 0px auto"> ' +
    ' <button id="differenceButton">Difference</button> ' +
    ' <button id="animationButton">Animation</button> ' +
    ' <button id="oldImageButton">Old Image</button> ' +
    ' <button id="newImageButton">New Image</button> ' +
    ' <form action="/screenshots" class="artifacts" method="POST">' +
    '   <input id="filepath" name="filepath" type="hidden" value=""> ' +
    '   <input type="submit" value="Accept" id="accept"> ' +
    ' </form> ' +
    ' </div> ';
  $('body').append(buttons);
};

var tearDownButtonsAndForm = function() {
  $('#buttonBar').remove();
};
