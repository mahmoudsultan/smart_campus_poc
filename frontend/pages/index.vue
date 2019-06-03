<template>
  <v-container
    fill-height
    fluid
    grid-list-xl
  >
    <v-layout
      justify-center
      wrap
    >
      <v-flex
        xs12
        md8
      >
        <v-form>
          <v-container py-0>
            <v-layout wrap>
              <v-flex
                xs12
                md4
              >
                <v-text-field
                  :value="user.department"
                  label="Department"
                  disabled
                />
              </v-flex>
              <v-flex
                xs12
                md4
              >
                <v-text-field
                  :value="user.name"
                  label="Name"
                />
              </v-flex>
              <v-flex
                xs12
                md4
              >
                <v-text-field
                  :value="user.email"
                  label="Email"
                />
              </v-flex>

              <v-flex
                xs12
                text-xs-right
              >
                <v-btn
                  class="mx-0 font-weight-light"
                  color="success"
                >
                  Update Profile
                </v-btn>
              </v-flex>
            </v-layout>
            <!-- <avatar-picker
              v-model="showAvatarPicker"
              :current-avatar="form.avatar"
              @selected="selectAvatar"
            /> -->
            <vue-base64-file-upload
              :max-size="customImageMaxSize"
              @size-exceeded="onSizeExceeded"
              @file="onFile"
              @load="onLoad"
              class="v1"
              accept="image/png,image/jpeg,image/jpg"
              image-class="v1-image"
              input-class="v1-image"
            />
          </v-container>
        </v-form>
      </v-flex>
      <v-flex
        xs12
        md4
      >
        <v-avatar
          slot="offset"
          class="mx-auto d-block"
          size="130"
        >
          <img
            :src="mainAvatar"
          >
        </v-avatar>
        <v-card-text class="text-xs-center">
          <h4 class="card-title font-weight-light">
            {{ user.name }}
          </h4>
          <h4 class="category text-gray font-weight-light">
            {{ user.role }}
          </h4>
          <h4 class="category text-gray font-weight-light">
            {{ user.department }}
          </h4>
        </v-card-text>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex'
// import AvatarPicker from '~/components/AvatarPicker'
import VueBase64FileUpload from '@/components/VueBase64FileUpload'

export default {
  components: { VueBase64FileUpload },
  data: function () {
    return {
      form: {
        firstName: 'John',
        lastName: 'Doe',
        contactEmail: 'john@doe.com',
        avatar: 'MALE_CAUCASIAN_BLOND_BEARD'
      },
      showAvatarPicker: true,
      customImageMaxSize: 3, // megabytes
      uploadImage: true
    }
  },

  computed: {
    ...mapGetters({ 'user': 'auth/user' }),
    mainAvatar() {
      return ''
      // return this.user.avatars.filter(a => a.is_main)[0]
    }

  },
  mounted() {
    // eslint-disable-next-line no-console
    console.log(this.user)
  },
  methods: {
    onFile(file) {
      // eslint-disable-next-line no-console
      console.log(file) // file object
    },

    onLoad(dataUri) {
      // eslint-disable-next-line no-console
      console.log(dataUri) // data-uri string
    },

    onSizeExceeded(size) {
      alert(`Image ${size}Mb size exceeds limits of ${this.customImageMaxSize}Mb!`)
    },
    selectAvatar(avatar) {

    },
    openAvatarPicker() {
      this.showAvatarPicker = true
    }
  }

}
</script>
