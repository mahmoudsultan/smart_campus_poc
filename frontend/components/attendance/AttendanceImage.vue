<template>
  <v-container fluid grid-list-xs class="ma-0 pa-0">
    <v-layout v-resize="drawCanvas" xs12 column>
      <v-flex id="canvas-container" class="parent">
        <v-tooltip bottom class="layer">
          <!-- eslint-disable-next-line -->
          <template v-slot:activator="{ on }">
            <v-btn v-on="on" @click="refreshFaceBoxes" class="refresh-btn" color="grey lighten-5">
              <v-icon>refresh</v-icon>
            </v-btn>
          </template>
          <span>Redraw Faceboxes</span>
        </v-tooltip>
        <div>
          <v-img :id="attendanceImageId" :src="image"/>
        </div>
        <div class="layer">
          <canvas :id="drawCanvasId"></canvas>
        </div>
        <div class="layer">
          <canvas :id="attendanceCanvasId"></canvas>
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
    faceBoxes: Array,
    drawMode: Boolean,
    allColor: {
      type: String,
      required: false
    }
    // redraw: {
    //   type: Boolean,
    //   required: false
    // }
  },
  data() {
    return {
      recognizedRGBA: 'rgba(46, 204, 113, 1)',
      detectedRGBA: 'rgba(247, 202, 24, 1)',
      ratio: 1,
      imageObj: null,
      offScreenCanvas: null,
      boxStartCorner: null,
      boxEndCorner: null,
      drawStage: 0,
      scratchPadCanvas: null,
      offScreenImageCanvas: null
    }
  },
