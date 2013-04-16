var Compaa = (function() {
  var Compaa = function() {
    this.imageTypes = ['difference', 'animation', 'oldImage', 'newImage'];
    this.compaaHost = '';
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

    getDifferenceImages: function(callback) {
      var xhr, url;
      xhr = new XMLHttpRequest();
      xhr.onload = function() {
        var json = JSON.parse(this.responseText);
        callback(json.difference_images);
      };
      url = this.compaaHost + '/artifacts.json';
      xhr.open('get', url, true);
      xhr.send();
    },

    init: function() {
      var self = this;
      this.attachButtonClickHandlers();
      //this.drawDifferenceCanvas();

      this.getDifferenceImages(function(differenceImages) {
        document.getElementById('animation').src = differenceImages[0];
        self.show('animation');
      });
    }
  };

  return Compaa;
})();
