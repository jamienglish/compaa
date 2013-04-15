var Compaa = (function() {
  var Compaa = function() {
    this.imageTypes = ['difference', 'animation', 'oldImage', 'newImage'];
  };

  Compaa.prototype = {
    queryString: function() {
      return window.location.search.replace('?', '');
    },

    filepath: function() {
      var params = this.queryString().split('&');

      for (var i=0; i < params.length; i++) {
        var keyAndVal = params[i].split('=');
        if (keyAndVal[0] === 'filepath') {
          return keyAndVal[1];
        }
      }
    },

    differenceGifPath: function() {
      return this.filepath();
    },

    oldImagePath: function() {
      return this.differenceGifPath()
        .replace('differences_in_screenshots_this_run', 'reference_screenshots')
        .replace('_difference.gif', '');
    },

    newImagePath: function() {
      return this.oldImagePath()
        .replace('reference_screenshots', 'screenshots_generated_this_run');
    },

    hideAllById: function(ids) {
      document.getElementById(ids.pop()).style.display = 'none';

      if (ids.length !== 0) {
        this.hideAllById(ids);
      }
    },

    duplicate: function(arg) {
      return arg.slice(0);
    },

    show: function(mode) {
      this.hideAllById(this.duplicate(this.imageTypes));
      document.getElementById(mode).style.display = 'block';
    },

    attachButtonClickHandlers: function() {
      var that = this;
      this.imageTypes.forEach(function(element) {
        document.getElementById(element + 'Button').onclick = function() {
          that.show(element);
        };
      });
    },

    drawDifferenceCanvas: function() {
      var newImg, oldImg, over, under;

      oldImg = document.createElement('img');
      oldImg.src = this.oldImagePath();

      newImg = document.createElement('img');
      newImg.src = this.newImagePath();

      over  = document.getElementById('offScreenCanvas').getContext('2d');
      under = document.getElementById('difference').getContext('2d');

      oldImg.onload = function() {
        newImg.onload = function() {
          document.getElementById('difference').width       = oldImg.width;
          document.getElementById('difference').height      = oldImg.height;
          document.getElementById('offScreenCanvas').width  = newImg.width;
          document.getElementById('offScreenCanvas').height = newImg.height;

          over.drawImage(oldImg, 0, 0);
          under.drawImage(newImg, 0, 0);
          over.blendOnto(under, 'difference');
        };
      };
    },

    init: function() {
      this.drawDifferenceCanvas();
      this.show('difference');
      this.attachButtonClickHandlers();

      document.getElementById('animation').src = this.differenceGifPath();
      document.getElementById('oldImage').src = this.oldImagePath();
      document.getElementById('newImage').src = this.newImagePath();

      // set filepath input used for form POSTing
      document.getElementById('filepath').value = this.newImagePath();
    }
  };

  return Compaa;
})();