<<<<<<< HEAD
  async mounted() {
    await this.drawCanvas()
    this.buildOffScreenImageCanvas()

    const canvas = document.getElementById('attendance-canvas')
    canvas.addEventListener('mousedown', this.handleMouseDownOnCanvas)
    canvas.addEventListener('mousemove', this.handleMouseMoveOnCanvas)

    this.scratchPadCanvas = document.getElementById('draw-canvas')

    document.addEventListener('keyup', this.handleKeyUp)
=======
  computed: {
    attendanceImageId() {
      return 'attendance-image' + this._uid
    },
    drawCanvasId() {
      return 'draw-canvas' + this._uid
    },
    attendanceCanvasId() {
      return 'attendance-canvas' + this._uid
    },
    detectedColor() {
      return this.allColor || this.detectedRGBA
    },
    recognizedColor() {
      return this.allColor || this.recognizedRGBA
    }
>>>>>>> ef0fc05... Attendance Issues. Return Base64 Image in Attendance Sheet.
  },
  methods: {
    async drawCanvas() {
      if (!this.imageObj) {
        this.imageObj = await this.loadImageObject()
      }
      this.updateCanvasWidthAndHeight()
      this.offScreenCanvas = this.buildOffScreenCanvas()
      if (this.offScreenCanvas.height && this.offScreenCanvas.width) {
        this.drawFaceBoxes()
      }
    },
    updateCanvasWidthAndHeight() {
      // Update canvas width
      const attendanceImage = document.getElementById(this.attendanceImageId)
      const canvas = document.getElementById(this.attendanceCanvasId)
      canvas.width = attendanceImage.clientWidth
      // Image class height is initially zero so the 1 is needed
      // to avoid Rendering a zero-height canvas exception
      canvas.height = attendanceImage.clientHeight || 1

      this.ratio = canvas.width / this.imageObj.width
    },
    updateScratchPadCanvasWidthAndHeight() {
<<<<<<< HEAD
      const attendanceImage = document.getElementById('attendance-image')
=======
      const attendanceImage = document.getElementById(this.attendanceImageId)

>>>>>>> ef0fc05... Attendance Issues. Return Base64 Image in Attendance Sheet.
      this.scratchPadCanvas.width = attendanceImage.clientWidth
      this.scratchPadCanvas.height = attendanceImage.clientHeight
    },
    faceBoxDimensions(faceBox) {
      console.log('faceBoxDimension()', faceBox) // eslint-disable-line
      const [x1, y1, x2, y2] = _.map(faceBox.boundaries.split(','), (v) => {
        return Number.parseInt(v) * this.ratio
      })
      const width = x2 - x1
      const height = y2 - y1

      return [x1, y1, width, height]
    },
    faceBoxDimensionsNotRatioed(faceBox) {
      console.log('faceBoxDimensionsNotRatioed()', faceBox) // eslint-disable-line
      const [x1, y1, x2, y2] = _.map(faceBox.boundaries.split(','), (v) => {
        return Number.parseInt(v)
      })
      const width = x2 - x1
      const height = y2 - y1
      return [x1, y1, width, height]
    },
    drawFaceBoxes() {
      const canvas = document.getElementById(this.attendanceCanvasId)
      const offScreenCtx = this.offScreenCanvas.getContext('2d')

      this.faceBoxes.forEach((faceBox) => {
        const [x1, y1, width, height] = this.faceBoxDimensions(faceBox)
        if (faceBox.student_id) {
          offScreenCtx.strokeStyle = this.recognizedColor
        } else {
          offScreenCtx.strokeStyle = this.detectedColor
        }
        offScreenCtx.strokeRect(x1, y1, width, height)
      })

      canvas.getContext('2d').drawImage(this.offScreenCanvas, 0, 0)
    },
    canvasCoordsToImageCoords([x, y]) {
      return [x / this.ratio, y / this.ratio]
    },
    handleMouseDownOnCanvas(event) {
      const clickX = event.layerX
      const clickY = event.layerY

      if (this.drawMode) {
        if (this.drawStage === 0 || this.drawStage === 2) {
          this.boxStartCorner = [clickX, clickY]
          this.drawStage = 1
          this.$emit('facebox-canceled')
        } else {
          this.boxEndCorner = [clickX, clickY]
          this.drawStage = 2
          this.$emit('facebox-drawn', this.canvasCoordsToImageCoords(this.boxStartCorner),
            this.canvasCoordsToImageCoords(this.boxEndCorner))
        }
      } else {
        this.buildOffScreenImageCanvas()
        const faceBoxIndex = this.getFaceBoxIndexByPoint(clickX, clickY)
        const faceBox = this.faceBoxes[faceBoxIndex]
        if (faceBoxIndex !== -1) {
          const [x, y, width, height] = this.faceBoxDimensionsNotRatioed(faceBox)
          this.$emit('facebox-click', faceBoxIndex,
            this.getFaceBoxImageBase64(x, y, width, height))
        }
      }
    },
    handleMouseMoveOnCanvas(event) {
      const clickX = event.layerX
      const clickY = event.layerY

      if (this.drawMode && this.drawStage === 1) {
        this.boxEndCorner = [clickX, clickY]
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
        img.crossOrigin = 'Anonymous'

        img.onload = () => {
          resolve(img)
        }
      })
    },
    buildOffScreenCanvas() {
      const canvas = document.getElementById(this.attendanceCanvasId)
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
    getFaceBoxImageData(x, y, width, height) {
      return this.offScreenImageCanvas.getContext('2d').getImageData(x, y, width, height)
    },
    getFaceBoxImageBase64(x, y, width, height) {
      const imageData = this.getFaceBoxImageData(x, y, width, height)
      const canvas = document.createElement('canvas')
      canvas.width = imageData.width
      canvas.height = imageData.height
      canvas.getContext('2d').putImageData(imageData, 0, 0)

      return canvas.toDataURL('image/png')
    },
    handleKeyUp(event) {
      if (event.key === 'Escape') {
        this.boxStartCorner = null
        this.drawStage = 0

        const ctx = this.scratchPadCanvas.getContext('2d')
        ctx.clearRect(0, 0, this.scratchPadCanvas.width, this.scratchPadCanvas.height)
      }
    },
    async refreshFaceBoxes() {
      await this.drawCanvas()
    }
  },
<<<<<<< HEAD
=======
  async mounted() {
    await this.drawCanvas()
    this.buildOffScreenImageCanvas()

    const canvas = document.getElementById(this.attendanceCanvasId)
    canvas.addEventListener('mousedown', this.handleMouseDownOnCanvas)
    canvas.addEventListener('mousemove', this.handleMouseMoveOnCanvas)

    this.scratchPadCanvas = document.getElementById(this.drawCanvasId)

    document.addEventListener('keyup', this.handleKeyUp)
  },
>>>>>>> ef0fc05... Attendance Issues. Return Base64 Image in Attendance Sheet.
  watch: {
    boxEndCorner: function (val) {
      // Clear Canvas and Draw New Rectangle
      const ctx = this.scratchPadCanvas.getContext('2d')
      ctx.clearRect(0, 0, this.scratchPadCanvas.width, this.scratchPadCanvas.height)

      if (val != null) {
        const [x1, y1] = this.boxStartCorner
        const [x2, y2] = this.boxEndCorner
        const width = x2 - x1
        const height = y2 - y1
        ctx.strokeStyle = '#ffffff'
        ctx.strokeRect(x1, y1, width, height)
      }
    },
    drawMode: function (val) {
      if (!val) {
        this.drawStage = 0
        this.boxStartCorner = null
        this.boxEndCorner = null

        this.scratchPadCanvas.style.cursor = 'pointer'
      } else {
        this.updateScratchPadCanvasWidthAndHeight()
        this.scratchPadCanvas.style.cursor = 'crosshair'
      }
    }
    // redraw: async function (val) {
    //   if (val) {
    //     // eslint-disable-next-line
    //     console.log('Triggered')
    //     await this.drawCanvas()
    //     this.redraw = false
    //   }
    // }
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
  cursor: pointer;
}

#draw-canvas {
  z-index: 3000;
}

.refresh-btn {
  position: absolute;
  top: 0;
  right: 0;
  z-index: 1;
  opacity: 0.8;
}

</style>
