<template>
  <v-btn color="info">
    <input
      @change="onChange"
      :accept="accept"
      class="file-input"
      type="file"
    >
    {{ inputText }}
  </v-btn>
</template>

<script>

// same code at https://github.com/dhhb/vue-base64-file-upload/blob/master/src/index.js
export default {
  name: 'VueBase64FileUpload',

  props: {
    inputText: {
      type: String,
      default: 'Add a new Image'
    },
    imageClass: {
      type: String,
      default: ''
    },
    inputClass: {
      type: String,
      default: ''
    },
    accept: {
      type: String,
      default: 'image/png,image/gif,image/jpeg'
    },
    maxSize: {
      type: Number,
      default: 10 // megabytes
    },
    disablePreview: {
      type: Boolean,
      default: false
    },
    fileName: {
      type: String,
      default: ''
    },
    placeholder: {
      type: String,
      default: 'Click here to upload image'
    },
    defaultPreview: {
      type: String,
      default: ''
    }
  },

  data() {
    return {
      file: null,
      preview: null,
      visiblePreview: false
    }
  },

  computed: {
    wrapperStyles() {
      return {
        'position': 'relative',
        'width': '100%'
      }
    },

    fileInputStyles() {
      return {
        'width': '100%',
        'position': 'absolute',
        'top': 0,
        'left': 0,
        'right': 0,
        'bottom': 0,
        'opacity': 0,
        'overflow': 'hidden',
        'outline': 'none',
        'cursor': 'pointer'
      }
    },

    previewImage() {
      return this.preview || this.defaultPreview
    }
  },
  mounted() {
    if (!window.FileReader) {
      // eslint-disable-next-line no-console
      console.error('Your browser does not support FileReader API!')
    }
  },
  methods: {
    onChange(e) {
      const files = e.target.files || e.dataTransfer.files

      if (!files.length) {
        return
      }

      const file = files[0]
      const size = file.size && (file.size / Math.pow(1000, 2))

      // check file max size
      if (size > this.maxSize) {
        this.$emit('size-exceeded', size)
        return
      }

      // update file
      this.file = file
      this.$emit('file', file)

      const reader = new FileReader()

      reader.onload = (e) => {
        const dataURI = e.target.result

        if (dataURI) {
          this.$emit('load', dataURI)

          this.preview = dataURI
        }
      }

      // read blob url from file data
      reader.readAsDataURL(file)
    }
  }
}

</script>
<style>
.file-input {
  width: 100%;
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  opacity: 0;
  overflow: hidden;
  outline: none;
  cursor: hand
}
</style>
