import _ from 'lodash'

export const AttendanceImageMixin = {
  data() {
    return {
      offScreenImageCanvas: null
    }
  },
  methods: {
    loadImageObject(image) {
      return new Promise((resolve, reject) => {
        const img = new window.Image()
        img.src = image
        img.crossOrigin = 'Anonymous'

        img.onload = () => {
          resolve(img)
        }
      })
    },
    faceBoxDimensions(faceBox) {
      const [x1, y1, x2, y2] = _.map(faceBox.boundaries.split(','), (v) => {
        return Number.parseInt(v)
      })
      const width = x2 - x1
      const height = y2 - y1

      return [x1, y1, width, height]
    },
    buildOffScreenImageCanvas(imageObj) {
      console.log(imageObj) // eslint-disable-line
      const canvas = document.createElement('canvas')
      canvas.height = imageObj.height
      canvas.width = imageObj.width
      canvas.getContext('2d').drawImage(imageObj, 0, 0)

      return canvas
    },
    getFaceBoxImageData(imageObj, x, y, width, height) {
      if (!this.offScreenImageCanvas) {
        this.offScreenImageCanvas = this.buildOffScreenImageCanvas(imageObj)
      }
      return this.offScreenImageCanvas.getContext('2d').getImageData(x, y, width, height)
    },
    getFaceBoxImageBase64(imageObj, x, y, width, height) {
      const imageData = this.getFaceBoxImageData(imageObj, x, y, width, height)
      const canvas = document.createElement('canvas')
      canvas.width = imageData.width
      canvas.height = imageData.height
      canvas.getContext('2d').putImageData(imageData, 0, 0)

      return canvas.toDataURL('image/png')
    },
    getImageFullPath(imageRelativePath) {
      return this.$axios.defaults.baseURL + imageRelativePath
    }
  }
}
