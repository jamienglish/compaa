var Compaa = (function() {
  var Compaa = function() {
    this.imageTypes = ['difference', 'animation', 'oldImage', 'newImage'];
    this.compaaHost = '';
    this.counter = 0;
    this.differenceImages = [];
  };

  Compaa.prototype = {
    currentDifferenceImage: function() {
      return _.first($('#animation')).src;
    },

    setCurrentDifferenceImage: function(newSrc) {
      _.first($('#animation')).src = newSrc;
    },

    differenceGifPath: function() {
      return this.currentDifferenceImage();
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

    generatedImageFromDifferenceImage: function(differenceImagePath) {
      return differenceImagePath
        .replace('differences_in_screenshots_this_run', 'screenshots_generated_this_run')
        .replace('_difference.gif', '');
    },

    show: function(mode) {
      _.each(this.imageTypes, function(type) {
        $('#' + type).hide();
      });

      $('#' + mode).show();
    },

    attachButtonClickHandlers: function() {
      var self = this;

      _.each(this.imageTypes, function(element) {
        $('#' + element + 'Button').click(function(evt) {
          evt.preventDefault();
          self.show(element);
        });
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

    pathFromUrl: function(url) {
      var a = document.createElement('a');
      a.href = url;
      return a.pathname;
    },

    acceptImage: function() {
      var url, xhr, self;

      self = this;
      xhr  = new XMLHttpRequest();
      url  = self.compaaHost + '/screenshots?filepath=' + this.pathFromUrl(this.newImagePath());

      xhr.onload = function() {
        var nextImage = self.nextDifferenceImage();
        if (nextImage) {
          self.setCurrentDifferenceImage(nextImage);
        } else {
          var h1 = document.createElement('h1');
          var text = document.createTextNode('Done!');
          h1.appendChild(text);
          document.body.insertBefore(h1, document.body.childNodes[0]);
        }
      };

      xhr.open('POST', url, true);
      xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

      xhr.send();
    },

    attachAcceptClickHandler: function() {
      var self = this;

      document.getElementById('accept').addEventListener('click', function(evt) {
        evt.preventDefault();
        self.acceptImage();
      }, false);
    },

    nextDifferenceImage: function() {
      this.counter += 1;
      return this.differenceImages[this.counter];
    },

    setAnimationImage: function() {
      this.setCurrentDifferenceImage(this.differenceImages[0]);
      this.show('animation');
    },

    init: function() {
      var self = this;
      this.attachButtonClickHandlers();
      //this.drawDifferenceCanvas();
      $.getJSON(this.compaaHost + '/artifacts.json', function(json) {
        self.differenceImages = json.difference_images;
        self.setAnimationImage();
      });
      this.attachAcceptClickHandler();
    }
  };

  return Compaa;
})();
