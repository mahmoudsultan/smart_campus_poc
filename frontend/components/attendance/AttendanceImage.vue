<template>
  <v-container fluid grid-list-xs class="ma-0 pa-0">
    <v-layout xs12 v-resize="drawCanvas" column>
      <v-flex id="canvas-container" class="parent">
        <div>
          <v-img id="attendance-image" :src="image"/>
        </div>
        <div class="layer">
          <canvas id="attendance-canvas"></canvas>
        </div>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
const _ = require('lodash')

export default {
  props: {
    image: String,
    faceBoxes: Array
  },
  data() {
    return {
      recognizedRGBA: 'rgba(46, 204, 113, 1)',
      detectedRGBA: 'rgba(247, 202, 24, 1)',
      ratio: 1,
      imageObj: null,
      offScreenCanvas: null
    }
  },
  methods: {
    async drawCanvas() {
      if (!this.imageObj) {
        this.imageObj = await this.loadImageObject()
      }
      this.updateCanvasWidthAndHeight()
      this.offScreenCanvas = this.buildOffScreenCanvas()
      this.drawFaceBoxes()
    },
    updateCanvasWidthAndHeight() {
      // Update canvas width
      const attendanceImage = document.getElementById('attendance-image')
      const canvas = document.getElementById('attendance-canvas')
      canvas.width = attendanceImage.clientWidth
      // Image class height is initially zero so the 1 is needed
      // to avoid Rendering a zero-height canvas exception
      canvas.height = attendanceImage.clientHeight || 1

      this.ratio = canvas.width / this.imageObj.width
    },
    faceBoxDimensions(faceBox) {
      const [x1, y1, x2, y2] = _.map(faceBox.boundries.split(','), (v) => {
        return Number.parseInt(v) * this.ratio
      })
      const width = x2 - x1
      const height = y2 - y1

      return [x1, y1, width, height]
    },
    drawFaceBoxes() {
      const canvas = document.getElementById('attendance-canvas')
      const offScreenCtx = this.offScreenCanvas.getContext('2d')

      this.faceBoxes.forEach((faceBox) => {
        const [x1, y1, width, height] = this.faceBoxDimensions(faceBox)
        if (faceBox.student_id) {
          offScreenCtx.strokeStyle = this.recognizedRGBA
        } else {
          offScreenCtx.strokeStyle = this.detectedRGBA
        }
        offScreenCtx.strokeRect(x1, y1, width, height)
      })

      canvas.getContext('2d').drawImage(this.offScreenCanvas, 0, 0)
    },
    handleMouseDownOnCanvas(event) {
      const clickX = event.layerX
      const clickY = event.layerY

      this.buildOffScreenImageCanvas()
      const faceBoxIndex = this.getFaceBoxIndexByPoint(clickX, clickY)
      if (faceBoxIndex !== -1) {
        this.$emit('facebox-click', faceBoxIndex,
          this.getFaceBoxImageData(this.faceBoxes[faceBoxIndex]))
      }
    },
    getFaceBoxIndexByPoint(clickX, clickY) {
      return _.findIndex(this.faceBoxes, (facebox) => {
        return this.checkInFaceBox(facebox, clickX, clickY)
      })
    },
    checkInFaceBox(faceBox, x, y) {
      const [x1, y1, width, height] = this.faceBoxDimensions(faceBox)

      return ((x1 <= x) && (x <= x1 + width)) && ((y1 <= y) && (y <= y1 + height))
    },
    loadImageObject() {
      return new Promise((resolve, reject) => {
        const img = new window.Image()
        img.src = this.image

        img.onload = () => {
          resolve(img)
        }
      })
    },
    buildOffScreenCanvas() {
      const canvas = document.getElementById('attendance-canvas')
      const offScreenCanvas = document.createElement('canvas')
      offScreenCanvas.height = canvas.height
      offScreenCanvas.width = canvas.width
      return offScreenCanvas
    },
    buildOffScreenImageCanvas() {
      if (!this.offScreenImageCanvas) {
        this.offScreenImageCanvas = document.createElement('canvas')
        this.offScreenImageCanvas.height = this.imageObj.height
        this.offScreenImageCanvas.width = this.imageObj.width
        this.offScreenImageCanvas.getContext('2d').drawImage(this.imageObj, 0, 0)
      }
    },
    getFaceBoxImageData(faceBox) {
      const [x, y, width, height] = this.faceBoxDimensions(faceBox)
      return this.offScreenImageCanvas.getContext('2d').getImageData(x, y, width, height)
    }
  },
  async mounted() {
    await this.drawCanvas()

    const canvas = document.getElementById('attendance-canvas')
    canvas.addEventListener('mousedown', this.handleMouseDownOnCanvas)
  }
}
</script>

<style scoped>
.parent {
  position: relative;
  padding: 10px;
  width: 100%;
  overflow-wrap: normal;
}
.layer {
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
}
.filler {
  position: relative;
  width: 100%;
  height: 100%;
}
canvas {
  z-index: 5000;
}
</style>
