var Compaa = {
  imageTypes: ['difference', 'animation', 'referenceImage', 'generatedImage'],
  compaaHost: '',

  setArtifacts: function(artifacts) {
    this.artifacts = artifacts;
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

  supportsBlending: function() {
    return window.navigator.userAgent.indexOf('Firefox/2') !== -1;
  },

  drawDifferenceCanvas: function() {
    var self = this,
        generatedImage = new Image(),
        referenceImage = new Image(),
        context = document.getElementById('difference').getContext('2d');

    $(referenceImage).load(function() {
      $(generatedImage).load(function() {
        $('#difference')
          .attr('width',  referenceImage.width)
          .attr('height', referenceImage.height);

        if (self.supportsBlending()) {
          context.globalCompositeOperation = 'difference';
        } else {
          context.globalAlpha = 0.5;
        }
        context.drawImage(referenceImage, 0, 0);
        context.drawImage(generatedImage, 0, 0);
      });

      generatedImage.src = self.generatedImagePath();
    });

    referenceImage.src = this.referenceImagePath();
  },

  acceptImage: function() {
    var self = this,
        url  = this.compaaHost + '/screenshots?filepath=' + this.generatedImagePath();

    $.post(url, function() {
      self.moveToNextArtifact();
    });
  },

  rejectImage: function() {
    this.moveToNextArtifact();
  },

  moveToNextArtifact: function() {
    var nextArtifact = this.nextArtifact();

    if (nextArtifact) {
      this.setDifferenceImage();
      this.setGeneratedImage();
      this.setReferenceImage();
      this.drawDifferenceCanvas();
    } else {
      this.endGame();
    }
  },

  attachAcceptClickHandler: function() {
    var self = this;

    $('#accept').click(function(e) {
      e.preventDefault();
      self.acceptImage();
    });
  },

  attachRejectClickHandler: function() {
    var self = this;

    $('#reject').click(function(e) {
      e.preventDefault();
      self.rejectImage();
    });
  },

  nextArtifact: function() {
    this.artifacts.shift();
    return this.currentArtifact();
  },

  setGeneratedImage: function() {
    document.getElementById('generatedImage').src = this.generatedImagePath();
  },

  setReferenceImage: function() {
    document.getElementById('referenceImage').src = this.referenceImagePath();
  },

  setDifferenceImage: function() {
    document.getElementById('animation').src = this.differenceGifPath();
  },

  differenceGifPath: function() {
    return this.referenceImagePath()
      .replace('reference_screenshots', 'differences_in_screenshots_this_run') + '_difference.gif';
  },

  referenceImagePath: function() {
    return this.currentArtifact();
  },

  generatedImagePath: function() {
    return this.referenceImagePath()
      .replace('reference_screenshots', 'screenshots_generated_this_run');
  },

  currentArtifact: function() {
    return this.artifacts[0];
  },

  setAnimationImage: function() {
    document.getElementById('animation').src = this.differenceGifPath();
  },

  endGame: function() {
    $('body').replaceWith('<h1>Done!</h1>');
  },

  init: function() {
    var self = this;

    this.attachButtonClickHandlers();
    this.attachAcceptClickHandler();
    this.attachRejectClickHandler();

    $.getJSON(this.compaaHost + '/artifacts.json', function(json) {
      self.setArtifacts(json.artifacts);

      self.drawDifferenceCanvas();
      self.setAnimationImage();
      self.setGeneratedImage();
      self.setReferenceImage();
      self.show('difference');
    });
  }
};
