var Compaa = {
  imageTypes: ['difference', 'animation', 'referenceImage', 'generatedImage'],
  compaaHost: '',

  init: function() {
    this.attachClickHandlers();

    $.getJSON(this.compaaHost + '/artifacts.json', function(json) {
      this.setArtifacts(json.artifacts);
      this.paintThePicture();
    }.bind(this));
  },

  attachClickHandlers: function() {
    this.attachButtonClickHandlers();
    this.attachAcceptClickHandler();
    this.attachRejectClickHandler();
  },

  setArtifacts: function(artifacts) {
    this.artifacts = artifacts;
  },

  paintThePicture: function() {
    this.drawDifferenceCanvas();
    this.setDifferenceImage();
    this.setGeneratedImage();
    this.setReferenceImage();
    this.show('generatedImage');
  },

  show: function(mode) {
    this.imageTypes.forEach(function(type) {
      $(document.getElementById(type)).hide();
    });

    $(document.getElementById(mode)).show();
  },

  attachButtonClickHandlers: function() {
    this.imageTypes.forEach(function(element) {
      document.getElementById(element + 'Button').onclick = function(evt) {
        evt.preventDefault();
        this.show(element);
      }.bind(this);
    }, this);
  },

  supportsBlending: function() {
    return window.navigator.userAgent.indexOf('Firefox/2') !== -1;
  },

  drawDifferenceCanvas: function() {
    var generatedImage = new Image(),
        referenceImage = new Image(),
        context = document.getElementById('difference').getContext('2d');

    $([referenceImage, generatedImage]).error(function() {
      document.getElementById('difference').width = 0;
      document.getElementById('difference').height = 0;
    });

    $(referenceImage).load(function() {
      $(generatedImage).load(function() {
        document.getElementById('difference').width = referenceImage.width;
        document.getElementById('difference').height = referenceImage.height;

        if (this.supportsBlending()) {
          context.globalCompositeOperation = 'difference';
        } else {
          context.globalAlpha = 0.5;
        }

        context.drawImage(referenceImage, 0, 0);
        context.drawImage(generatedImage, 0, 0);
      }.bind(this));

      generatedImage.src = this.generatedImagePath();
    }.bind(this));

    referenceImage.src = this.referenceImagePath();
  },

  acceptImage: function() {
    var url = this.compaaHost + '/screenshots?filepath=' + this.generatedImagePath();

    $.post(url, function() {
      this.moveToNextArtifact();
    }.bind(this));
  },

  rejectImage: function() {
    this.moveToNextArtifact();
  },

  moveToNextArtifact: function() {
    this.artifacts.shift();

    if (this.currentArtifact()) {
      this.paintThePicture();
    } else {
      this.endGame();
    }
  },

  attachAcceptClickHandler: function() {
    document.getElementById('accept').onclick = function(evt) {
      evt.preventDefault();
      this.acceptImage();
    }.bind(this);
  },

  attachRejectClickHandler: function() {
    document.getElementById('reject').onclick = function(evt) {
      evt.preventDefault();
      this.rejectImage();
    }.bind(this);
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

  endGame: function() {
    document.body.innerHTML = '<h1>Done!</h1>';
  }
};
